import 'package:cosmoview/dominio/usuario.dart';
import 'package:cosmoview/util/nav.dart';
import 'package:cosmoview/util/widget/mensagem_alerta.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_validator/email_validator.dart';

import '../../features/imagem_do_dia/view/imagem_view.dart';

class ControleTelaLogin {
  // Controles de edição do login e senha
  final controlador_login = TextEditingController();
  final controlador_senha = TextEditingController();

  // Controlador de formulário (para fazer validações)
  final formkey = GlobalKey<FormState>();

  // Controladores de foco
  final focus_senha = FocusNode();
  final focus_botao = FocusNode();

  // Autenticação
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference<Map<String, dynamic>> get _collection_usuarios =>
      FirebaseFirestore.instance.collection('usuarios');

  void logar(BuildContext context) async {
    if (formkey.currentState!.validate()) {
      String login = controlador_login.text.trim();
      String senha = controlador_senha.text.trim();

      if (EmailValidator.validate(login)) {
        try {
          // Logando
          UserCredential userCredential = await _auth
              .signInWithEmailAndPassword(email: login, password: senha);
          User? firebaseUser = userCredential.user;
          _irParaTelaPrincipal(firebaseUser, context);
        } on FirebaseAuthException catch (e) {
          if (e.code == 'user-not-found') {
            MensagemAlerta(
                context, "Erro: Usuário não encontrado para o email informado");
          } else if (e.code == 'wrong-password') {
            MensagemAlerta(
              context,
              "Erro: Password inválido!!!",
            );
            print('Wrong password provided for that user.');
          } else {
            MensagemAlerta(context, 'Erro: ${e.message}');
          }
        } catch (e) {
          MensagemAlerta(context, 'Erro inesperado: $e');
        }
      } else {
        MensagemAlerta(context, "Erro: Email informado com formato inválido");
      }
    }
  }

  void _irParaTelaPrincipal(User? firebaseUser, BuildContext context) async {
    if (firebaseUser == null || firebaseUser.email == null) {
      MensagemAlerta(context, "Erro: usuário inválido após autenticação");
      return;
    }

    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot = await _collection_usuarios
          .where("email", isEqualTo: firebaseUser.email)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final doc = snapshot.docs.first;
        Usuario usuario = Usuario.fromMap(doc.data());
        usuario.id = doc.id;
        push(context, TelaPrincipal(usuario), replace: true);
      } else {
        // Caso não exista, criar documento mínimo e navegar
        final docRef = await _collection_usuarios.add({'email': firebaseUser.email});
        Usuario usuario = Usuario();
        usuario.login = firebaseUser.email;
        usuario.id = docRef.id;
        push(context, TelaPrincipal(usuario), replace: true);
      }
    } catch (e) {
      MensagemAlerta(context, 'Erro ao buscar/registrar usuário: $e');
    }
  }

  void cadastrar(BuildContext context) async {
    if (formkey.currentState!.validate()) {
      String login = controlador_login.text.trim();
      String senha = controlador_senha.text.trim();

      if (EmailValidator.validate(login)) {
        try {
          UserCredential userCredential = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(email: login, password: senha);

          // No serviço de armazenamento (Firestore)
          await _collection_usuarios.add({
            'email': login,
          });

          User? firebaseUser = userCredential.user;
          _irParaTelaPrincipal(firebaseUser, context);
        } on FirebaseAuthException catch (e) {
          if (e.code == 'weak-password') {
            MensagemAlerta(context, "Erro: A senha fornecida é muito fraca");
          } else if (e.code == 'email-already-in-use') {
            MensagemAlerta(
                context, "Erro: Já existe conta com o email informado");
          } else {
            MensagemAlerta(context, 'Erro: ${e.message}');
          }
        } catch (e) {
          MensagemAlerta(context, 'Erro inesperado: $e');
        }
      } else {
        MensagemAlerta(context, "Erro: Email informado com formato inválido");
      }
    }
  }
}
