// ignore_for_file: prefer_const_constructors, avoid_print

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teacher_student_firebae/Pages/VerifyEmail/verifyemail.dart';
import 'package:teacher_student_firebae/Providers/provider_auth.dart';

import 'home.dart';

///Shows different pages based on email verification of the logged in user
class PageHomeWrapper extends StatefulWidget {
  const PageHomeWrapper({Key? key}) : super(key: key);

  @override
  _PageHomeWrapperState createState() => _PageHomeWrapperState();
}

class _PageHomeWrapperState extends State<PageHomeWrapper> {
  late ProviderAuthConfig pro; //ProviderAuthConfig object from our provider.
  StreamController sc = StreamController(); //data is added in this StreamController, that data is used by streamBuilder to determine which UI to view

  @override
  void initState() {
    super.initState();
    pro = Provider.of<ProviderAuthConfig>(context, listen: false);
    _isEmailVerifiedAction(); //Runs an email verification check on initialization
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: sc.stream,
      initialData: "loading",
      builder: (context, snapshot) {
        switch (snapshot.data) {
          case "loading":
            return _getLoadingWidget();
          case "0":
            return PageVerifyEmail();
          case "1":
            return PageHome(

            );
        }
        return Container();
      },
    );
  }

  Widget _getLoadingWidget() {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage("assets/bg.jpg"),
              ),
            ),
            child: Text("Verifying user data please wait..."),
          ),
        ));
  }

  _isEmailVerifiedAction() async {
    //pro.user can't be null as we reach this page only when user is not null
    await pro.user!.reload();
    //after reloading we are going check if email has been verified or not
    //based on it we are going to update the streamBuilder
    if (pro.user!.emailVerified) {
      sc.add("1");
    } else {
      sc.add("0");
    }
  }
}
