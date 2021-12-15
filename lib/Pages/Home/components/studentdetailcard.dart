// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, curly_braces_in_flow_control_structures

import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:teacher_student_firebae/Models/gender.dart';

class CompStudentDetailCard extends StatefulWidget {
  const CompStudentDetailCard(
      {Key? key,
      required this.gender,
      required this.dob,
      required this.name,
      required this.id})
      : super(key: key);
  final String name;
  final String dob;
  final String gender;
  final String id;

  @override
  _CompStudentDetailCardState createState() => _CompStudentDetailCardState();
}

class _CompStudentDetailCardState extends State<CompStudentDetailCard> {
  bool isInDeleteMode = false;
  late GENDER genderEnum;
  Timestamp? dob;

  @override
  void initState() {
    super.initState();

    switch (widget.gender) {
      case "male":
        genderEnum = GENDER.male;
        break;
      case "female":
        genderEnum = GENDER.female;
        break;
      case "other":
        genderEnum = GENDER.other;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.25,
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
                    _nameDecider(),
                    _genderDecider(),
                    _dobDecider(),
                  ],
                ),
              )),
        ),
      ),
    );
  }

  Widget _nameDecider() {
    if (isInDeleteMode) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            child: TextField(),
          ),
          IconButton(
              onPressed: () {
                if (isInDeleteMode == true)
                  setState(() {
                    isInDeleteMode = false;
                  });
              },
              icon: Icon(Icons.backspace))
        ],
      );
    }
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(widget.name),
          IconButton(onPressed: _editPressed, icon: Icon(Icons.edit))
        ],
      ),
    );
  }

  Widget _genderDecider() {
    if (isInDeleteMode)
      return ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
            color: Colors.white,
            child: Center(
              child: DropdownButton(
                  dropdownColor: Colors.white,
                  icon: Icon(Icons.male),
                  elevation: 0,
                  underline: SizedBox(),
                  value: genderEnum,
                  items: GENDER.values.map((e) {
                    return DropdownMenuItem<GENDER>(
                        alignment: Alignment.center,
                        value: e,
                        child: Text(e
                            .toString()
                            .replaceAll("GENDER.", "")
                            .toUpperCase()));
                  }).toList(),
                  onChanged: (content) {
                    setState(() {
                      genderEnum = content as GENDER;
                    });
                  }),
            )),
      );
    else
      return Padding(
        padding: EdgeInsets.only(bottom: 10),
        child: Row(
          children: [Text("Gender : "), Text(widget.gender)],
        ),
      );
  }

  Widget _dobDecider() {
    if (isInDeleteMode) {
      return IconButton(
          onPressed: () {
            showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime.now(),
            ).then((value) {
              if (value != null) {
                setState(() {
                  dob = Timestamp.fromDate(value);
                });
              }
            });
          },
          icon: Icon(Icons.two_mp_sharp));
    }
    return Row(
      children: [Text("DOB : "), Text(widget.dob)],
    );
  }

  _editPressed() {
    if (isInDeleteMode == false)
      setState(() {
        isInDeleteMode = true;
      });
  }

  _updateData() async {

  }
}
