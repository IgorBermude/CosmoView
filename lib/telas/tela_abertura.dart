import 'package:cosmoview/telas/controle_interacao/controle_tela_abertura.dart';
import 'package:flutter/material.dart';

class TelaAbertura extends StatefulWidget {
  @override
  _TelaAberturaState createState() => _TelaAberturaState();
}

class _TelaAberturaState extends State<TelaAbertura> {
  ControleTelaAbertura _controle = ControleTelaAbertura();

  @override
  void initState() {
    super.initState();
    _controle.iniciarAplicacao(context);
  }

  @override
  Widget build(BuildContext context){
    return Container(
      color: Colors.green[200],
      alignment: Alignment.center,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image.asset("assets/icon/icone_aplicacao.png", fit: BoxFit.contain),
          Container(
            alignment: Alignment.bottomCenter,
            padding: EdgeInsets.only(bottom: 100),
            child: Text(
              "CosmoView",
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                decoration: TextDecoration.none,
              ),
            ),
          ),
          Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}