import 'dart:convert';
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'package:meet_your_mates/api/models/student.dart';
import 'package:meet_your_mates/api/models/user.dart';
import 'package:meet_your_mates/api/util/app_url.dart';

class StudentProvider with ChangeNotifier {
  Student _student = new Student();

  Student get student => _student;
  var logger = Logger();
  void setStudent(Student student) {
    if (student != null) {
      _student = student;
      notifyListeners();
    }
  }

  Future<bool> autoLogin(String email, String password) async {
    logger.d("Trying AutoLogging!");
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
        Map responseData = jsonDecode(response.body);
        setStudent(Student.fromJson(responseData));
        return true;
      } else {
        return false;
      }
    } catch (e) {
      logger.e("Error AutoLogin: " + e.toString());
      return false;
    }
  }

  //************************PEP****************************/

  Future<int> getCourseStudents(String course) async {
    int res = -1;
    logger.d("Retrieving course students");
    try {
      Response response = await get(
        AppUrl.getCourseStudents,
        body: json.encode(updated.toJson()),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        logger.d("Student updated:");
        res = 0;
      }
    } catch (err) {
      logger.e("Error updating Student: " + err.toString());
      res = -1;
    }
    return res;
  }

  //*******************************************************/
}
