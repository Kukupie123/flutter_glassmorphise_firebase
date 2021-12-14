// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:ui';

import 'package:flutter/material.dart';

class CompStudentDetail extends StatelessWidget {
  const CompStudentDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: Container(
          height: 150,
          width: double.infinity,
          color: Colors.blueGrey.withOpacity(0.2),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaY: 5, sigmaX: 5),
            child: Card(
                child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Text("Kuchuk Borom Debbarma"),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: [Text("Gender : "), Text("Male")],
                    ),
                  ),
                  Row(
                    children: [Text("Date of birth : "), Text("10/12/2021")],
                  )
                ],
              ),
            )),
          )),
    );
  }
}
