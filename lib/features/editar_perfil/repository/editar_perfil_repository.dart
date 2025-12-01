import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../data/models/usuario.dart';

class EditarPerfilRepository {
  final _collection = FirebaseFirestore.instance.collection('usuarios');

  Future<void> atualizarUsuario(Usuario usuario, {String? caminhoFoto}) async {
    final data = <String, dynamic>{};

    if (usuario.nome != null) data['nome'] = usuario.nome;
    // Armazenar a foto usando 'urlFoto' para ficar consistente com Usuario.fromMap
    if (caminhoFoto != null && caminhoFoto.isNotEmpty) data['urlFoto'] = caminhoFoto;

    if (usuario.id != null && usuario.id!.isNotEmpty) {
      await _collection.doc(usuario.id).update(data);
      return;
    }

    // Se não tem id, busca pelo email e atualiza o primeiro encontrado
    final query = await _collection.where('email', isEqualTo: usuario.login).limit(1).get();
    if (query.docs.isNotEmpty) {
      await _collection.doc(query.docs[0].id).update(data);
      return;
    }

    throw Exception('Usuário não encontrado para atualizar');
  }
}