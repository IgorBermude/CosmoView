import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosmoview/dominio/usuario.dart';
import 'package:cosmoview/telas/tela_edicao_usuario.dart';
import 'package:cosmoview/telas/tela_abertura.dart';
import 'package:cosmoview/telas/tela_principal.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ControleTelaAbertura{
  void iniciarAplicacao(BuildContext context){
    Future future = Future.delayed(Duration(seconds: 2));

    future.then((value) {
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        if (user == null) {
          push(context, TelaAbertura(), replace: true);
        } else {
          final String? email = user.email;
          if (email == null || email.isEmpty) {
            // Se usuário não tem email, redireciona para abertura/edição
            push(context, TelaAbertura(), replace: true);
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
              push(context, TelaPrincipal(usuario), replace: true);
            } else {
              // Nenhum usuário encontrado -> abrir tela de abertura ou edição
              push(context, TelaAbertura(), replace: true);
            }
          }).catchError((error) {
            // Em caso de erro na consulta, abrir tela de abertura como fallback
            push(context, TelaAbertura(), replace: true);
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