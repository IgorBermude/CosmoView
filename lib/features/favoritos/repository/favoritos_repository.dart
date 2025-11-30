import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosmoview/data/models/imagem_nasa.dart';

class FavoritosRepository{
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> salvarFavorito(String usuarioId, ImagemNasa imagem) async {
    await _db
        .collection('usuarios')
        .doc(usuarioId)
        .collection('favoritos')
        .add(imagem.toJson());
  }

  Future<List<ImagemNasa>> getFavoritos(String usuarioId) async {
    final doc = await _db.collection("usuarios").doc(usuarioId).collection('favoritos').get();

    if (doc.docs.isEmpty) {
      return [];
    }

    return doc.docs
        .map((e) => ImagemNasa.fromJson(e.data()))
        .toList();
  }
  Future<void> removerFavorito(String usuarioId, int index) async{
    final ref = _db.collection('usuarios').doc(usuarioId).collection('favoritos');

    final snapshot = await ref.get();

    final docs = snapshot.docs;

    if (index < 0 || index >= docs.length) return;

    final docId = docs[index].id;

    await ref.doc(docId).delete();
  }
}