import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _collectionUsuarios =
  FirebaseFirestore.instance.collection('usuarios');

  Future<User?> login(String email, String senha) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: senha,
    );
    return credential.user;
  }

  Future<DocumentSnapshot<Map<String, dynamic>>?> buscarUsuario(String email) async {
    final result =
    await _collectionUsuarios.where("email", isEqualTo: email).get();

    if (result.docs.isEmpty) return null;
    return result.docs.first;
  }

  String buscarUsuarioAtual(){
    final usuario = _auth.currentUser;
    return usuario?.uid ?? '';
  }
}
