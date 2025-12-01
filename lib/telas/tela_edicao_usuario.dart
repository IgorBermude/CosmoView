import 'package:flutter/material.dart';

import '../data/models/usuario.dart';
import '../features/editar_perfil/view/editar_perfil_view.dart';

class TelaEdicaoUsuario extends StatefulWidget {
  final Usuario usuario;

  TelaEdicaoUsuario({required this.usuario});

  @override
  State<StatefulWidget> createState() {
    return _TelaEdicaoUsuarioState();
  }
}

class _TelaEdicaoUsuarioState extends State<TelaEdicaoUsuario> {
  @override
  Widget build(BuildContext context) {
    return EditarPerfilView(usuario: widget.usuario);
  }
}