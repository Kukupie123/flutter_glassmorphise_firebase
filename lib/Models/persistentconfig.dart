import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class ModelPersistentConfig {
  FirebaseApp? fba;
  FirebaseAuth? fbAuth;

  ModelPersistentConfig() {
    _initializeFBA();
  }

  Future<void> _initializeFBA() async {
    fba = await Firebase.initializeApp();
  }
}
