// ignore_for_file: prefer_const_constructors, avoid_print, curly_braces_in_flow_control_structures

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teacher_student_firebae/Pages/Home/homewrapper.dart';
import 'package:teacher_student_firebae/Pages/LoginSignup/login_signup.dart';
import 'package:teacher_student_firebae/Providers/provider_auth.dart';

///Adds an event to onAuthChange and takes the decision of either opening login or homeWrapper page
class PageAuthWrapper extends StatefulWidget {
  const PageAuthWrapper({Key? key}) : super(key: key);

  @override
  _PageAuthWrapperState createState() => _PageAuthWrapperState();
}

class _PageAuthWrapperState extends State<PageAuthWrapper> {
  StreamController navSC = StreamController();

  late ProviderAuthConfig pro;

  @override
  void initState() {
    pro = Provider.of<ProviderAuthConfig>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (pro.user == null)
      //never logged in
      return PageLoginSignup();

    //Logged in, PageHomeWrapper will do further more checks
    return PageHomeWrapper();
  }
}
