import 'package:cosmoview/dominio/usuario.dart';
import 'package:cosmoview/telas/tela_edicao_usuario.dart';
import 'package:cosmoview/telas/tela_abertura.dart';
import 'package:cosmoview/telas/tela_principal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ControleTelaAbertura{
  void iniciarAplicacao(BuildContext context){
    Future future = Future.delayed(Duration(seconds: 2));

    future.then((value) => {

      FirebaseAuth.instance.authStateChanges().listen((Usuario? user) {
        if (user == null) {
          push(context, TelaAbertura(), replace: true);
        } else {
          Usuario usuario;
          FirebaseFirestore.instance
              .collection('usuarios')
              .where("email", isEqualTo: "${user.login}")
              .snapshots()
              .listen((data){

            usuario = Usuario.fromMap(data.docs[0].data());
            usuario.id = data.docs[0].id;
            push(context, TelaPrincipal(usuario: usuario), replace: true);
          });
        }
      })
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