import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Usuario {
  String? id = null;
  String? nome;
  String? login; // email
  String? urlFoto;

  Usuario();

  @override
  String toString() {
    return 'Usuario{id: $id, email: $login}';
  }

  Usuario.fromMap(Map<String, dynamic> map) {
    login = map["email"];
    nome = map["nome"];
    urlFoto = map["urlFoto"];
  }

  Map<String, dynamic> toMap(){
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['email'] = this.login;
    if(this.nome != null) data['nome'] = this.nome;
    if(this.urlFoto != null) data['urlFoto'] = this.urlFoto;
    return data;
  }

  static Future<Usuario?> obterNaoNulo() async {
    // Obtendo o usuário logado
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("Usuário não está logado");
    }

    // Obtendo os dados do usuário no Firestore
    final querySnapshot = await FirebaseFirestore.instance
        .collection('usuarios')
        .where("email", isEqualTo: user.email)
        .get();

    if (querySnapshot.docs.isEmpty) {
      throw Exception("Usuário não encontrado no Firestore");
    }

    final usuario = Usuario.fromMap(querySnapshot.docs[0].data());
    usuario.id = querySnapshot.docs[0].id;
    return usuario;
  }

  static Future<void> limpar() async {
    await FirebaseAuth.instance.signOut();
  }
}
