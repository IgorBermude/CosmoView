import 'dart:io';

import 'package:flutter/material.dart';

import '../../editar_perfil/viewmodel/editar_perfil_view_model.dart';
import '../../editar_perfil/repository/editar_perfil_repository.dart';
import '../../../data/models/usuario.dart';

class EditarPerfilView extends StatefulWidget {
  final Usuario usuario;
  EditarPerfilView({required this.usuario});

  @override
  State<EditarPerfilView> createState() => _EditarPerfilViewState();
}

class _EditarPerfilViewState extends State<EditarPerfilView> {
  late EditarPerfilViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = EditarPerfilViewModel(EditarPerfilRepository());
    viewModel.nomeController.text = widget.usuario.nome ?? '';
  }

  @override
  void dispose() {
    viewModel.nomeController.dispose();
    super.dispose();
  }

  Widget _buildAvatar() {
    if (viewModel.selectedImage != null) {
      return CircleAvatar(radius: 48, backgroundImage: FileImage(viewModel.selectedImage!));
    }
    if (widget.usuario.urlFoto != null && widget.usuario.urlFoto!.isNotEmpty) {
      // tentar carregar local ou remoto posteriormente
      return CircleAvatar(radius: 48, child: Icon(Icons.person));
    }
    return CircleAvatar(radius: 48, child: Icon(Icons.person));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar Perfil')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: viewModel.formKey,
          child: Column(
            children: [
              _buildAvatar(),
              TextButton.icon(
                onPressed: () async {
                  await viewModel.pickImageFromGallery();
                  setState(() {});
                },
                icon: Icon(Icons.photo),
                label: Text('Escolher foto'),
              ),
              TextFormField(
                controller: viewModel.nomeController,
                decoration: InputDecoration(labelText: 'Nome'),
                validator: (value) => (value == null || value.trim().isEmpty) ? 'Informe um nome' : null,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => viewModel.atualizar(widget.usuario, context),
                child: Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
