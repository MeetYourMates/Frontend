import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:meet_your_mates/api/models/degree.dart';
import 'package:meet_your_mates/api/models/student.dart';
import 'package:meet_your_mates/api/models/subject.dart';
import 'package:meet_your_mates/api/models/university.dart';
import 'package:meet_your_mates/api/util/app_url.dart';

enum Status {
  Enrolled,
  NotEnrolled,
  GettingEnrolled,
  AlreadyEnrolled,
  EnrollFailed,
  LoadingData,
  DataLoaded,
  DataFailed
}

class StartProvider with ChangeNotifier {
  Status _enrolledStatus = Status.NotEnrolled;
  Status get enrolledStatus => _enrolledStatus;

  //Login Service without proper error handling T
  Future<Map<String, dynamic>> getStartedData() async {
    var result;

    _enrolledStatus = Status.LoadingData;
    notifyListeners();

    Response response = await get(
      AppUrl.universities,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      print("Response Unis:" + response.body);
      List<University> universities = (json.decode(response.body) as List)
          .map((i) => University.fromJson(i))
          .toList();

      // UserPreferences().saveUser(authUser.user);

      _enrolledStatus = Status.DataLoaded;
      notifyListeners();

      result = {
        'status': true,
        'message': 'Successful',
        'universities': universities
      };
    } else {
      _enrolledStatus = Status.DataFailed;
      notifyListeners();
      result = {
        'status': false,
        'message': json.decode(response.body)['error']
      };
    }
    return result;
  }

  Future<Map<String, dynamic>> getSubjectData(String degreeId) async {
    var result;

    _enrolledStatus = Status.LoadingData;
    notifyListeners();

    Response response = await get(
      AppUrl.subjects + degreeId,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      Map responseData = jsonDecode(response.body);
      Degree degree = Degree.fromJson(responseData);
      List<Subject> subjects = new List<Subject>();
      List<String> subjs = new List<String>();
      _enrolledStatus = Status.DataLoaded;
      notifyListeners();
      //We have to convert to json {"id":"objId","name":"nameSubs"}
      //subjects = degree.getSubjects(); //Need to Implement This!!
      subjects.forEach((val) => subjs.add('"id":$val.id,"name":$val.name'));
      //Now from Subjects list create a list of String with above format
      result = {'status': true, 'message': 'Successful', 'subjects': subjs};
    } else {
      _enrolledStatus = Status.DataFailed;
      notifyListeners();
      result = {
        'status': false,
        'message': json.decode(response.body)['error']
      };
    }
    return result;
  }

  Future<Map<String, dynamic>> start(
      String subjectName, String subjectId, Student student) async {
    var result;
    _enrolledStatus = Status.GettingEnrolled;
    notifyListeners();

    String json =
        '{"subjectId":"' + subjectId + '","studentId":"' + student.id + '"}';

    Response response = await post(AppUrl.addsubjects,
        body: json, headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      _enrolledStatus = Status.Enrolled;
      notifyListeners();
      result = {'status': true, 'message': 'Successful'};
    } else {
      if (response.statusCode == 409) {
        _enrolledStatus = Status.AlreadyEnrolled;
        notifyListeners();
        result = {
          'status': false,
          'message': "You were already enrolled in " + subjectName
        };
      } else {
        _enrolledStatus = Status.EnrollFailed;
        notifyListeners();
        result = {
          'status': false,
          'message': "Failed to get you enrolled in " + subjectName
        };
      }
    }

    return result;
  }
}
