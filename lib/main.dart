// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, curly_braces_in_flow_control_structures, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teacher_student_firebae/Pages/LoginSignup/login_signup.dart';
import 'package:teacher_student_firebae/Providers/provider_auth.dart';
import 'Pages/Home/homewrapper.dart';

void main() {
  //Ensures that widgets have been initialised
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MaterialApp(home: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PreWrapper();
  }
}

class PreWrapper extends StatelessWidget {
  const PreWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FirebaseApp>(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        if (snapshot.hasData == false) {
          return Scaffold(
            body: Text("Loading firebase"),
          );
        } else {
          return InitialWrapper(
            firebaseApp: snapshot.data!,
          );
        }
      },
    );
  }
}

///Responsible for creating provider with the provided parameters
class InitialWrapper extends StatefulWidget {
  const InitialWrapper({Key? key, required this.firebaseApp}) : super(key: key);

  final FirebaseApp firebaseApp;

  @override
  _InitialWrapperState createState() => _InitialWrapperState();
}

class _InitialWrapperState extends State<InitialWrapper> {
  late FirebaseAuth _fireBaseAuth;

  @override
  void initState() {
    super.initState();
    //initializing the auth
    _fireBaseAuth = FirebaseAuth.instanceFor(app: widget.firebaseApp);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ProviderAuthConfig>(
          create: (context) =>
              ProviderAuthConfig(widget.firebaseApp, _fireBaseAuth),
        ),
      ],
      builder: (context, child) => PageAuthListener(),
    );
  }
}

///Takes firebase auth and attaches an event to the authStateChange event
///Thus taking us to either login page or home page based on if user is null or not
class PageAuthListener extends StatefulWidget {
  const PageAuthListener({Key? key}) : super(key: key);

  @override
  _PageAuthListenerState createState() => _PageAuthListenerState();
}

class _PageAuthListenerState extends State<PageAuthListener> {
  late ProviderAuthConfig pro;

  @override
  void initState() {
    super.initState();
    pro = Provider.of<ProviderAuthConfig>(context, listen: false);
    pro.firebaseAuth.authStateChanges().listen((event) {
      pro.user = event;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    if (pro.user == null) {
      print("Loading login page");
      return PageLoginSignup();
    }
    return PageHomeWrapper();
  }
}
