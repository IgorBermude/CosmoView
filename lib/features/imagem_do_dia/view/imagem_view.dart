// filepath: c:\Users\igors\AndroidStudioProjects\CosmoView\lib\telas\imagem_view.dart
import 'package:flutter/material.dart';
import 'package:cosmoview/data/models/usuario.dart';
import '../viewmodel/imagem_viewmodel.dart';

class TelaPrincipal extends StatefulWidget {
  final Usuario usuario;
  const TelaPrincipal(this.usuario);
  @override
  _TelaPrincipalState createState() => _TelaPrincipalState();

}

class _TelaPrincipalState extends State<TelaPrincipal> {
  late ControleTelaPrincipal _controle;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controle = ControleTelaPrincipal(widget.usuario);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Principal')),
      body: const Center(child: Text('Tela Principal')),
    );
  }
}

