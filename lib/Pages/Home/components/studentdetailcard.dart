// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:ui';

import 'package:flutter/material.dart';

class CompStudentDetail extends StatelessWidget {
  const CompStudentDetail(
      {Key? key, required this.name, required this.dob, required this.gender})
      : super(key: key);
  final String name;
  final String dob;
  final String gender;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: Container(
        height: 150,
        width: double.infinity,
        color: Colors.blueGrey.withOpacity(0.5),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaY: 15, sigmaX: 15),
          child: Card(
              color: Colors.white.withOpacity(0),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(name),
                          IconButton(onPressed: () {}, icon: Icon(Icons.edit))
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: [Text("Gender : "), Text(gender)],
                      ),
                    ),
                    Row(
                      children: [Text("DOB : "), Text(dob)],
                    )
                  ],
                ),
              )),
        ),
      ),
    );
  }

  _onEditPressed() {}
}
