// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:io';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// ignore: depend_on_referenced_packages
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../shared/providers/user_provider.dart';
import '../model/user_model.dart';

import 'package:flutter/foundation.dart'; // Importe o pacote
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

import 'auth_datasource_interface.dart';

class AuthFirebaseDatasourceImpl implements IAuthDatasource {
  static CurrentUser? _currentUser;

  static final _userStream = Stream<CurrentUser?>.multi((controller) async {
    final authChanges = FirebaseAuth.instance.authStateChanges();
    await for (final user in authChanges) {
      _currentUser = user == null ? null : _toCurrentUser('', user);
      controller.add(_currentUser);
    }
  });

  @override
  CurrentUser? get currentUser {
    return _currentUser;
  }

  @override
  Stream<CurrentUser?> get userChanges {
    return _userStream;
  }

  @override
  Future<void> signup(
    String nome,
    String email,
    String password,
    BuildContext context,
  ) async {
    final signup = await Firebase.initializeApp(
      name: 'userSignup',
      options: Firebase.app().options,
    );

    final auth = FirebaseAuth.instanceFor(app: signup);

    UserCredential credential = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (credential.user != null) {
      await credential.user?.updateDisplayName(nome);

      _currentUser = _toCurrentUser(
        '', // Tipo de usuário
        credential.user!, // Usuário do Firebase
        nome, // Nome do usuário
        null, // Nenhuma imagem fornecida
        null, // Nenhum UID fornecido, será usado o do usuário Firebase
      );

      // Salva o usuário no armazenamento local ou no banco de dados
      await _saveCurrentUser(_currentUser!, credential.user!.uid.toString());

      // Faz login automaticamente após o signup
      await login(
        context,
        email,
        password,
      );
    }

    // Deleta a instância temporária do Firebase App após o signup
    await signup.delete();
  }

  @override
  Future<void> login(
    BuildContext context,
    String email,
    String password,
  ) async {
    try {
      final authResult = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (authResult.user != null) {
        final uid = authResult.user!.uid;

        final userQuery = FirebaseFirestore.instance
            .collection('usuarios')
            .where('uid', isEqualTo: uid);

        final userSnapshot = await userQuery.get();

        if (userSnapshot.docs.isNotEmpty) {
          final userData = userSnapshot.docs.first.data();
          final currentUser = CurrentUser(
            id: userSnapshot.docs.first.id,
            nome: userData['nome'],
            email: userData['email'],
            logoUrl: userData['logoUrl'],
            uid: userData['uid'],
            dataCadastro: userData['data_cadastro'],
          );

          final currentUserProvider =
              Provider.of<CurrentUserProvider>(context, listen: false);
          currentUserProvider.setCurrentUser(currentUser);
        } else {
          throw FirebaseAuthException(
            code: 'user-not-found',
            message: 'Usuário com o UID e tipoUser fornecidos não encontrado.',
          );
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      print('Erro ao sair da conta: $e');
    }
  }

  Future<String?> uploadUserImage(File? image, String imageName) async {
    if (image == null) return null;

    final storage = FirebaseStorage.instance;
    final ref = storage.ref().child('user_images').child(imageName);

    if (!kIsWeb) {
      await ref.putFile(image);
    } else {
      final imageBytes = await image.readAsBytes();
      final uploadTask = ref.putData(imageBytes);
      await uploadTask.then((snapshot) {});
    }

    return await ref.getDownloadURL();
  }

  Uuid uuid = const Uuid();

  String generateId() {
    String uniqueId = uuid.v4();
    String id = uniqueId
        .substring(0, 4)
        .toUpperCase(); // Extrair os primeiros 4 caracteres
    return id;
  }

  Future<void> _saveCurrentUser(CurrentUser user, String vddUid) async {
    DateTime now = DateTime.now();
    String dataAtualFormatada = DateFormat('yyyy-MM-dd').format(now);

    final store = FirebaseFirestore.instance;
    // final uid = generateId();

    final docRef = store.collection('usuarios').doc(vddUid);

    await docRef.set({
      // Salva o ID gerado
      'nome': user.nome,
      'email': user.email,
      'logoUrl': user.logoUrl,
      'uid': vddUid,
      'data_cadastro': dataAtualFormatada,
    });
    print("Usuário salvo com sucesso!");
  }

  static CurrentUser _toCurrentUser(
    String? tipoUser,
    User user, [
    String? name,
    String? imageUrl,
    String? uid,
  ]) {
    return CurrentUser(
      uid: uid ?? user.uid,
      email: user.email ?? '',
      nome: name ?? user.displayName ?? 'Usuário',
      logoUrl: imageUrl ?? '',
      dataCadastro: '',
      id: user.uid,
    );
  }
}
