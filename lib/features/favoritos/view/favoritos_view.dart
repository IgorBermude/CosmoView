import 'package:cosmoview/features/favoritos/view/tela_detalhe_imagem.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../ui/menuLateral.dart';
import '../viewmodel/favoritos_viewmodel.dart';
import '../repository/favoritos_repository.dart';

class TelaFavoritos extends StatelessWidget {
  final String? usuarioId;

  const TelaFavoritos({super.key, required this.usuarioId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FavoritosViewModel(FavoritosRepository())
        ..carregarFavoritos(usuarioId!),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          centerTitle: true,
          title: const Text("Imagens Favoritas"),
        ),
        drawer: MenuLateral(),
        body: Consumer<FavoritosViewModel>(
          builder: (context, vm, child) {
            return Column(
              children: [
                /// -------------------------------
                /// ★ Botão para gerar imagens de teste
                /// -------------------------------
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ElevatedButton(
                    onPressed: () {
                      vm.adicionarFavoritosTeste(usuarioId!);
                    },
                    child: const Text("Gerar 10 imagens de teste no Firebase"),
                  ),
                ),

                /// -------------------------------
                /// ★ Botão para recarregar favoritos
                /// -------------------------------
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: ElevatedButton(
                    onPressed: () {
                      vm.carregarFavoritos(usuarioId!);
                    },
                    child: const Text("Recarregar favoritos"),
                  ),
                ),

                Expanded(
                  child: _buildGrid(vm),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildGrid(FavoritosViewModel vm) {
    if (vm.carregando) {
      return const Center(child: CircularProgressIndicator());
    }

    if (vm.erro != null) {
      return Center(child: Text("Erro: ${vm.erro}"));
    }

    if (vm.imagens.isEmpty) {
      return const Center(child: Text("Nenhuma imagem favorita."));
    }

    return Padding(
      padding: const EdgeInsets.all(10),
      child: GridView.builder(
        itemCount: vm.imagens.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        itemBuilder: (context, index) {
          final img = vm.imagens[index];

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TelaDetalheImagem(imagem: img),
                ),
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.network(img.url, fit: BoxFit.cover),
                  ),

                  // ⭐ Botão de remover
                  Positioned(
                    top: 8,
                    right: 8,
                    child: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.white),
                      onPressed: () {
                        vm.removerFavorito(usuarioId!, index);
                      },
                    ),
                  ),
                ],
              ),
            ),
          );

        },
      ),
    );
  }
}
