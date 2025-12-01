import 'dart:io';

import 'package:cosmoview/features/cadastro/repository/cadastro_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../ui/campo_edicao.dart';
import '../viewmodel/cadastro_viewmodel.dart';

class TelaCadastro extends StatefulWidget {
  const TelaCadastro({Key? key}) : super(key: key);

  @override
  State<TelaCadastro> createState() => _TelaCadastroState();
}

class _TelaCadastroState extends State<TelaCadastro> {
  late CadastroViewModel viewModel;

  File? _selectedImage; // imagem escolhida da galeria

  @override
  void initState() {
    super.initState();
    viewModel = CadastroViewModel(CadastroRepository());
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery, maxWidth: 800);
    if (picked == null) return;
    setState(() {
      _selectedImage = File(picked.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro')),
      body: Form(
        key: viewModel.formKey,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              Center(
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 48,
                      backgroundImage: _selectedImage != null ? FileImage(_selectedImage!) as ImageProvider : null,
                      child: _selectedImage == null ? const Icon(Icons.person, size: 48) : null,
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: IconButton(
                        icon: const Icon(Icons.photo_camera),
                        onPressed: _pickImage,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Campo Nome (agora usando CampoEdicao)
              CampoEdicao(
                "Nome",
                texto_dica: "Seu nome de usuário",
                controlador: viewModel.nomeController,
              ),
              const SizedBox(height: 12),
              CampoEdicao(
                "Email",
                texto_dica: "Digite seu email",
                controlador: viewModel.emailController,
                teclado: TextInputType.emailAddress,
                recebedor_foco: viewModel.focusSenha,
              ),
              const SizedBox(height: 12),
              CampoEdicao(
                "Senha",
                texto_dica: "Digite sua senha",
                controlador: viewModel.senhaController,
                passaword: true,
                marcador_foco: viewModel.focusSenha,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => viewModel.cadastrar(context, imageFile: _selectedImage),
                child: const Text("Cadastrar"),
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancelar"),
              ),
              const SizedBox(height: 16),
              Center(
                child: InkWell(
                  onTap: () {},
                  child: const Text(
                    "Esqueceu a senha?",
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
