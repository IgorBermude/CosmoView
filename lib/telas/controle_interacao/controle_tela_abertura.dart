import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosmoview/dominio/usuario.dart';
import 'package:cosmoview/telas/tela_edicao_usuario.dart';
import 'package:cosmoview/telas/tela_abertura.dart';
import 'package:cosmoview/telas/tela_login.dart';
import 'package:cosmoview/telas/tela_principal.dart';
import 'package:cosmoview/util/widget/mensagem_alerta.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ControleTelaAbertura{
  void iniciarAplicacao(BuildContext context){
    Future future = Future.delayed(Duration(seconds: 2));

    future.then((value) {
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        if (user == null) {
          MensagemAlerta(context, "Usuário não autenticado.");
          push(context, TelaLogin(), replace: true);
        } else {
          MensagemAlerta(context, "Usuário autenticado: ${user.email}");
          final String? email = user.email;
          if (email == null || email.isEmpty) {
            // Se usuário não tem email, redireciona para abertura/edição
            push(context, TelaLogin(), replace: true);
            return;
          }

          FirebaseFirestore.instance
              .collection('usuarios')
              .where("email", isEqualTo: email)
              .get()
              .then((QuerySnapshot snapshot) {
            if (snapshot.docs.isNotEmpty) {
              final doc = snapshot.docs.first;
              final Usuario usuario = Usuario.fromMap(doc.data() as Map<String, dynamic>);
              usuario.id = doc.id;
              MensagemAlerta(context, "Usuário encontrado: ${usuario.login}");
              push(context, TelaPrincipal(usuario), replace: true);
            } else {
              // Nenhum usuário encontrado -> abrir tela de abertura ou edição
              MensagemAlerta(context, "Nenhum usuário encontrado para o email: $email");
              push(context, TelaLogin(), replace: true);
            }
          }).catchError((error) {
            // Em caso de erro na consulta, abrir tela de abertura como fallback
            MensagemAlerta(context, "Erro ao buscar usuário: $error");
            push(context, TelaLogin(), replace: true);
          });
        }
      });
    });
  }

  Future push(BuildContext context, Widget tela, {bool replace = false}) {
    if(replace) {
      return Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (BuildContext context) {
          return tela;
        }),
      );
    } else {
      return Navigator.push(
        context,
        MaterialPageRoute(builder: (BuildContext context) {
          return tela;
        }),
      );
    }
  }

  void pop(BuildContext context , [String? mensagem]){
    if(mensagem == null){
      Navigator.of(context).pop();
    }else{
      Navigator.pop(context, mensagem);
    }
  }
}