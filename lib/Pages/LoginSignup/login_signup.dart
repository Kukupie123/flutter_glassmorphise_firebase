// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print, sized_box_for_whitespace

import 'dart:async';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism_buttons/glassmorphism_buttons.dart';
import 'package:provider/provider.dart';
import 'package:teacher_student_firebae/API/authservice.dart';
import 'package:teacher_student_firebae/Providers/provider_auth.dart';

class PageLoginSignup extends StatefulWidget {
  const PageLoginSignup({Key? key}) : super(key: key);

  @override
  _PageLoginSignupState createState() => _PageLoginSignupState();
}

class _PageLoginSignupState extends State<PageLoginSignup> {
  late TextEditingController emailC = TextEditingController();
  late TextEditingController passwordC = TextEditingController();

  StreamController statusSC = StreamController();

  @override
  Widget build(BuildContext context) {
    print("Inside login");
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage("assets/bg.jpg"),
            ),
          ),
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ///FIELDS
              Container(
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                      blurRadius: 16,
                      spreadRadius: 16,
                      color: Colors.black.withOpacity(0.1))
                ]),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16)),
                      height: 300,
                      width: 300,
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Column(
                              children: [
                                TextField(
                                  controller: emailC,
                                  decoration: InputDecoration(
                                    hintText: "Email",
                                    hintStyle: TextStyle(color: Colors.black),
                                    alignLabelWithHint: true,
                                    label: Icon(Icons.email),
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                ),
                                TextField(
                                  obscureText: true,
                                  controller: passwordC,
                                  decoration: InputDecoration(
                                    hintText: "Password",
                                    hintStyle: TextStyle(color: Colors.black),
                                    alignLabelWithHint: true,
                                    label: Icon(Icons.password),
                                  ),
                                  keyboardType: TextInputType.visiblePassword,
                                ),
                              ],
                            ),

                            ///BUTTON
                            StreamBuilder(
                              initialData: "default",
                              stream: statusSC.stream,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  switch (snapshot.data) {
                                    case "default":
                                      return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.all(10),
                                            child: GlassyButton(
                                                title: "Sign in",
                                                onTap: _signIn),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(10),
                                            child: GlassyButton(
                                                title: "Sign Up",
                                                onTap: _signUp),
                                          ),
                                        ],
                                      );
                                    case "loading":
                                      return Padding(
                                          padding: EdgeInsets.all(5),
                                          child: CircularProgressIndicator());
                                  }

                                  return Padding(
                                      padding: EdgeInsets.all(5),
                                      child: Text(snapshot.data.toString()));
                                } else {
                                  return Container();
                                }
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )),
        ),
      ),
    );
  }

  _signIn() async {
    statusSC.add("loading");
    //Check if login detail is empty or not
    if (emailC.text.isEmpty || passwordC.text.isEmpty) {
      statusSC.add('default');
      return;
    }

    var pro = Provider.of<ProviderAuthConfig>(context, listen: false);

    try {
      await AuthService.signIn(emailC.text, passwordC.text, pro.firebaseAuth);
    } on FirebaseAuthException catch (e) {
      statusSC.add(e.message.toString());
    }

    Future.delayed(Duration(seconds: 3))
        .then((value) => statusSC.add('default'));
  }

  _signUp() async {
    statusSC.add("loading");

    //Check if login detail is empty or not
    if (emailC.text.isEmpty || passwordC.text.isEmpty) {
      statusSC.add('default');
      return;
    }

    var pro = Provider.of<ProviderAuthConfig>(context, listen: false);

    try {
      await AuthService.signUp(emailC.text, passwordC.text, pro.firebaseAuth);
    } on Exception catch (e) {
      statusSC.add("ERROR");
      statusSC.add(e.toString());
    }
    Future.delayed(Duration(seconds: 3))
        .then((value) => statusSC.add('default'));
  }
}
