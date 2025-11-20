import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosmoview/data/models/imagem_nasa.dart';

class FavoritosRepository{
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<ImagemNasa>> getFavoritos(String usuarioId) async {
    final doc = await _db.collection("favoritos").doc(usuarioId).get();

    if (!doc.exists || doc.data() == null) {
      return [];
    }

    final data = doc.data()!;
    final List favoritosRaw = data['imagens'] ?? [];

    return favoritosRaw
        .map((e) => ImagemNasa.fromJson(e as Map<String, dynamic>))
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