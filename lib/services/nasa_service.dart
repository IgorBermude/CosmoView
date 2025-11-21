import 'dart:convert';
import 'package:http/http.dart' as http;
import '../dominio/apod.dart';

class NasaService {
  static const _baseUrl = 'https://api.nasa.gov/planetary/apod';
  final String apiKey;

  NasaService({this.apiKey = 'DEMO_KEY'});

  Future<Apod> fetchApod() async {
    final uri = Uri.parse('$_baseUrl?api_key=$apiKey');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonBody = json.decode(response.body);
      return Apod.fromJson(jsonBody);
    } else {
      throw Exception('Falha ao buscar APOD: ${response.statusCode}');
    }
  }
}
