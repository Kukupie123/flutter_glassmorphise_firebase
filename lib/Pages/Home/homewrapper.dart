// ignore_for_file: prefer_const_constructors, avoid_print

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teacher_student_firebae/Providers/provider_auth.dart';

import 'home.dart';

class PageHomeWrapper extends StatefulWidget {
  const PageHomeWrapper({Key? key}) : super(key: key);

  @override
  _PageHomeWrapperState createState() => _PageHomeWrapperState();
}

class _PageHomeWrapperState extends State<PageHomeWrapper> {
  late ProviderAuthConfig pro;
  StreamController sc = StreamController();

  @override
  void initState() {
    super.initState();
    pro = Provider.of<ProviderAuthConfig>(context, listen: false);
    _isEmailVerifiedAction();
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
            return Text("NOT VERIFIED");
          case "1":
            return PageHome(
              context: context,
            );
        }
        return Container();
      },
    );
  }

  Widget _getLoadingWidget() {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage("assets/bg.jpg"),
          ),
        ),
        child: Text("Verifying user data please wait..."),
      ),
    );
  }

  _isEmailVerifiedAction() async {
    print("FOO");
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
