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
    print('chegou no repository');
    final doc = await _db.collection("usuarios").doc(usuarioId).collection('favoritos').get();

    if (doc.docs.isEmpty) {
      print('veio nada');
      return [];
    }

    return doc.docs
        .map((e) => ImagemNasa.fromJson(e.data()))
        .toList();
  }
  Future<void> removerFavorito(String usuarioId, int index) async{
    final ref = _db.collection("favoritos").doc(usuarioId);

    final doc = await ref.get();
    final List imagens = doc.data()?['imagens'] ?? [];

    if(index < 0 || index >= imagens.length) return;

    imagens.removeAt(index);

    await ref.update({'imagens': imagens});
    }
  }