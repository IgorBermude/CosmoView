import 'package:cosmoview/dominio/usuario.dart';
import 'package:cosmoview/telas/tela_principal.dart';
import 'package:cosmoview/util/widget/mensagem_alerta.dart';
import 'package:flutter/cupertino.dart';

class ControleTelaLogin {
  final controlador_login = TextEditingController();
  final controlador_senha = TextEditingController();

  final formkey = GlobalKey<FormState>();

  final focus_senha = FocusNode();
  final focus_botao = FocusNode();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference<Map<String, dynamic>> get _collection_usuarios => FirebaseFirestore.instance.collection('usuarios');

  void logar(BuildContext context) async {
    if (formkey.currentState!.validate()) {
      String login = controlador_login.text.trim();
      String senha = controlador_senha.text.trim();

      try {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
            email: login,
            password: senha
        );
        _irParaTelaPrincipal(userCredential.user, context);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          MensagemAlerta(
              "Erro: Usuário não encontrado para o email informado.");
        } else if (e.code == 'wrong-password') {
          MensagemAlerta("Erro: Senha incorreta para o usuário informado.");
          print("Erro: Senha incorreta para o usuário informado.")
        }
      }
    }
  }

  void _irParaTelaPrincipal(User? user, BuildContext context){
    _collection_usuarios.
        where("email", isEqualTo: "${user?.email}").
        snapshots().
        listen((data){
          Usuario usuario = Usuario.fromMap(data.docs[0].data());
          usuario.id = data.docs[0].id;

          push(context, TelaPrincipal(usuario: usuario), replace: true);
        });
  }

  void cadastrar(BuildContext context){
    if (formkey.currentState!.validate()) {
      String login = controlador_login.text.trim();
      String senha = controlador_senha.text.trim();

      try {
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: login,
            password: senha
        );

        _collection_usuarios.add({
          'email': login,
        }).then((value) => _irParaTelaPrincipal(userCredential.user, context))
        .catchError((error) => print("Erro ao adicionar usuário: $error"));

      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          MensagemAlerta("Erro: A senha fornecida é muito fraca.");
        } else if (e.code == 'email-already-in-use') {
          MensagemAlerta("Erro: Já existe uma conta para esse email.");
          print("Erro: Já existe uma conta para esse email.");
        }
      } catch (e) {
        print(e);
      }
    }
  }
}