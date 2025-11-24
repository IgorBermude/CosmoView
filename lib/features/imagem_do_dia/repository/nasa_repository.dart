import 'dart:convert';

import 'package:cosmoview/data/models/imagem_nasa.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class NasaRepository {
  final String _urlBase = 'https://api.nasa.gov';
  String get _apiKey => dotenv.env['NASA_API_KEY'] ?? '';

  Future<List<ImagemNasa>> getImagensRandom(int count) async{
    final uri = Uri.parse('$_urlBase/planetary/apod?count=$count&api_key=$_apiKey');
    final response = await http.get(uri);

    if(response.statusCode == 200){
      final List<dynamic> data = jsonDecode(response.body);

      return data
          .map((json) => ImagemNasa.fromJson(json))
          .where((img) => img.url.endsWith('.jpg') || img.url.endsWith('.png'))
          .toList();
    } else {
      throw Exception('Erro ao buscar imagens aleatorias');
    }
  }
}