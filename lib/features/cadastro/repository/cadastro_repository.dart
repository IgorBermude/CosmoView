import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CadastroRepository{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _collectionUsuarios =
  FirebaseFirestore.instance.collection('usuarios');

  Future<User?> cadastrar(String email, String senha) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: senha,
    );
    return credential.user;
  }

  Future<QueryDocumentSnapshot<Map<String, dynamic>>?> buscarUsuario(String email) async {
    final result = await _collectionUsuarios.where("email", isEqualTo: email).get();

    if (result.docs.isEmpty) return null;
    return result.docs.first;
  }

  // Aceita opcionalmente a url da foto e/ou os bytes da foto e o nome e armazena no documento
  // Tornamos `email` um parâmetro nomeado obrigatório para evitar confusões
  Future<String> criarUsuario({required String email, String? nome, String? caminhoFoto}) async {
    final data = <String, dynamic>{"email": email};
    if (nome != null && nome.isNotEmpty) {
      data['nome'] = nome;
    }
    // Armazenamos a URL/caminho da foto com a chave 'urlFoto' para ficar consistente com Usuario.fromMap
    if (caminhoFoto != null && caminhoFoto.isNotEmpty) {
      data['urlFoto'] = caminhoFoto;
    }

    final doc = await _collectionUsuarios.add(data);
    return doc.id;
  }
}