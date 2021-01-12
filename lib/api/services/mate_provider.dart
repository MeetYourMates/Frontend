import 'package:flutter/foundation.dart';
import 'package:meet_your_mates/api/models/student.dart';

class MateProvider with ChangeNotifier {
  Student _student = new Student();

  Student get student => _student;

  void setStudent(Student student) {
    _student = student;
    notifyListeners();
  }
}
