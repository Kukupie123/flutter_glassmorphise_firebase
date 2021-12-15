import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:teacher_student_firebae/Models/gender.dart';
import 'package:teacher_student_firebae/Providers/provider_auth.dart';

///Responsible for handling all requests sent to firebase
class AuthService {
  static const String tableName = "TeacherTable";

  static Future<UserCredential> signIn(
      String email, String password, FirebaseAuth firebaseAuth) async {
    return await firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  static Future<UserCredential> signUp(
      String email, String password, FirebaseAuth firebaseAuth) async {
    return await firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  static Future<void> sendVerificationCode(User user) async {
    return await user.sendEmailVerification();
  }

  static Future<void> uploadStudentData(
      FirebaseFirestore fbs,
      String uid,
      String studentName,
      GENDER gender,
      Timestamp dob,
      BuildContext context) async {
    //Check if doc exists with this id

    var doc = await fbs.collection(tableName).doc(uid).get();
    if (doc.exists == false) {
      await _createUser(uid, context);
    }
    await fbs.collection(tableName).doc(uid).collection("StudentTable").add({
      "Name": studentName,
      "Gender": gender.toString().replaceAll("GENDER.", ""),
      "DOB": dob
    });
  }

  static _createUser(String uid, BuildContext context) async {
    String table = "TeacherTable";
    var pro = Provider.of<ProviderAuthConfig>(context, listen: false);
    var fbs = FirebaseFirestore.instanceFor(app: pro.firebaseApp);
    await fbs.collection(table).doc(uid).set({"dummy data": "dummy data"});
  }

  static logoutPressed(BuildContext context) async {
    Provider.of<ProviderAuthConfig>(context, listen: false)
        .firebaseAuth
        .signOut();
  }

  static updateStudentData(FirebaseFirestore fbs, String uidOfTeacher,
      String uidOfStudent, Map<String, dynamic> updatedMap) async {
    await fbs
        .collection(tableName)
        .doc(uidOfTeacher)
        .collection("StudentTable")
        .doc(uidOfStudent)
        .update(updatedMap);
  }
}
