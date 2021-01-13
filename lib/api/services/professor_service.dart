import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'package:meet_your_mates/api/models/courseAndStudents.dart';
import 'package:meet_your_mates/api/models/professor.dart';
import 'package:meet_your_mates/api/models/user.dart';
import 'package:meet_your_mates/api/util/app_url.dart';
import 'package:meet_your_mates/api/util/shared_preference.dart';

class ProfessorProvider with ChangeNotifier {
  Professor _professor = new Professor();
  var logger = Logger(level: Level.debug);
  Professor get professor => _professor;

  /// ========================================================================
  ///!      SHOULD BE USED TO SET STUDENT EVERYWHERE IN THE PROGRAM
  ///========================================================================**/
  void setProfessor(Professor professor) {
    if (professor != null) {
      User usr = new User();
      usr = _professor.user;
      _professor = professor;
      _professor.user = usr;
      notifyListeners();
    }
  }

  /// ================================================================================================
  ///!          DON'T USE IT, SHOULD ONLY BE USED ON LOGIN AND PROFILE PASSWORD UPDATE!
  ///================================================================================================**/

  void setProfessorWithUserWithPassword(Professor professor) {
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

  Future<int> autoLogin(String email, String password) async {
    logger.d("Trying AutoLogging!");
    int res = -1;
    try {
      User userTmp = new User();
      userTmp.email = email;
      userTmp.password = password;
      Response response = await post(
        AppUrl.login,
        body: json.encode(userTmp.toJson()),
        headers: {'Content-Type': 'application/json'},
      ).timeout(Duration(seconds: 10));
      logger.d("AutoLogging Response:" + response.body);
      if (response.statusCode == 200) {
        //Logged In succesfully from server
        try {
          Map responseData = jsonDecode(response.body);
          _professor = (Professor.fromJson(responseData));
          _professor.user.password = password;
          logger.d("200 AutoLogging response body");
          logger.d(response.body.toString());
          logger.d("200 AutoLogging Professor");
          logger.d(_professor.toJson().toString());
          UserPreferences().saveUser(_professor.user);
          res = 3; //Dashboard Professor
        } catch (err) {
          logger.e("Error AutoLogin 200: " + err.toString());
          res = -1;
        }
      } else if (response.statusCode == 203) {
        //Not Validated
        try {
          Map responseData = jsonDecode(response.body);
          _professor = (Professor.fromJson(responseData));
          _professor.user.password = password;
          UserPreferences().saveUser(_professor.user);
          res = 1; //Same validation screen for both professor and Student
        } catch (err) {
          logger.e("Error AutoLogin 203: " + err.toString());
          res = -1;
        }
      } else if (response.statusCode == 206) {
        //Let's Get Started not completed for professor
        try {
          Map responseData = jsonDecode(response.body);
          _professor = (Professor.fromJson(responseData));
          _professor.user.password = password;
          UserPreferences().saveUser(_professor.user);
          res = 4;
        } catch (err) {
          res = -1;
        }
      } else {
        res = -1;
      }
    } catch (err) {
      logger.e("Error AutoLogin: " + err.toString());
      UserPreferences().removeUser();
      res = -1;
    }
    return res;
  }
  //***********************************KRUNAL***********************************************************/
}
