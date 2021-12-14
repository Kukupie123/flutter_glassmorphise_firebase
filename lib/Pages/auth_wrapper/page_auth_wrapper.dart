// ignore_for_file: prefer_const_constructors, avoid_print

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teacher_student_firebae/Pages/Home/homewrapper.dart';
import 'package:teacher_student_firebae/Pages/LoginSignup/login_signup.dart';
import 'package:teacher_student_firebae/Providers/provider_auth.dart';

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
    if(pro.user == null){
      //never logged in
      return PageLoginSignup();
    }
    return PageHomeWrapper();
  }


}
