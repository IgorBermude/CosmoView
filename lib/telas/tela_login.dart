import 'package:cosmoview/telas/controle_interacao/controle_login.dart';
import 'package:cosmoview/telas/localwidget/campo_edicao.dart';
import 'package:flutter/material.dart';

class TelaLogin extends StatefulWidget {
  const TelaLogin({Key? key}) : super(key: key);

  @override
  State<TelaLogin> createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  late ControleTelaLogin _controle;

  @override
  void initState() {
    super.initState();
    _controle = ControleTelaLogin();
  }

  _body(){
    return Form(
      key: _controle.formkey,
      child: Container(
        padding: EdgeInsets.all(16),
        child: ListView(
          children: <Widget>[
            CampoEdicao(
              "Login",
              texto_dica: "Digite seu login",
              controlador: _controle.controlador_login,
              teclado: TextInputType.emailAddress,
              recebedor_foco: _controle.foco_login,
            ),
          ]
        )
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      margin: EdgeInsets.only(top: 20),
      child: InkWell(
        onTap: (){
          _controle.cadastrar(context);
       },
        child: Text(
          "Cadastre-se",
          style: TextStyle(
            color: Colors.blue,
            fontSize: 16,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }
}