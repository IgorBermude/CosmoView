import 'package:cosmoview/telas/controle_interacao/controle_tela_principal.dart';
import 'package:flutter/material.dart';
import 'package:cosmoview/dominio/usuario.dart';

import '../util/widget/menuLateral.dart';

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
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.blue,
          title: const Text('Tela Principal'),
        ),
      drawer: MenuLateral(),
      body: const Center(child: Text('Tela Principal')),
    );
  }
}
