class Usuario {
  String? id = null;
  String? nome;
  String? login; // email
  String? urlFoto;

  @override
  String toString() {
    return 'Usuario{id: $id, email: $login}';
  }

  Usuario.fromMap(Map<String, dynamic> map) {
    login = map["email"];
  }

  Map<String, dynamic> toMap(){
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['email'] = this.login;
    return data;
  }

  static Future<Usuario?> obterNaoNulo() async {
    // Obtendo o usuário logado
    /*var user = await FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("Usuário não está logado");
    }

    // Obtendo os dados do usuário no Firestore
    var querySnapshot = await FirebaseFirestore.instance
        .collection('usuarios')
        .where("email", isEqualTo: "${user.email}")
        .get();

    if (querySnapshot.docs.isEmpty) {
      throw Exception("Usuário não encontrado no Firestore");
    }

    var usuario = Usuario.fromMap(querySnapshot.docs[0].data());
    usuario.id = querySnapshot.docs[0].id;*/
    return null;
  }

  static void limpar() {

  }
}

