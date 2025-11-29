import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/imagem_nasa.dart';
import '../models/usuario.dart';

class ImagemService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ImagemService();

  Future<void> saveImagemFavorita(Usuario? usuario, ImagemNasa imagem) async {
    final docId = Uri.encodeComponent(imagem.url);
    if (usuario != null && usuario.id != null) {
      final ref = _firestore.collection('usuarios').doc(usuario.id).collection('favoritos').doc(docId);
      await ref.set(imagem.toJson());
    } else {
      final ref = _firestore.collection('favoritos').doc(docId);
      await ref.set(imagem.toJson());
    }
  }

  Future<void> removeImagemFavorita(Usuario? usuario, ImagemNasa imagem) async {
    final docId = Uri.encodeComponent(imagem.url);
    if (usuario != null && usuario.id != null) {
      final ref = _firestore.collection('usuarios').doc(usuario.id).collection('favoritos').doc(docId);
      await ref.delete();
    } else {
      final ref = _firestore.collection('favoritos').doc(docId);
      await ref.delete();
    }
  }
}
