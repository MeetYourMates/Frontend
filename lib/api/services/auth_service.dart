import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'package:meet_your_mates/api/models/student.dart';
import 'package:meet_your_mates/api/models/user.dart';
import 'package:meet_your_mates/api/util/app_url.dart';
import 'package:meet_your_mates/api/util/shared_preference.dart';

enum Status {
  NotLoggedIn,
  NotRegistered,
  LoggedIn,
  Registered,
  Authenticating,
  Registering,
  LoggedOut
}

class AuthProvider with ChangeNotifier {
  Status _loggedInStatus = Status.NotLoggedIn;
  Status _registeredInStatus = Status.NotRegistered;
  var logger = Logger();
  Status get loggedInStatus => _loggedInStatus;
  Status get registeredInStatus => _registeredInStatus;
  // ignore: todo
  //Login Service without proper error handling TODO: FUTURE REPAIR
  Future<Map<String, dynamic>> login(String email, String password) async {
    var result;

    User userTmp = new User();
    userTmp.email = email;
    userTmp.password = password;

    _loggedInStatus = Status.Authenticating;
    notifyListeners();

    Response response = await post(
      AppUrl.login,
      body: json.encode(userTmp.toJson()),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      logger.d(response.body);
      Map responseData = jsonDecode(response.body);
      Student authenticatedStudent = Student.fromJson(responseData);
      logger.d(authenticatedStudent);
      UserPreferences().saveUser(userTmp);
      logger.d("User in Shared Preferences: " + userTmp.toString());
      _loggedInStatus = Status.LoggedIn;
      notifyListeners();

      result = {
        'status': true,
        'message': 'Successful',
        'student': authenticatedStudent
      };
    } else {
      _loggedInStatus = Status.NotLoggedIn;
      notifyListeners();
      result = {
        'status': false,
        'message': json.decode(response.body)['error']
      };
    }
    return result;
  }

  Future<Map<String, dynamic>> register(
      String email, String password, String passwordConfirmation) async {
    User userTmp = new User();
    if (password == passwordConfirmation) {
      userTmp.email = email;
      userTmp.password = password;
    } else {
      return {'status': false, 'message': 'Password not same', 'data': userTmp};
    }

    _registeredInStatus = Status.Registering;
    notifyListeners();

    return await post(AppUrl.register,
            body: json.encode(userTmp.toJson()),
            headers: {'Content-Type': 'application/json'})
        .then(onValue)
        .catchError(onError);
  }

  static Future<FutureOr> onValue(Response response) async {
    var result;
    final Map responseData = json.decode(response.body);

    if (response.statusCode == 200) {
      print(response.body);
      Map responseData = jsonDecode(response.body);
      //Student authenticatedStudent = Student.fromJson(responseData);
      //print(authenticatedStudent);

      User authenticatedStudent = User.fromJson(responseData);

      UserPreferences().saveUser(authenticatedStudent);
      result = {
        'status': true,
        'message': 'Successfully registered',
        'data': authenticatedStudent
      };
    } else {
      result = {
        'status': false,
        'message': 'Registration failed',
        'data': responseData
      };
    }

    return result;
  }

  static onError(error) {
    print("the error is $error.detail");
    return {'status': false, 'message': 'Unsuccessful Request', 'data': error};
  }
}
