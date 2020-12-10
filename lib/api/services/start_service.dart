import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'package:meet_your_mates/api/models/degreeWithList.dart';
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
  var logger = Logger(level: Level.warning);
  //*******************************KRUNAL**************************************/
  Future<Map<String, dynamic>> getStartedData(String token) async {
    var result;
    Response response;
    _enrolledStatus = Status.LoadingData;
    try {
      response = await get(
        AppUrl.universities,
        headers: {
          'authorization': 'bearer $token',
          'Content-Type': 'application/json'
        },
      );
    } catch (err) {
      _enrolledStatus = Status.DataFailed;
      result = {'status': false, 'message': "Couldn't Make the Request"};
      return result;
    }
    try {
      if (response.statusCode == 200) {
        logger.d("Response Unis:" + response.body);
        List<University> universities = (json.decode(response.body) as List)
            .map((i) => University.fromJson(i))
            .toList();

        // UserPreferences().saveUser(authUser.user);

        _enrolledStatus = Status.DataLoaded;

        result = {
          'status': true,
          'message': 'Successful',
          'universities': universities
        };
      } else {
        _enrolledStatus = Status.DataFailed;
        result = {
          'status': false,
          'message': json.decode(response.body)['error']
        };
      }
    } catch (err) {
      _enrolledStatus = Status.DataFailed;
      result = {
        'status': false,
        'message': "Failed Converting Universities From JSON!"
      };
      return result;
    }
    return result;
  }

//*******************************KRUNAL**************************************/
  Future<Map<String, dynamic>> getSubjectData(String degreeId) async {
    var result;
    Response response;
    _enrolledStatus = Status.LoadingData;
    notifyListeners();
    try {
      response = await get(
        AppUrl.subjects + degreeId,
        headers: {'Content-Type': 'application/json'},
      );
    } catch (err) {
      _enrolledStatus = Status.DataFailed;
      notifyListeners();
      result = {'status': false, 'message': "Couldn't Make the Request"};
      return result;
    }
    try {
      if (response.statusCode == 200) {
        //Error Cannot Decode
        logger.d("Recieved Response Subj Json: " + (response.body));
        //logger.d("Recieved Response Subj: " + jsonDecode(response.body));
        Map responseData = jsonDecode(response.body);
        DegreeWithList degree = DegreeWithList.fromJson(responseData);
        List<Map<String, dynamic>> subjs = new List<Map<String, dynamic>>();
        _enrolledStatus = Status.DataLoaded;
        notifyListeners();
        //We have to convert to json {"id":"objId","name":"nameSubs"}
        //subjects = degree.getSubjects(); //Need to Implement This!!
        degree.subjects.forEach((val) =>
            subjs.add({"id": val.id, "name": val.name, "group": "Subjects"}));
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
    } catch (err) {
      _enrolledStatus = Status.DataFailed;
      notifyListeners();
      result = {
        'status': false,
        'message': "Failed Converting Subjects List From JSON"
      };
      return result;
    }
    return result;
  }

  Future<Map<String, dynamic>> start(String subjectId, String studentId) async {
    var result;
    Response response;
    _enrolledStatus = Status.GettingEnrolled;
    notifyListeners();

    String json =
        '{"subjectId":"' + subjectId + '","studentId":"' + studentId + '"}';
    try {
      response = await post(AppUrl.addsubjects,
          body: json, headers: {'Content-Type': 'application/json'});
    } catch (err) {
      _enrolledStatus = Status.EnrollFailed;
      notifyListeners();
      result = {'status': false, 'message': "Couldn't make the request"};
      return result;
    }
    try {
      if (response.statusCode == 201) {
        _enrolledStatus = Status.Enrolled;
        notifyListeners();
        result = {'status': true, 'message': 'Successful'};
      } else {
        if (response.statusCode == 409) {
          _enrolledStatus = Status.AlreadyEnrolled;
          notifyListeners();
          result = {
            'status': false,
            'message': "You were already enrolled in "
          };
        } else {
          _enrolledStatus = Status.EnrollFailed;
          notifyListeners();
          result = {
            'status': false,
            'message': "Failed to get you enrolled in "
          };
        }
      }
    } catch (err) {
      _enrolledStatus = Status.EnrollFailed;
      notifyListeners();
      result = {
        'status': false,
        'message': "Failed Converting Subjects List From JSON"
      };
      return result;
    }
    return result;
  }
}
