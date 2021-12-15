// ignore_for_file: empty_constructor_bodies

import 'gender.dart';

class ModelStudent {
  String name;
  late GENDER gender;
  DateTime dob;

  ModelStudent(this.name, String gender, this.dob) {
    switch (gender) {
      case "male":
        this.gender = GENDER.male;
        break;
      case "female":
        this.gender = GENDER.female;
        break;
      case "other":
        this.gender = GENDER.other;
        break;
    }
  }
}
