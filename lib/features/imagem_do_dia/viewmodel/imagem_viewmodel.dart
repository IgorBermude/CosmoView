import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosmoview/data/models/usuario.dart';
import 'package:cosmoview/data/models/imagem_nasa.dart';
import 'package:cosmoview/features/imagem_do_dia/repository/nasa_repository.dart';
import 'package:cosmoview/features/imagem_do_dia/repository/imagem_repository.dart';

class ControleTelaPrincipal{
  Usuario usuario;
  List<DocumentSnapshot>? document_itens;

  ControleTelaPrincipal(this.usuario);

}

class ImagemViewModel extends ChangeNotifier {
  final NasaRepository _nasaRepo;
  final ImagemRepository _imagemRepo;

  List<ImagemNasa> imagens = [];
  bool carregando = false;
  String? erro;

  ImagemViewModel({NasaRepository? nasaRepo, ImagemRepository? imagemRepo})
      : _nasaRepo = nasaRepo ?? NasaRepository(),
        _imagemRepo = imagemRepo ?? ImagemRepository();

  Future<void> carregarImagensRandom(int quantidade) async {
    try {
      carregando = true;
      erro = null;
      notifyListeners();

      imagens = await _nasaRepo.getImagensRandom(quantidade);
    } catch (e) {
      erro = e.toString();
    } finally {
      carregando = false;
      notifyListeners();
    }
  }

  Future<void> adicionarFavorito(Usuario? usuario, ImagemNasa imagem) async {
    await _imagemRepo.salvarFavorita(usuario, imagem);
  }

  Future<void> adicionarFavoritosTeste(Usuario? usuario) async {
    final imgs = await _nasaRepo.getImagensRandom(10);
    for (var img in imgs) {
      await _imagemRepo.salvarFavorita(usuario, img);
    }
  }

  Future<void> removerFavorito(Usuario? usuario, ImagemNasa imagem) async {
    await _imagemRepo.removerFavorita(usuario, imagem);
  }

  Future<void> removerImagemLocal(int index) async {
    if (index >= 0 && index < imagens.length) {
      imagens.removeAt(index);
      notifyListeners();
    }
  }
}