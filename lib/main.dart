import 'package:cosmoview/services/firebase_service.dart';
import 'package:cosmoview/telas/tela_abertura.dart';
import 'package:cosmoview/telas/tela_ajuda.dart';
import 'package:cosmoview/util/widget/menuLateral.dart';
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
      home: TelaAjuda(),
    );
  }
}
