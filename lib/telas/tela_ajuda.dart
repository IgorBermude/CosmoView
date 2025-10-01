import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TelaAjuda extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ajuda"),
      ),
      body: Center(
        child: Text("Aqui vai o conteúdo de ajuda."),
      ),
    );
  }
}