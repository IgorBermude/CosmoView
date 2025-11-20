import 'package:cosmoview/data/models/imagem_nasa.dart';
import 'package:cosmoview/features/favoritos/repository/favoritos_repository.dart';
import 'package:flutter/cupertino.dart';

class FavoritosViewModel extends ChangeNotifier{
  final FavoritosRepository _repository;

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
  
}