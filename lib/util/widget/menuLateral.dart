import 'dart:io';

import 'package:cosmoview/telas/tela_login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../dominio/usuario.dart';
import '../../telas/tela_ajuda.dart';
import '../../telas/tela_edicao_usuario.dart';
import '../../telas/tela_abertura.dart';
import '../gerenciador_arquivo.dart';

class MenuLateral extends StatefulWidget {
  @override
  _MenuLateralState createState() => _MenuLateralState();
}

class _MenuLateralState extends State<MenuLateral> {
  Usuario? usuario;
  Future<Usuario>? future;
  Future<File>? future_arquivo;

  @override
  void initState() {
    super.initState();
    // A criação do Future é feita no initState para evitar que ele seja recriado a cada build
    /*future = Usuario.obterNaoNulo();
    future!.then((usuario){
      if(usuario.urlFoto != null){
        //future_arquivo = GerenciadorArquivo.obterImagem(usuario.urlFoto);
      }
    });*/
  }

  UserAccountsDrawerHeader _header(ImageProvider imageProvider){
    return UserAccountsDrawerHeader(
        accountName: Text(usuario!.nome!),
        accountEmail: Text(usuario!.login!),
        currentAccountPicture: CircleAvatar(
          backgroundImage: imageProvider,
        ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: <Widget>[
                  FutureBuilder<Usuario>(
                    future: future,
                    builder: (context, snapshot) {
                      usuario = snapshot.data;
                      if(usuario == null){
                        return Container();
                      } else if(usuario!.urlFoto != null){
                        return FutureBuilder<File>(
                          future: future_arquivo,
                          builder: (context, snapshot){
                            if(!snapshot.hasData){
                              return Center(child: CircularProgressIndicator());
                            }
                            File imagem = snapshot.data!;
                            return _header(FileImage(imagem));
                          },
                        );
                      } else {
                        return _header(AssetImage("assets/icon/icone_aplicacao.png"));
                      }
                    },
                  ),

                  // Clicar no perfil e colocar o botão de editar dentro do perfil
                  // ListTile(
                  //   leading: Icon(Icons.edit),
                  //   title: Text("Editar Perfil"),
                  //   subtitle: Text("nome, login, senha ..."),
                  //   trailing: Icon(Icons.arrow_forward),
                  //   onTap: () {
                  //     Navigator.pop(context);
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(builder: (context) => TelaEdicaoUsuario(usuario: usuario!)),
                  //     );
                  //   },
                  // ),

                  ListTile(
                    leading: Icon(Icons.help),
                    title: Text("Ajuda"),
                    subtitle: Text("Como usar"),
                    trailing: Icon(Icons.arrow_forward),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TelaAjuda()),
                      );
                    },
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text("Sair"),
              subtitle: Text("Finalizar sessão"),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
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
          ],
        ),
      ),
    );

  }
}