import 'package:cosmoview/data/services/firebase_service.dart';
import 'package:cosmoview/features/favoritos/view/favoritos_view.dart';
import 'package:cosmoview/features/imagem_do_dia/view/imagem_view.dart';
import 'package:cosmoview/features/splash/view/abertura_view.dart';
import 'package:cosmoview/telas/tela_ajuda.dart';
import 'package:cosmoview/ui/menuLateral.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseService.instance.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF072C6C),
        ),
      ),
      home: TelaAbertura(),
    );
  }
}
