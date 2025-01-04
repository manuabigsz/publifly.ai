import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../features/auth/presentation/auth_page.dart';
import '../../features/home_page/home_config/home_config.dart';
import '../../shared/providers/auth.dart';

class AuthOrHomePage extends StatelessWidget {
  const AuthOrHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context);

    // Mostra um indicador de carregamento enquanto o Firebase Auth está inicializando
    if (auth.isInitializing) {
      return const Center(child: CircularProgressIndicator());
    }

    // Exibe a página Home se o usuário estiver autenticado, caso contrário, exibe o AuthForm
    return auth.isAuth ? const HomePageGeral() : const AuthForm();
  }
}
