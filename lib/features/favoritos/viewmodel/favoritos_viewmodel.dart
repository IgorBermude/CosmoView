import 'package:cosmoview/data/models/imagem_nasa.dart';
import 'package:cosmoview/features/favoritos/repository/favoritos_repository.dart';
import 'package:flutter/cupertino.dart';

import '../../imagem_do_dia/repository/nasa_repository.dart';

class FavoritosViewModel extends ChangeNotifier{
  final FavoritosRepository _repository;
  final _nasaRepo = NasaRepository();
  final _favRepo = FavoritosRepository();

  FavoritosViewModel(this._repository);

  List<ImagemNasa> imagens = [];
  bool carregando = false;
  String? erro;

  Future<void> carregarFavoritos(String usuarioId) async{
    try{
      carregando = true;
      erro = null;
      notifyListeners();

      imagens = await _repository.getFavoritos(usuarioId);
    } catch (e){
      erro = e.toString();
    }

    carregando = false;
    notifyListeners();
  }

  Future<void> removerFavorito(String usuarioId, int index) async{
    await _repository.removerFavorito(usuarioId, index);
    imagens.removeAt(index);
    notifyListeners();
  }

  Future<void> adicionarFavoritosTeste(String usuarioId) async {
    final imagens = await _nasaRepo.getImagensRandom(10);
    for (var img in imagens) {
      await _favRepo.salvarFavorito(usuarioId, img);
    }
  }
  
}