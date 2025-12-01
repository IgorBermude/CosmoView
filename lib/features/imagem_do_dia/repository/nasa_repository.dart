import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../../../data/models/apod.dart';
import '../../../data/models/imagem_nasa.dart';

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
  Future<Apod> fetchApod() async {
    final uri = Uri.parse('$_urlBase/planetary/apod?api_key=$_apiKey');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonBody = json.decode(response.body);
      return Apod.fromJson(jsonBody);
    } else {
      throw Exception('Falha ao buscar APOD: ${response.statusCode}');
    }
  }

  Future<Apod> fetchApodByDate(String date) async {
    // espera data no formato AAAA-MM-DD
    final uri = Uri.parse('$_urlBase/planetary/apod?date=$date&api_key=$_apiKey');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonBody = json.decode(response.body);
      return Apod.fromJson(jsonBody);
    } else {
      throw Exception('Falha ao buscar APOD para $date: ${response.statusCode}');
    }
  }
}