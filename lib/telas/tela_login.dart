import 'package:cosmoview/telas/controle_interacao/controle_login.dart';
import 'package:cosmoview/util/widget/campo_edicao.dart';
import 'package:flutter/material.dart';

class TelaLogin extends StatefulWidget {
  const TelaLogin({Key? key}) : super(key: key);

  @override
  State<TelaLogin> createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  late ControleTelaLogin _controle;

  @override
  void initState() {
    super.initState();
    _controle = ControleTelaLogin();
  }

  Widget _body() {
    return Form(
      key: _controle.formkey,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: <Widget>[
            CampoEdicao(
              "Email",
              texto_dica: "Digite seu email",
              controlador: _controle.controlador_login,
              teclado: TextInputType.emailAddress,
              recebedor_foco: _controle.focus_senha,
            ),
            const SizedBox(height: 12),
            CampoEdicao(
              "Senha",
              texto_dica: "Digite sua senha",
              controlador: _controle.controlador_senha,
              passaword: true,
              marcador_foco: _controle.focus_senha,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _controle.logar(context),
              child: const Text('Entrar'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () => _controle.cadastrar(context),
              child: const Text('Cadastrar'),
            ),
            const SizedBox(height: 16),
            Center(
              child: InkWell(
                onTap: () {
                  // Caso queira navegar para tela de recuperação ou cadastro separado
                },
                child: const Text(
                  "Esqueceu a senha?",
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 14,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: _body(),
    );
  }
}