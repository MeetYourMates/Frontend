import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'package:meet_your_mates/api/models/courseAndStudents.dart';
import 'package:meet_your_mates/api/models/professor.dart';
import 'package:meet_your_mates/api/util/app_url.dart';

class ProfessorProvider with ChangeNotifier {
  Professor _professor = new Professor();
  var logger = Logger(level: Level.debug);
  Professor get professor => _professor;

  void setProfessor(Professor professor) {
    _professor = professor;
    notifyListeners();
  }

  /// ======================
  ///    KRUNAL
  ///========================**/
  Future<List<CourseAndStudents>> getProfessorCourses(String id) async {
    logger.d("Trying to get student courses:");
    try {
      Response response = await get(
        AppUrl.getProfessorCoursesAndStudents + '/' + id,
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        logger.d("Courses retrieved:");
        //Convert from json List of Map to List of Student
        var decodedList = (json.decode(response.body) as List<dynamic>);
        List<CourseAndStudents> courses = decodedList.map((i) => CourseAndStudents.fromJson(i)).toList();
        //Send back List of Students
        return courses;
      }
      return null;
    } catch (err) {
      logger.e("Error getting student courses: " + err.toString());
      return null;
    }
  }
  //***********************************KRUNAL***********************************************************/
}
