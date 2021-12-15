import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:teacher_student_firebae/API/authservice.dart';

class ProviderAuthConfig {
  //We are extending from ChangeNotifierProvider
  FirebaseAuth firebaseAuth;
  FirebaseApp firebaseApp;
  User? user;

  ProviderAuthConfig(this.firebaseApp, this.firebaseAuth);
}
