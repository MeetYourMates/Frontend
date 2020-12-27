import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart' as firebaseAuth;
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'package:meet_your_mates/api/models/student.dart';
import 'package:meet_your_mates/api/models/user.dart';
import 'package:meet_your_mates/api/models/userDetails.dart';
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
  Validated,
  Sending,
  Sent,
  Failed,
  Completed
}

class AuthProvider with ChangeNotifier {
  Status _loggedInStatus = Status.NotLoggedIn;
  Status _registeredInStatus = Status.NotRegistered;
  Status _validatedStatus = Status.NotValidated;
  Status _recoveryStatus = Status.Sending;
  Status get recoveryStatus => _recoveryStatus;
  Status get loggedInStatus => _loggedInStatus;
  Status get registeredInStatus => _registeredInStatus;
  Status get validatedStatus => _validatedStatus;
  bool signedInWithGoogle = false;

  var logger = Logger(level: Level.info);
  Future<Map<String, dynamic>> login(String email, String password) async {
    var result;
    int res = -1;
    _loggedInStatus = Status.Authenticating;
    notifyListeners();
    Student authenticatedStudent = new Student();
    Response response;
    try {
      User userTmp = new User(email: email, password: password);
      response = await post(
        AppUrl.login,
        body: json.encode(userTmp.toJson()),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (err) {
      //Cannot Even Send a request -->Probably No connection
      res = -1;
      return result = {'status': res, 'message': "Cannot make Request, connect to Internet!"};
    }
    //NEW WAY
    if (response.statusCode == 200) {
      //Logged In succesfully  from server
      try {
        Map responseData = jsonDecode(response.body);
        authenticatedStudent = Student.fromJson(responseData);
        authenticatedStudent.user.password = password;
        UserPreferences().saveUser(authenticatedStudent.user);
        logger.d("User in Shared Preferences: " + authenticatedStudent.user.toString());
        _loggedInStatus = Status.LoggedIn;
        notifyListeners();
        res = 0;
        result = {'status': res, 'message': _loggedInStatus, 'student': authenticatedStudent};
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
        authenticatedStudent.user.password = password;
        UserPreferences().saveUser(authenticatedStudent.user);
        logger.d("User in Shared Preferences: " + authenticatedStudent.user.toString());
        _loggedInStatus = Status.NotValidated;
        notifyListeners();
        res = 1;
        result = {'status': res, 'message': _loggedInStatus, 'student': authenticatedStudent};
      } catch (err) {
        res = -1;
        result = {'status': res, 'message': "Failed To Login!"};
      }
    } else if (response.statusCode == 206) {
      //Let's Get Started not completed
      try {
        Map responseData = jsonDecode(response.body);
        authenticatedStudent = Student.fromJson(responseData);
        authenticatedStudent.user.password = password;
        UserPreferences().saveUser(authenticatedStudent.user);
        logger.d("User in Shared Preferences: " + authenticatedStudent.user.toString());
        _loggedInStatus = Status.NotCompleted;
        notifyListeners();
        res = 2;
        result = {'status': res, 'message': _loggedInStatus, 'student': authenticatedStudent};
      } catch (err) {
        result = {'status': res, 'message': "Failed To Login!--> Error: " + err.toString()};
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

  Future<Map<String, dynamic>> recoverPassword(String email) async {
    var result;
    logger.d("Recover Passwor: email: $email");
    _recoveryStatus = Status.Sending;
    notifyListeners();
    Response response = await get(AppUrl.forgotPassword + email);
    logger.d("Recover Password: response: $response");
    if (response.statusCode == 201) {
      _recoveryStatus = Status.Sent;
      notifyListeners();
      logger.d("Recover Password: status: $_recoveryStatus");
      result = {'status': true, 'message': "Email Sent"};
    } else {
      _recoveryStatus = Status.Failed;
      notifyListeners();
      logger.d("Recover Password: status: $_recoveryStatus");
      result = {'status': false, 'message': "Unvalid Email"};
    }
    return result;
  }

  Future<Map<String, dynamic>> changePassword(String code, String email, String pass) async {
    var result;
    logger.d("change Password: email: $email");
    _recoveryStatus = Status.Sending;
    notifyListeners();
    String _body = '{"code":"$code","email":"$email","password":"$pass"}';
    logger.i("_body: " + _body);
    Response response = await post(
      AppUrl.changePassword,
      body: _body,
      headers: {'Content-Type': 'application/json'},
    );
    logger.d("change Password:: response: $response");
    if (response.statusCode == 200) {
      _recoveryStatus = Status.Completed;
      notifyListeners();
      logger.d("change Password:: status: $_recoveryStatus");
      result = {'status': true, 'message': "Email Sent"};
    } else {
      _recoveryStatus = Status.Failed;
      notifyListeners();
      logger.d("change Password:: status: $_recoveryStatus");
      result = {'status': false, 'message': "Unvalid Email"};
    }
    return result;
  }

  Future<Map<String, dynamic>> register(String email, String password) async {
    var result;

    final Map<String, dynamic> registerData = {'email': email, 'password': password};

    _registeredInStatus = Status.Registering;
    notifyListeners();
    try {
      Response response = await post(AppUrl.register,
          body: json.encode(registerData), headers: {'Content-Type': 'application/json'});

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
      result = {'status': true, 'message': 'Successfully registered', 'data': authenticatedStudent};
    } else {
      result = {'status': false, 'message': 'Registration failed', 'data': responseData};
    }

    return result;
  }

  static onError(error) {
    print("the error is $error.detail");
    return {'status': false, 'message': 'Unsuccessful Request', 'data': error};
  }

  final GoogleSignIn _googleSignIn = new GoogleSignIn();

  Future<UserDetails> signInGoogle() async {
    try {
      final firebaseAuth.FirebaseAuth _firebaseAuth = firebaseAuth.FirebaseAuth.instance;
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final firebaseAuth.AuthCredential credential = firebaseAuth.GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
      firebaseAuth.UserCredential userDetails =
          await _firebaseAuth.signInWithCredential(credential);
      print("UserEmail 305: " + userDetails.user.email);
      UserDetails details = new UserDetails(userDetails.user.uid, userDetails.user.displayName,
          userDetails.user.photoURL, userDetails.user.email);
      //Added New
      signedInWithGoogle = true;
      return details;
    } catch (err) {
      logger.e(err);
      return null;
    }
  }

  Future<dynamic> signOutGoogle() async {
    await _googleSignIn.signOut();
    return 0;
  }

  Future<Map<String, dynamic>> registerWithGoogle(Student registeredGoogle) async {
    var result;
    _registeredInStatus = Status.Registering;
    notifyListeners();
    Response response;

    try {
      response = await post(
        AppUrl.registerWithGoogle,
        body: json.encode(registeredGoogle.toJson()),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 201) {
        User newUser = new User(
            id: null, email: registeredGoogle.user.email, password: registeredGoogle.user.password);
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
}
