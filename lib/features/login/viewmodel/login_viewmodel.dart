import 'package:cosmoview/data/models/usuario.dart';
import 'package:cosmoview/features/login/repository/login_repository.dart';
import 'package:cosmoview/ui/mensagem_alerta.dart';
import 'package:cosmoview/core/navigation/nav.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../imagem_do_dia/view/imagem_view.dart';

class LoginViewModel {
  final LoginRepository repository;

  LoginViewModel(this.repository);

  // Controllers
  final emailController = TextEditingController();
  final senhaController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  // Focos
  final focusSenha = FocusNode();

  Future<void> logar(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;

    final email = emailController.text.trim();
    final senha = senhaController.text.trim();

    if (!EmailValidator.validate(email)) {
      MensagemAlerta(context, "Erro: Email inválido");
      return;
    }

    try {
      final user = await repository.login(email, senha);
      await _processarUsuario(user, context);
    } catch (e) {
      MensagemAlerta(context, "Erro ao realizar login: $e");
    }
  }

  Future<void> cadastrar(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;

    final email = emailController.text.trim();
    final senha = senhaController.text.trim();

    if (!EmailValidator.validate(email)) {
      MensagemAlerta(context, "Erro: Email inválido");
      return;
    }

    try {
      final user = await repository.cadastrar(email, senha);

      // Registrar usuário
      await repository.criarUsuario(email);

      await _processarUsuario(user, context);
    } catch (e) {
      MensagemAlerta(context, "Erro ao cadastrar: $e");
    }
  }

  Future<void> _processarUsuario(User? firebaseUser, BuildContext context) async {
    if (firebaseUser == null || firebaseUser.email == null) {
      MensagemAlerta(context, "Erro: usuário inválido");
      return;
    }

    try {
      final doc = await repository.buscarUsuario(firebaseUser.email!);

      Usuario usuario = Usuario();

      if (doc != null) {
        usuario = Usuario.fromMap(doc.data()!);
        usuario.id = doc.id;
      } else {
        final id = await repository.criarUsuario(firebaseUser.email!);
        usuario.login = firebaseUser.email;
        usuario.id = id;
      }

      push(context, TelaPrincipal(usuario), replace: true);
    } catch (e) {
      MensagemAlerta(context, "Erro ao processar usuário: $e");
    }
  }
}
