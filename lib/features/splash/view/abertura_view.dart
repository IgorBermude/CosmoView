import 'package:cosmoview/features/splash/viewmodel/abertura_viewmodel.dart';
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
      color: Colors.blueAccent,
      alignment: Alignment.center,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Center(child: Image.asset("assets/Logo.png", fit: BoxFit.contain)),
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