import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'package:meet_your_mates/api/models/courseProjects.dart';
import 'package:meet_your_mates/api/models/student.dart';
import 'package:meet_your_mates/api/util/app_url.dart';


class MateProvider with ChangeNotifier {
  Student _student = new Student();

  Student get student => _student;

  void setStudent(Student student) {
    _student = student;
    notifyListeners();
  }
  var logger = Logger(level: Level.error);
  
  Future<List<CourseProjects>> getProjects(String id) async {
    logger.d("Trying to get course students:");
    try {
      Response response = await get(
        AppUrl.getProjects + id,
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        logger.d("Projects retrieved:");
        //Convert from json List of Map to List
        var decodedList = (json.decode(response.body) as List<dynamic>);
        List<CourseProjects> projects =
            decodedList.map((i) => CourseProjects.fromJson(i)).toList();
        //Send back List of Projects
        return projects;
      }
      return null;
    } catch (err) {
      logger.e("Error getting projects: " + err.toString());
      return null;
    }
  }
}
