import 'dart:convert';

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
          res = 2;
        } catch (err) {
          logger.e("Error AutoLogin 204: " + err.toString());
          res = -1;
        }
      } else {
        res = -1;
      }
    } catch (err) {
      logger.e("Error AutoLogin: " + err.toString());
      res = -1;
    }
    return res;
  }
}
