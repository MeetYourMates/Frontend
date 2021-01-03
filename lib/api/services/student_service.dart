import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'package:meet_your_mates/api/models/student.dart';
import 'package:meet_your_mates/api/models/user.dart';
import 'package:meet_your_mates/api/models/course.dart';
import 'package:meet_your_mates/api/models/courseAndStudents.dart';
import 'package:meet_your_mates/api/util/app_url.dart';
import 'package:meet_your_mates/api/util/shared_preference.dart';

class StudentProvider with ChangeNotifier {
  Student _student = new Student();
  Student get student => _student;
  var logger = Logger(level: Level.warning);

  void setStudent(Student student) {
    if (student != null) {
      User usr = new User();
      usr = _student.user;
      _student = student;
      _student.user = usr;
      notifyListeners();
    }
  }

  void setStudentWithUser(Student student) {
    if (student != null) {
      String pass = _student.user.password;
      _student = student;
      _student.user.password = pass;
      notifyListeners();
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
      );
      logger.d("AutoLogging Response:" + response.body);
      if (response.statusCode == 200) {
        //Logged In succesfully  from server
        try {
          Map responseData = jsonDecode(response.body);
          _student = (Student.fromJson(responseData));
          _student.user.password = password;
          UserPreferences().saveUser(_student.user);
          res = 0;
        } catch (err) {
          logger.e("Error AutoLogin 200: " + err.toString());
          res = -1;
        }
      } else if (response.statusCode == 203) {
        //Not Validated
        try {
          Map responseData = jsonDecode(response.body);
          _student = (Student.fromJson(responseData));
          _student.user.password = password;
          UserPreferences().saveUser(_student.user);
          res = 1;
        } catch (err) {
          logger.e("Error AutoLogin 203: " + err.toString());
          res = -1;
        }
      } else if (response.statusCode == 206) {
        //Let's Get Started not completed
        try {
          Map responseData = jsonDecode(response.body);
          _student = (Student.fromJson(responseData));
          _student.user.password = password;
          UserPreferences().saveUser(_student.user);
          res = 2;
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
  //*********************************************************************/

  //************************POL****************************/

  Future<int> upload(Student updated) async {
    int res = -1;
    logger.d("Trying to update student:");
    try {
      Response response = await put(
        AppUrl.editProfile,
        body: json.encode(updated.toJson()),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        logger.d("Student updated:");
        notifyListeners();
        res = 0;
      }
    } catch (err) {
      logger.e("Error updating Student: " + err.toString());
      res = -1;
    }
    return res;
  }

//*******************************************************/

//************************PEP****************************/
  Future<List<Student>> getCourseStudents() async {
    logger.d("Trying to get course students:");
    try {
      Response response = await get(
        AppUrl.getCourseStudents +
            '/464951543030303032303230', //HABRÁ QUE PASAR EL ID COMO PARÁMETRO
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        logger.d("Student retrieved:");
        //Convert from json List of Map to List of Student
        var decodedList = (json.decode(response.body) as List<dynamic>);
        List<Student> students =
            decodedList.map((i) => Student.fromJson(i)).toList();
        //Send back List of Students
        return students;
      }
      return null;
    } catch (err) {
      logger.e("Error getting student: " + err.toString());
      return null;
    }
  }
//*******************************************************/

//************************PEP****************************/
  Future<List<CourseAndStudents>> getStudentCourses() async {
    logger.d("Trying to get student courses:");
    try {
      Response response = await get(
        AppUrl.getStudentsAndCourses +
            '/5fe3d2780c653345e8b1084a', //TENGO QUE PASAR EL ID DEL USUARIO LOGEADO
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        logger.d("Courses retrieved:");
        //Convert from json List of Map to List of Student
        var decodedList = (json.decode(response.body) as List<dynamic>);
        List<CourseAndStudents> courses =
            decodedList.map((i) => CourseAndStudents.fromJson(i)).toList();
        //Send back List of Students
        return courses;
      }
      return null;
    } catch (err) {
      logger.e("Error getting student courses: " + err.toString());
      return null;
    }
  }
//*******************************************************/

}
