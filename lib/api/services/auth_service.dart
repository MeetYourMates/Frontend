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
  NotCompleted,
  Registering,
  LoggedOut,
  Validating,
  NotValidated,
  Validated
}

class AuthProvider with ChangeNotifier {
  Status _loggedInStatus = Status.NotLoggedIn;
  Status _registeredInStatus = Status.NotRegistered;
  Status _validatedStatus = Status.NotValidated;

  Status get loggedInStatus => _loggedInStatus;
  Status get registeredInStatus => _registeredInStatus;
  Status get validatedStatus => _validatedStatus;
  var logger = Logger();
  // ignore: todo
  //Login Service without proper error handling TODO: FUTURE REPAIR
  Future<Map<String, dynamic>> login(String email, String password) async {
    var result;
    int res = -1;
    User userTmp = new User();
    userTmp.email = email;
    userTmp.password = password;
    _loggedInStatus = Status.Authenticating;
    notifyListeners();
    Student authenticatedStudent = new Student();
    Response response;
    try {
      response = await post(
        AppUrl.login,
        body: json.encode(userTmp.toJson()),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (err) {
      //Cannot Even Send a request -->Probably No connection
      res = -1;
      return result = {
        'status': res,
        'message': "Cannot make Request, connect to Internet!"
      };
    }
    //NEW WAY
    if (response.statusCode == 200) {
      //Logged In succesfully  from server
      try {
        Map responseData = jsonDecode(response.body);
        authenticatedStudent = Student.fromJson(responseData);
        userTmp.id = authenticatedStudent.user.id;
        userTmp.token = authenticatedStudent.user.token;
        authenticatedStudent.user = userTmp;
        UserPreferences().saveUser(userTmp);
        logger.d("User in Shared Preferences: " + userTmp.toString());
        _loggedInStatus = Status.LoggedIn;
        notifyListeners();
        res = 0;
        result = {
          'status': res,
          'message': _loggedInStatus,
          'student': authenticatedStudent
        };
      } catch (err) {
        res = -1;
        result = {'status': res, 'message': "Failed To Login!"};
      }
    } else if (response.statusCode == 203) {
      //Not Validated
      try {
        //Not Validated Mean Student Doesn't Exist
        Map responseData = jsonDecode(response.body);
        authenticatedStudent = Student.fromJson(responseData);
        userTmp.id = authenticatedStudent.user.id;
        userTmp.token = authenticatedStudent.user.token;
        authenticatedStudent.user = userTmp;
        UserPreferences().saveUser(userTmp);
        logger.d("User in Shared Preferences: " + userTmp.toString());
        _loggedInStatus = Status.NotValidated;
        notifyListeners();
        res = 1;
        result = {
          'status': res,
          'message': _loggedInStatus,
          'student': authenticatedStudent
        };
      } catch (err) {
        res = -1;
        result = {'status': res, 'message': "Failed To Login!"};
      }
    } else if (response.statusCode == 206) {
      //Let's Get Started not completed
      try {
        Map responseData = jsonDecode(response.body);
        authenticatedStudent = Student.fromJson(responseData);
        userTmp.id = authenticatedStudent.user.id;
        userTmp.token = authenticatedStudent.user.token;
        authenticatedStudent.user = userTmp;
        UserPreferences().saveUser(userTmp);
        logger.d("User in Shared Preferences: " + userTmp.toString());
        _loggedInStatus = Status.NotCompleted;
        notifyListeners();
        res = 2;
        result = {
          'status': res,
          'message': _loggedInStatus,
          'student': authenticatedStudent
        };
      } catch (err) {
        result = {
          'status': res,
          'message': "Failed To Login!--> Error: " + err.toString()
        };
        _loggedInStatus = Status.NotLoggedIn;
        notifyListeners();
        res = -1;
      }
    } else {
      res = -1;
      _loggedInStatus = Status.NotLoggedIn;
      notifyListeners();
      result = {'status': res, 'message': json.decode(response.body)['error']};
    }
    return result;
  }

  Future<Map<String, dynamic>> register(String email, String password) async {
    var result;

    final Map<String, dynamic> registerData = {
      'email': email,
      'password': password
    };

    _registeredInStatus = Status.Registering;
    notifyListeners();
    try {
      Response response = await post(AppUrl.register,
          body: json.encode(registerData),
          headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 201) {
        User newUser = new User(id: null, email: email, password: password);
        UserPreferences().saveUser(newUser);
        _registeredInStatus = Status.Registered;
        notifyListeners();
        result = {'status': true, 'message': "User registered"};
      } else if (response.statusCode == 409) {
        _registeredInStatus = Status.NotRegistered;
        notifyListeners();
        result = {'status': false, 'message': "user already exists"};
      } else {
        _registeredInStatus = Status.NotRegistered;
        notifyListeners();
        result = {'status': false, 'message': "Error"};
      }
    } catch (err) {
      result = {'status': false, 'message': "Error Couln't Register!"};
    }
    return result;
  }

  Future<Map<String, dynamic>> validateCode(String code) async {
    var result;
    _validatedStatus = Status.Validating;
    notifyListeners();
    Response response = await get(AppUrl.validate + code);
    if (response.statusCode == 201) {
      _validatedStatus = Status.Validated;
      notifyListeners();
      result = {'status': true, 'message': "User validated"};
    } else {
      _validatedStatus = Status.NotValidated;
      notifyListeners();
      result = {'status': false, 'message': "User validated"};
    }
    return result;
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
