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
}
