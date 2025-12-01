import 'dart:io';
import 'dart:typed_data';

import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../../../core/navigation/nav.dart';
import '../../../data/models/usuario.dart';
import '../../../ui/mensagem_alerta.dart';
import '../../login/view/login_view.dart';
import '../repository/cadastro_repository.dart';

class CadastroViewModel{
  final CadastroRepository repository;

  CadastroViewModel(this.repository);

  // Controllers
  final nomeController = TextEditingController();
  final emailController = TextEditingController();
  final senhaController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  // Focos
  final focusSenha = FocusNode();

  // Agora aceita imageFile opcional; se fornecido, lê bytes e salva no Firestore
  Future<void> cadastrar(BuildContext context, {File? imageFile}) async {
    if (!formKey.currentState!.validate()) return;

    final nome = nomeController.text.trim();
    final email = emailController.text.trim();
    final senha = senhaController.text.trim();

    if (nome.isEmpty) {
      MensagemAlerta(context, "Erro: Informe um nome de usuário");
      return;
    }

    if (!EmailValidator.validate(email)) {
      MensagemAlerta(context, "Erro: Email inválido");
      return;
    }

    try {
      final user = await repository.cadastrar(email, senha);

      Uint8List? fotoBytes;

      // Se imageFile fornecido, lê bytes e passa para o Firestore
      if (imageFile != null) {
        try {
          fotoBytes = await imageFile.readAsBytes();

          // Verifica tamanho: Firestore tem limite de ~1MB por documento; aconselhável manter abaixo de 512KB
          const maxAllowed = 512 * 1024; // 512KB
          if (fotoBytes.lengthInBytes > maxAllowed) {
            MensagemAlerta(context, "Imagem muito grande. Escolha uma menor (máx ~512KB)." );
            return;
          }
        } catch (e) {
          MensagemAlerta(context, "Aviso: não foi possível ler a imagem local: $e");
        }
      }

      // Se user tem photoURL e não há fotoBytes, usa photoURL
      String? urlToSave = user?.photoURL;

      // Salva fotoBytes no Firestore (campo 'foto') quando disponível
      await repository.criarUsuario(email: email, nome: nome, caminhoFoto: urlToSave);

      MensagemAlerta(context, "Cadastro realizado com sucesso. Faça login.");
      push(context, TelaLogin(), replace: true);
    } catch (e) {
      MensagemAlerta(context, "Erro ao cadastrar: $e");
    }
  }

  Future<void> _processarUsuario(User? firebaseUser, BuildContext context) async {
    if (firebaseUser == null || firebaseUser.email == null) {
      MensagemAlerta(context, "Erro: usuário inválido");
      return;
    }

    try {
      final doc = await repository.buscarUsuario(firebaseUser.email!);

      Usuario usuario = Usuario();

      if (doc != null) {
        usuario = Usuario.fromMap(doc.data());
        usuario.id = doc.id;
      } else {
        final id = await repository.criarUsuario(email: firebaseUser.email!, nome: firebaseUser.displayName, caminhoFoto: firebaseUser.photoURL);
        usuario.login = firebaseUser.email;
        usuario.id = id;
        usuario.urlFoto = firebaseUser.photoURL;
      }

      push(context, TelaLogin(), replace: true);
    } catch (e) {
      MensagemAlerta(context, "Erro ao cadastrar: $e");
    }
  }
}