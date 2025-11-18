// lib/services/firebase_service.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

abstract class IFirebaseService {
  Future<void> initialize();
}

class FirebaseService implements IFirebaseService {
  FirebaseService._();

  static final FirebaseService instance = FirebaseService._();

  @override
  Future<void> initialize() async {
    try {
      // Inicializa o Firebase com a configuração padrão (útil para Android quando
      // você já tem `google-services.json`). Se você gerar `firebase_options.dart`
      // com `flutterfire configure`, substitua por:
      // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
      await Firebase.initializeApp();
      if (kDebugMode) {
        // Mensagem opcional de debug
        print('Firebase initialized');
      }
    } catch (e) {
      // Relança para que o erro seja visível na inicialização da app
      debugPrint('Erro ao inicializar Firebase: $e');
      rethrow;
    }
  }
}
