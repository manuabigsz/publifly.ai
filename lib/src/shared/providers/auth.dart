// ignore_for_file: unused_field

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../exceptions/auth_exception.dart';

class Auth with ChangeNotifier {
  String? _token;
  String? _userId;
  String? _email;
  DateTime? _expiryDate;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? _user;
  bool _isInitializing = true;

  Auth() {
    _initializeAuth();
  }

  Future<void> _initializeAuth() async {
    _firebaseAuth.authStateChanges().listen((User? user) {
      _user = user;
      _isInitializing = false;
      notifyListeners();
    });
  }

  bool get isAuth => _user != null;
  bool get isInitializing => _isInitializing;
  User? get user => _user;

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  Future<void> _authenticate(
      String email, String password, bool isSignUp) async {
    UserCredential authResult;
    try {
      if (isSignUp) {
        authResult = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        authResult = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      }

      final user = authResult.user;
      if (user != null) {
        _token = await user.getIdToken();
        _email = user.email;
        _userId = user.uid;
        _expiryDate = DateTime.now().add(const Duration(hours: 1));

        notifyListeners();

        if (isSignUp) {
          final userDoc =
              FirebaseFirestore.instance.collection('pessoas').doc(_userId);
          await userDoc.set({
            'email': email,
            'createdAt': Timestamp.now(),
            'nome': '',
            'tipoFuncionario': '',
            'foto': '',
          });
        }
      }
    } on FirebaseAuthException catch (error) {
      throw AuthException(error.message ?? 'An error occurred');
    }
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, false);
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, true);
  }

  void logout() {
    _token = null;
    _userId = null;
    _email = null;
    _expiryDate = null;
    notifyListeners();
  }
}
