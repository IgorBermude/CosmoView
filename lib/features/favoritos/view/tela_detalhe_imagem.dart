import 'package:cosmoview/data/models/imagem_nasa.dart';
import 'package:flutter/material.dart';

class TelaDetalheImagem extends StatelessWidget{
  final ImagemNasa imagem;
  const TelaDetalheImagem({super.key, required this.imagem});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(imagem.titulo ?? "Imagem"),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Expanded(
            child: Image.network(
              imagem.url,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              imagem.explanation ?? "Sem descrição",
              style: const TextStyle(fontSize: 16),
            ),
          )
        ],
      ),
    );
  }
  
}