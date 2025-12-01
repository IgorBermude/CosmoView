import 'dart:io';

import 'package:cosmoview/features/favoritos/view/favoritos_view.dart';
import 'package:cosmoview/features/login/view/login_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../data/models/usuario.dart';
import '../features/imagem_do_dia/view/imagem_view.dart';
import '../telas/tela_ajuda.dart';
import '../telas/tela_edicao_usuario.dart';
import '../data/services/gerenciador_arquivo.dart';

class MenuLateral extends StatefulWidget {
  @override
  _MenuLateralState createState() => _MenuLateralState();
}

class _MenuLateralState extends State<MenuLateral> {
  Usuario? usuario;
  Future<Usuario?>? future;

  @override
  void initState() {
    super.initState();
    // A criação do Future é feita no initState para evitar que ele seja recriado a cada build
    future = Usuario.obterNaoNulo();
  }

  // agora recebe o usuário explicitamente para evitar depender de variáveis nulas
  UserAccountsDrawerHeader _header(Usuario user, ImageProvider imageProvider){
    return UserAccountsDrawerHeader(
        accountName: Text(user.nome ?? ''),
        accountEmail: Text(user.login ?? ''),
        currentAccountPicture: CircleAvatar(
          backgroundImage: imageProvider,
        ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: ListView(
          children: <Widget>[
            FutureBuilder<Usuario?>(
              future: future,
              builder: (context, snapshot) {
                // Atualiza a variável de instância para uso posterior (ex.: navegação)
                usuario = snapshot.data;

                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Enquanto carrega, exibe um header simples com ícone e indicador
                  return UserAccountsDrawerHeader(
                    accountName: const Text('Carregando...'),
                    accountEmail: const Text(''),
                    currentAccountPicture: const CircleAvatar(child: CircularProgressIndicator()),
                  );
                }

                final user = snapshot.data;

                if (user == null) {
                  // Nenhum usuário: exibe header padrão
                  return _header(Usuario(), AssetImage("assets/icon/icone_aplicacao.png"));
                }

                if (user.urlFoto != null && user.urlFoto!.isNotEmpty) {
                  // Usa um FutureBuilder para carregar o arquivo local da imagem
                  return FutureBuilder<File?>(
                    future: GerenciadorArquivo.obterImagem(user.urlFoto),
                    builder: (context, imgSnapshot) {
                      if (imgSnapshot.connectionState == ConnectionState.waiting) {
                        return UserAccountsDrawerHeader(
                          accountName: Text(user.nome ?? ''),
                          accountEmail: Text(user.login ?? ''),
                          currentAccountPicture: const CircleAvatar(child: CircularProgressIndicator()),
                        );
                      }

                      if (imgSnapshot.hasData && imgSnapshot.data != null) {
                        return _header(user, FileImage(imgSnapshot.data!));
                      } else {
                        // Caso não consiga carregar o arquivo, mostra ícone padrão
                        return _header(user, AssetImage("assets/icon/icone_aplicacao.png"));
                      }
                    },
                  );
                }

                // Sem foto: mostra ícone padrão
                return _header(user, AssetImage("assets/icon/icone_aplicacao.png"));
              },
            ),
            ListTile(
              leading: Icon(Icons.edit),
              title: Text("Editar Perfil"),
              subtitle: Text("nome, login, senha ..."),
              trailing: Icon(Icons.arrow_forward),
              onTap: (){
                Navigator.pop(context);
                if (usuario != null) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => TelaEdicaoUsuario(usuario: usuario!,))
                  );
                }
              },
            ),
            ListTile(
              title: Text("Tela Principal"),
              leading: Icon(Icons.rocket_launch),
              subtitle: Text("Imagem do dia"),
              trailing: Icon(Icons.arrow_forward),
              onTap: (){
                Navigator.pop(context);
                Navigator.push(context,
                  MaterialPageRoute(builder: (context) => TelaPrincipal(usuario!))
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.help),
              title: Text("Ajuda"),
              subtitle: Text("Como usar"),
              trailing: Icon(Icons.arrow_forward),
              onTap: (){
                Navigator.pop(context);
                Navigator.push(context,
                  MaterialPageRoute(builder: (context) => TelaAjuda())
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.favorite),
              title: Text("Favoritos"),
              subtitle: Text("Mostrar favoritos"),
              trailing: Icon(Icons.arrow_forward),
              onTap: (){
                Navigator.pop(context);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => TelaFavoritos(usuarioId: usuario?.id,)),
                      (route) => false,
                );
              },
            ),

            Divider(height: 3, thickness: 1, color: Colors.black38),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text("Sair"),
              subtitle: Text("Finalizar sessão"),
              trailing: Icon(Icons.arrow_forward),
              onTap: (){
                Navigator.pop(context);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => TelaLogin()),
                      (route) => false,
                );
                Usuario.limpar();
                //FirebaseAuth.instance.signOut();
              },
            ),
          ]
        ),
      ),
    );
  }
}