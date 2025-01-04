import 'package:flutter/material.dart';
import '../model/user_model.dart';
import 'auth_firebase_datasource.dart';

abstract class IAuthDatasource {
  CurrentUser? get currentUser;

  Stream<CurrentUser?> get userChanges;

  Future<void> signup(
    String nome,
    String email,
    String password,
    BuildContext context,
  );

  Future<void> login(
    BuildContext context,
    String email,
    String password,
  );

  Future<void> logout();

  factory IAuthDatasource() {
    return AuthFirebaseDatasourceImpl();
  }
}
