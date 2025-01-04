// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../data/auth/data/model/user_model.dart';

class CurrentUserProvider extends ChangeNotifier {
  CurrentUser? _currentUser;
  String? get userUid => _currentUser?.uid;
  String? get userNome => _currentUser?.nome;
  String? get userEmail => _currentUser?.email;

  void setCurrentUser(CurrentUser user) {
    _currentUser = user;
    notifyListeners();
  }

  CurrentUser? getCurrentUser() {
    return _currentUser;
  }

  Future<User?> getCurrentUserFirebase() async {
    return FirebaseAuth.instance.currentUser;
  }

  Future<CurrentUser?> buscaUsuarioAtual() async {
    try {
      final currentUser = await getCurrentUserFirebase();

      if (currentUser != null) {
        final uid = currentUser.uid;

        final userQuery = FirebaseFirestore.instance
            .collection('usuarios')
            .where('uid', isEqualTo: uid);

        final userSnapshot = await userQuery.get();

        if (userSnapshot.docs.isNotEmpty) {
          final userData = userSnapshot.docs.first.data();

          final currentUserDetails = CurrentUser(
            id: userSnapshot.docs.first.id,
            nome: userData['nome'],
            email: userData['email'],
            logoUrl: userData['logoUrl'],
            uid: userData['uid'],
            dataCadastro: userData['data_cadastro'],
          );

          setCurrentUser(currentUserDetails);

          return currentUserDetails;
        } else {
          print('Usuário não encontrado na coleção "usuarios"');
          return null;
        }
      } else {
        print('Nenhum usuário autenticado.');
        return null;
      }
    } catch (e) {
      print('Erro ao buscar usuário: $e');
      return null;
    }
  }
}
