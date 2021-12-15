import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
///Stores the persistent firebaseApp, firebaseAuth and User for persistent use all across the app
class ProviderAuthConfig {
  FirebaseAuth firebaseAuth;
  FirebaseApp firebaseApp;
  User? user;

  ProviderAuthConfig(this.firebaseApp, this.firebaseAuth);
}
