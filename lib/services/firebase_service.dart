// lib/services/firebase_service.dart
import 'package:firebase_core/firebase_core.dart';

abstract class IFirebaseService {
  Future<void> initialize();
}

class FirebaseService implements IFirebaseService {
  FirebaseService._();

  static final FirebaseService instance = FirebaseService._();

  @override
  Future<void> initialize() async {
    // Implementar inicialização do Firebase aqui, por exemplo:
    // await Firebase.initializeApp();
    throw UnimplementedError();
  }
}
