import 'package:cosmoview/features/favoritos/view/favoritos_view.dart';
import 'package:cosmoview/telas/tela_ajuda.dart';
import 'package:cosmoview/util/menuLateral.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'data/services/firebase_service.dart';
import 'features/splash/view/abertura_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseService.instance.initialize();
  await dotenv.load(fileName: ".env");
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
      //home: TelaFavoritos(usuarioId: "HjEG1OrjqyUdMCk27I3p"),
      home: TelaAbertura(),
    );
  }
}
