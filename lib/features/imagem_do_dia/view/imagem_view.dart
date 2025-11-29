import 'package:cosmoview/features/imagem_do_dia/viewmodel/imagem_viewmodel.dart';
import 'package:flutter/material.dart';

import '../../../data/models/imagem_nasa.dart';
import '../../../data/models/usuario.dart';
import '../../../data/services/imagem_service.dart';
import '../../../util/menuLateral.dart';
import '../../../data/models/apod.dart';
import '../repository/nasa_repository.dart';

class TelaPrincipal extends StatefulWidget {
  final Usuario usuario;
  const TelaPrincipal(this.usuario);
  @override
  _TelaPrincipalState createState() => _TelaPrincipalState();

}

class _TelaPrincipalState extends State<TelaPrincipal> {
  late ControleTelaPrincipal _controle;
  late Future<Apod> _futureApod;
  final NasaRepository _nasaRepository = NasaRepository();
  bool _liked = false;
  final ImagemService _imagemService = ImagemService();

  @override
  void initState() {
    super.initState();
    _controle = ControleTelaPrincipal(widget.usuario);
    _futureApod = _nasaRepository.fetchApod();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue,
        title: const Text('Tela Principal'),
      ),
      drawer: MenuLateral(),
      body: SafeArea(
        child: FutureBuilder<Apod>(
          future: _futureApod,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Erro ao carregar: ${snapshot.error}'));
            }
            final apod = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Data da Imagem', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 6),
                  Text(apod.date, style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey[300])),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(apod.title,
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                      ),
                      IconButton(
                        icon: Icon(
                          _liked ? Icons.favorite : Icons.favorite_border,
                          color: _liked ? Colors.red : Colors.grey,
                        ),
                        onPressed: () async {
                          // alterna estado localmente para feedback imediato
                          setState(() => _liked = !_liked);
                          final imagem = ImagemNasa(titulo: apod.title, url: apod.url);
                          if (_liked) {
                            try {
                              await _imagemService.saveImagemFavorita(widget.usuario, imagem);
                              if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Imagem salva como favorita')));
                            } catch (e) {
                              // desfaz a marcação se falhar
                              setState(() => _liked = false);
                              if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao salvar: $e')));
                            }
                          } else {
                            // Ao desmarcar, tenta remover do banco (silencioso em erro)
                            try {
                              await _imagemService.removeImagemFavorita(widget.usuario, imagem);
                              if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Removido dos favoritos')));
                            } catch (e) {
                              // ignorar erro de remoção ou notificar
                              if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao remover: $e')));
                            }
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (apod.isImage)
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blue.shade400, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.6),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: AspectRatio(
                        aspectRatio: 3 / 4,
                        child: Image.network(
                          apod.url,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, progress) {
                            if (progress == null) return child;
                            return Center(child: CircularProgressIndicator(value: progress.expectedTotalBytes != null ? progress.cumulativeBytesLoaded / (progress.expectedTotalBytes ?? 1) : null));
                          },
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: Colors.grey[800],
                            child: const Center(child: Icon(Icons.broken_image, size: 48, color: Colors.grey)),
                          ),
                        ),
                      ),
                    )
                  else
                    Container(
                      height: 220,
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blue.shade400, width: 3),
                      ),
                      child: Center(child: Text('Conteúdo não é imagem: ${apod.mediaType}', style: TextStyle(color: Colors.grey[300]))),
                    ),
                  const SizedBox(height: 12),
                  Text('Descrição da imagem: ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 6),
                  Text(apod.explanation, style: TextStyle(color: Colors.grey[300])),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
