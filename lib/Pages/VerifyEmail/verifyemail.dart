// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teacher_student_firebae/API/authservice.dart';
import 'package:teacher_student_firebae/Providers/provider_auth.dart';

class PageVerifyEmail extends StatefulWidget {
  const PageVerifyEmail({Key? key}) : super(key: key);

  @override
  _PageVerifyEmailState createState() => _PageVerifyEmailState();
}

class _PageVerifyEmailState extends State<PageVerifyEmail> {
  bool processing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          decoration: BoxDecoration(
              image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage('assets/bg2.jpg'),
          )),
          child: SizedBox(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaY: 5, sigmaX: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Your email has not been verified yet please click below",
                    style: TextStyle(color: Colors.white),
                  ),
                  TextButton(
                      onPressed: () async {
                        if (processing) return;
                        processing = true;
                        await AuthService.sendVerificationCode(
                            Provider.of<ProviderAuthConfig>(context,
                                    listen: false)
                                .user!);
                        processing = false;
                      },
                      child: Text("Send Verification code",
                          style: TextStyle(fontSize: 20))),
                  TextButton(
                      onPressed: () async {
                        if (processing) return;
                        processing = true;
                        await AuthService.logoutPressed(context);
                        processing = false;
                      },
                      child: Text(
                        "Logout",
                        style: TextStyle(fontSize: 20),
                      )),
                ],
              ),
            ),
          )),
    );
  }
}
