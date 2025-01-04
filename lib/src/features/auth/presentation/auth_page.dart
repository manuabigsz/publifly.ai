// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:publifly_ai/src/shared/theme/app_colors.dart';
import '../../../data/auth/data/datasource/auth_datasource_interface.dart';
import '../../../shared/widgets/app_name.dart';
import '../../home_page/home_config/home_config.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  bool isSignup = false;
  bool forgotPassword = false;
  bool _obscureText = true;
  bool _obscureText2 = true;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _togglePasswordVisibility2() {
    setState(() {
      _obscureText2 = !_obscureText2;
    });
  }

  Future<void> _handleSubmit() async {
    try {
      // Verifica se todos os campos obrigatórios estão preenchidos
      if ((_emailController.text.isEmpty || _passwordController.text.isEmpty) &&
          isSignup) {
        throw 'Por favor, preencha todos os campos obrigatórios.';
      }

      if ((_emailController.text.isEmpty || _passwordController.text.isEmpty) &&
          !isSignup) {
        throw 'Por favor, preencha todos os campos obrigatórios.';
      }

      // Verifica se está no modo de registro ou login
      if (isSignup) {
        // Verifica se as senhas coincidem
        if (_passwordController.text != _confirmPasswordController.text) {
          throw 'As senhas não coincidem.';
        }

        // Realiza o registro do usuário
        await IAuthDatasource().signup(
          _nameController.text,
          _emailController.text,
          _passwordController.text,
          context,
        );
      } else {
        await IAuthDatasource().login(
          context,
          _emailController.text,
          _passwordController.text,
        );
      }
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const HomePageGeral(),
        ),
        (route) => false,
      );
    } catch (error) {
      String errorMessage = 'Ocorreu um erro ao autenticar.';

      if (error is FirebaseAuthException) {
        if (error.code == 'user-not-found' || error.code == 'wrong-password') {
          errorMessage = 'Credenciais inválidas. Verifique seu email e senha.';
        } else if (error.code == 'invalid-email') {
          errorMessage = 'O endereço de email está mal formatado.';
        } else {
          errorMessage = error.message ?? 'Erro desconhecido';
        }
      } else {
        errorMessage = error.toString();
      }

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Erro'),
            content: Text(errorMessage),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );

      // Retorna imediatamente após mostrar o erro para impedir a navegação
      return;
    }
  }

  Future<void> _resetPassword() async {
    try {
      //   await FirebaseAuth.instance
      //       .sendPasswordResetEmail(email: _emailController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Um email para resetar sua senha foi enviado para ${_emailController.text}'),
        ),
      );
      setState(() {
        forgotPassword = false;
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Erro ao enviar email de reset de senha para o email ${_emailController.text}'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cinzaClaro,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: AppColors.cinzaClaro,
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const AppNameWidget(),
                    if (isSignup) ...[
                      const Row(
                        children: [
                          Text(
                            'Nome completo',
                            style: TextStyle(
                              color: AppColors.logoColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          hintText: 'Nome completo',
                          hintStyle: const TextStyle(color: Color(0xffA3AFB2)),
                          filled: true,
                          fillColor: Colors.grey.withOpacity(0.2),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        style: const TextStyle(color: AppColors.logoColor),
                      ),
                      const SizedBox(height: 20),
                    ],
                    const Row(
                      children: [
                        Text(
                          'Email',
                          style: TextStyle(
                            color: AppColors.logoColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: 'Email',
                        hintStyle: const TextStyle(color: Color(0xffA3AFB2)),
                        filled: true,
                        fillColor: Colors.grey.withOpacity(0.2),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      style: const TextStyle(color: AppColors.logoColor),
                    ),
                    const SizedBox(height: 20),
                    if (!forgotPassword) ...[
                      const Row(
                        children: [
                          Text(
                            'Senha',
                            style: TextStyle(
                              color: AppColors.logoColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: _passwordController,
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                          hintText: 'Senha',
                          hintStyle: const TextStyle(color: Color(0xffA3AFB2)),
                          filled: true,
                          fillColor: Colors.grey.withOpacity(0.2),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: BorderSide.none,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureText
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: AppColors.logoColor,
                            ),
                            onPressed: _togglePasswordVisibility,
                          ),
                        ),
                        style: const TextStyle(color: AppColors.logoColor),
                      ),
                    ],
                    if (isSignup) ...[
                      const SizedBox(height: 20),
                      const Row(
                        children: [
                          Text(
                            'Confirme a senha',
                            style: TextStyle(
                              color: AppColors.logoColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: _confirmPasswordController,
                        obscureText: _obscureText2,
                        decoration: InputDecoration(
                          hintText: 'Confirme a senha',
                          hintStyle: const TextStyle(color: Color(0xffA3AFB2)),
                          filled: true,
                          fillColor: Colors.grey.withOpacity(0.2),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: BorderSide.none,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureText2
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: AppColors.logoColor,
                            ),
                            onPressed: _togglePasswordVisibility2,
                          ),
                        ),
                        style: const TextStyle(color: AppColors.logoColor),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                    const SizedBox(height: 10),
                    if (!isSignup)
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              isSignup = false;
                              forgotPassword = !forgotPassword;
                            });
                          },
                          child: Text(
                            !forgotPassword
                                ? 'Esqueceu a senha?'
                                : 'Entrar na conta',
                            style: const TextStyle(color: AppColors.logoColor),
                          ),
                        ),
                      ),
                    const SizedBox(height: 20),
                    if (!forgotPassword)
                      ElevatedButton(
                        onPressed: _handleSubmit,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          backgroundColor: AppColors.greenColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 40, right: 40),
                          child: Text(
                            isSignup ? 'Registrar' : 'Entrar',
                            style: const TextStyle(
                              color: AppColors.logoColor,
                            ),
                          ),
                        ),
                      ),
                    if (forgotPassword)
                      ElevatedButton(
                        onPressed: _resetPassword,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          backgroundColor: AppColors.greenColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.only(left: 40, right: 40),
                          child: Text(
                            'Enviar',
                            style: TextStyle(
                              color: AppColors.logoColor,
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(height: 40),
                    if (!forgotPassword)
                      Column(
                        children: [
                          const SizedBox(height: 20),
                          Align(
                            alignment: Alignment.center,
                            child: TextButton(
                              onPressed: () {
                                setState(() {
                                  forgotPassword = false;
                                  isSignup = !isSignup;
                                });
                              },
                              child: Text(
                                isSignup
                                    ? 'Já possui uma conta? Entre agora'
                                    : 'Ainda não possui conta? Registre-se agora',
                                style: const TextStyle(
                                  color: AppColors.logoColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
