// ignore_for_file: prefer_const_constructors, curly_braces_in_flow_control_structures, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, avoid_print

import 'dart:async';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:teacher_student_firebae/Models/gender.dart';
import 'package:teacher_student_firebae/Pages/Home/components/studentdetailcard.dart';
import 'package:teacher_student_firebae/Providers/provider_auth.dart';

class PageHome extends StatefulWidget {
  const PageHome({Key? key, required this.context}) : super(key: key);
  final BuildContext context;

  @override
  _PageHomeState createState() => _PageHomeState();
}

class _PageHomeState extends State<PageHome> {
  final String tableName = "TeacherTable";
  bool serverProcessInProgress = false;
  Timestamp? dob;

  int index = 0;

  GENDER gender = GENDER.male;

  final TextEditingController nameC = TextEditingController();

  late Stream<QuerySnapshot<Map<String, dynamic>>> studentCollectionStream;

  @override
  void initState() {
    super.initState();
    studentCollectionStream = FirebaseFirestore.instanceFor(
            app: Provider.of<ProviderAuthConfig>(context, listen: false)
                .firebaseApp)
        .collection(tableName)
        .doc(Provider.of<ProviderAuthConfig>(context, listen: false).user!.uid)
        .collection("StudentTable")
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage('assets/bg2.jpg'),
          )),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Center(
                child: AnimatedSwitcher(
                  duration: Duration(seconds: 1),
                  child: getForm(),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: FancyBottomNavigation(
        tabs: [
          TabData(iconData: Icons.add, title: "Add student"),
          TabData(iconData: Icons.list, title: "View students")
        ],
        onTabChangedListener: (position) {
          setState(() {
            index = position;
          });
        },
        activeIconColor: Colors.black,
        barBackgroundColor: Colors.blueGrey,
        initialSelection: 0,
      ),
    );
  }

  Widget getForm() {
    if (index == 0) {
      return Padding(
        padding: EdgeInsets.all(10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                  blurRadius: 0,
                  color: Colors.white.withOpacity(0.2),
                  spreadRadius: 100)
            ]),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaY: 5, sigmaX: 5),
              child: Container(
                width: double.infinity,
                color: Colors.blueGrey.withOpacity(0.3),
                height: MediaQuery.of(context).size.height * 0.8,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        "Add student",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                      TextField(
                        controller: nameC,
                        decoration: InputDecoration(
                          hintText: "Name",
                          alignLabelWithHint: true,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Date of Birth :"),
                            Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: IconButton(
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
                                  icon: Icon(Icons.date_range)),
                            ),
                          ],
                        ),
                      ),

                      ///Gender drop down
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                            width: 200,
                            color: Colors.white,
                            child: Center(
                              child: DropdownButton(
                                  dropdownColor: Colors.white,
                                  icon: Icon(Icons.male),
                                  elevation: 0,
                                  underline: SizedBox(),
                                  value: gender,
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
                                      gender = content as GENDER;
                                    });
                                  }),
                            )),
                      ),

                      ///Upload button
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: TextButton.icon(
                          onPressed: _uploadPressed,
                          icon: Icon(
                            Icons.upload,
                            color: Colors.white,
                          ),
                          label: Text(
                            "Upload",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      return _studentListWidgetDecider();
    }
  }

  Widget _studentListWidgetDecider() {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: studentCollectionStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        } else {
          if (snapshot.hasData)
            return SizedBox(
                height: MediaQuery.of(context).size.height * 0.8,
                child: ListView(
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data()! as Map<String, dynamic>;

                    var dpb = data['DOB'] as Timestamp;
                    DateTime gg = dpb.toDate();

                    return CompStudentDetailCard(
                      dob: gg.day.toString() +
                          "/" +
                          gg.month.toString() +
                          "/" +
                          gg.year.toString(),
                      gender: data["Gender"],
                      name: data["Name"],
                      id: document.id,
                    );
                  }).toList(),
                ));
          else
            return Container();
        }
      },
    );
  }

  _uploadPressed() async {
    if (serverProcessInProgress == true) {
      Fluttertoast.showToast(
          msg: "Please wait for previous process to complete",
          backgroundColor: Colors.white.withOpacity(0.7));
      return;
    }
    serverProcessInProgress = true;
    const String tableName = "TeacherTable";
    if (nameC.text.isEmpty) {
      Fluttertoast.showToast(
          msg: "Empty Name field",
          backgroundColor: Colors.white.withOpacity(0.7));
      serverProcessInProgress = false;
      return;
    }
    if (dob == null) {
      Fluttertoast.showToast(
          msg: "Please Select a date of birth",
          backgroundColor: Colors.white.withOpacity(0.7));
      serverProcessInProgress = false;

      return;
    }

    try {
      ProviderAuthConfig pro =
          Provider.of<ProviderAuthConfig>(context, listen: false);
      FirebaseFirestore fbs =
          FirebaseFirestore.instanceFor(app: pro.firebaseApp);

      await pro.firebaseAuth.signInWithEmailAndPassword(
          email: "kukuborom@gmail.com", password: "123456");

      String uid = pro.user!.uid;
      print(uid);

      //Check if doc exists with this id

      var doc = await fbs.collection(tableName).doc(uid).get();
      if (doc.exists == false) {
        await _createUser(uid);
      }
      await fbs.collection(tableName).doc(uid).collection("StudentTable").add({
        "Name": nameC.text,
        "Gender": gender.toString().replaceAll("GENDER.", ""),
        "DOB": dob
      });

      serverProcessInProgress = false;

      await Future.delayed(Duration(seconds: 3));
    } on FirebaseException catch (e) {
      serverProcessInProgress = false;
      Fluttertoast.showToast(
          msg: e.message.toString(),
          backgroundColor: Colors.white.withOpacity(0.7));

      await Future.delayed(Duration(seconds: 3));
      print(e.toString());
    }
  }

  _createUser(String uid) async {
    String table = "TeacherTable";
    var pro = Provider.of<ProviderAuthConfig>(context, listen: false);
    var fbs = FirebaseFirestore.instanceFor(app: pro.firebaseApp);
    await fbs.collection(table).doc(uid).set({"dummy data": "dummy data"});
  }
}
