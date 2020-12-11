import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'package:meet_your_mates/api/models/student.dart';
import 'package:meet_your_mates/api/models/user.dart';
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
      _student = student;
      notifyListeners();
    }
  }

//*******************************KRUNAL**************************************/
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
          userTmp.id = _student.user.id;
          userTmp.token = _student.user.token;
          UserPreferences().saveUser(userTmp);
          _student.user = userTmp;
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
          userTmp.id = _student.user.id;
          userTmp.token = _student.user.token;
          UserPreferences().saveUser(userTmp);
          _student.user = userTmp;
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
          userTmp.id = _student.user.id;
          userTmp.token = _student.user.token;
          UserPreferences().saveUser(userTmp);
          _student.user = userTmp;
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
  //*******************************KRUNAL**************************************/
}
