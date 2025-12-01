import 'dart:io';

class GerenciadorArquivo {
  static Future<File?> obterImagem(String? urlFoto) async {
    if (urlFoto == null || urlFoto.isEmpty) return null;
    try {
      Uri? uri;
      try {
        uri = Uri.parse(urlFoto);
      } catch (_) {
        uri = null;
      }

      File file;
      // trata esquemas file:// ou path simples no dispositivo
      if (uri != null && uri.scheme == 'file') {
        file = File.fromUri(uri);
      } else {
        file = File(urlFoto);
      }

      if (await file.exists()) return file;
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<Directory?> getTemporaryDirectory() async {
    // Retorna diretório temporário do sistema; usado apenas para compatibilidade
    return Directory.systemTemp;
  }
  // Implementação do gerenciador de arquivos
}