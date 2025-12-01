import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

import '../../editar_perfil/repository/editar_perfil_repository.dart';
import '../../../data/models/usuario.dart';
import '../../../ui/mensagem_alerta.dart';

class EditarPerfilViewModel {
  final EditarPerfilRepository repository;

  EditarPerfilViewModel(this.repository);

  final nomeController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  File? selectedImage;

  Future<void> pickImageFromGallery() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery, maxWidth: 800);
    if (picked != null) selectedImage = File(picked.path);
  }

  Future<void> atualizar(Usuario usuario, BuildContext context) async {
    if (!formKey.currentState!.validate()) return;

    usuario.nome = nomeController.text.trim();

    String? caminhoFoto;
    if (selectedImage != null) caminhoFoto = selectedImage!.path;

    try {
      await repository.atualizarUsuario(usuario, caminhoFoto: caminhoFoto);
      MensagemAlerta(context, 'Perfil atualizado com sucesso');
      Navigator.pop(context);
    } catch (e) {
      MensagemAlerta(context, 'Erro ao atualizar perfil: $e');
    }
  }
}