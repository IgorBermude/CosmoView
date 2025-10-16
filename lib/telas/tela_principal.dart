// filepath: c:\Users\igors\AndroidStudioProjects\CosmoView\lib\telas\tela_principal.dart
import 'package:flutter/material.dart';
import 'package:cosmoview/dominio/usuario.dart';

class TelaPrincipal extends StatelessWidget {
  final Usuario usuario;
  const TelaPrincipal({super.key, required this.usuario});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Principal')),
      body: const Center(child: Text('Tela Principal')),
    );
  }
}

