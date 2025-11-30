import '../../../data/services/imagem_service.dart';
import '../../../data/models/imagem_nasa.dart';
import '../../../data/models/usuario.dart';

class ImagemRepository {
  final ImagemService _service = ImagemService();

  ImagemRepository();

  Future<void> salvarFavorita(Usuario? usuario, ImagemNasa imagem) async {
    return _service.saveImagemFavorita(usuario, imagem);
  }

  Future<void> removerFavorita(Usuario? usuario, ImagemNasa imagem) async {
    return _service.removeImagemFavorita(usuario, imagem);
  }
}
