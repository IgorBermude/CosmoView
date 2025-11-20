import 'package:cosmoview/features/login/viewmodel/login_viewmodel.dart';
import 'package:cosmoview/features/login/repository/login_repository.dart';
import 'package:cosmoview/ui/campo_edicao.dart';
import 'package:flutter/material.dart';

class TelaLogin extends StatefulWidget {
  const TelaLogin({Key? key}) : super(key: key);

  @override
  State<TelaLogin> createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  late LoginViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = LoginViewModel(LoginRepository());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Form(
        key: viewModel.formKey,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
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
                onPressed: () => viewModel.logar(context),
                child: const Text("Entrar"),
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: () => viewModel.cadastrar(context),
                child: const Text("Cadastrar"),
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
