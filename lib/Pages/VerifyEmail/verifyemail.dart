// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

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
                      Provider.of<ProviderAuthConfig>(context, listen: false)
                          .user!);
                  processing = false;
                },
                child: Text("Send Verification code"))
          ],
        ),
      ),
    );
  }
}
