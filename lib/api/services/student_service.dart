import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'package:meet_your_mates/api/models/courseAndStudents.dart';
import 'package:meet_your_mates/api/models/courseProjects.dart';
import 'package:meet_your_mates/api/models/invitation.dart';
import 'package:meet_your_mates/api/models/meeting.dart';
import 'package:meet_your_mates/api/models/student.dart';
import 'package:meet_your_mates/api/models/team.dart';
import 'package:meet_your_mates/api/models/user.dart';
import 'package:meet_your_mates/api/util/app_url.dart';
import 'package:meet_your_mates/api/util/shared_preference.dart';

class StudentProvider with ChangeNotifier {
  Student _student = new Student();
  Student get student => _student;
  var logger = Logger(level: Level.error);

  /// ========================================================================
  ///!      SHOULD BE USED TO SET STUDENT EVERYWHERE IN THE PROGRAM
  ///========================================================================**/
  void setStudent(Student student) {
    if (student != null) {
      User usr = new User();
      usr = _student.user;
      _student = student;
      _student.user = usr;
      notifyListeners();
    }
  }

  /// ================================================================================================
  ///!   SHOULD ONLY BE USED WHEN PROFILE OF USER CHANGED BUT NOT PASSWORD. TO SET STUDENT USE SetStudent
  ///================================================================================================**/
  void setStudentWithUser(Student student) {
    if (student != null) {
      String pass;
      pass = _student.user.password;
      _student = student;
      _student.user.password = pass;
      notifyListeners();
    }
  }

  /// ================================================================================================
  ///!          DON'T USE IT, SHOULD ONLY BE USED ON LOGIN AND PROFILE PASSWORD UPDATE!
  ///================================================================================================**/

  void setStudentWithUserWithPassword(Student student) {
    _student = student;
    notifyListeners();
  }

  /// ================================================================================================
  ///!                                  Auto login Future
  ///================================================================================================**/
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
      ).timeout(Duration(seconds: 10));
      logger.d("AutoLogging Response:" + response.body);
      if (response.statusCode == 200) {
        //Logged In succesfully  from server
        try {
          Map responseData = jsonDecode(response.body);
          _student = (Student.fromJson(responseData));
          _student.user.password = password;
          logger.d("200 AutoLogging response body");
          logger.d(response.body.toString());
          logger.d("200 AutoLogging Student");
          logger.d(_student.toJson().toString());
          UserPreferences().saveUser(_student.user);
          res = 0;
        } catch (err) {
          logger.e("Error AutoLogin 200: " + err.toString());
          res = -1;
        }
      } else if (response.statusCode == 203) {
        //Not Validated
        try {
          Map responseData = jsonDecode(response.body);
          User userTmp2 = new User();
          userTmp2 = (User.fromJson(responseData));
          userTmp2.password = password;
          UserPreferences().saveUser(userTmp2);
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
          _student.user.password = password;
          UserPreferences().saveUser(_student.user);
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

  //Get reunions from Server
  Future<List<Meeting>> getMeetings(String teamId) async {
    logger.d("Getting ReunionsData!");
    List<Meeting> res = [];
    try {
      Response response = await get(
        AppUrl.getMeeting + teamId,
        headers: {'Content-Type': 'application/json'},
      ).timeout(Duration(seconds: 10));
      logger.d("Meeting Response:" + response.body);
      if (response.statusCode == 200) {
        //Logged In succesfully  from server
        try {
          Map responseData = jsonDecode(response.body);
          Team team = (Team.fromJson(responseData));
          res = team.meetings;
          return res;
        } catch (err) {
          logger.e("Error Meeting 404: " + err.toString());
          return res;
        }
      } else {
        return res;
      }
    } catch (err) {
      logger.e("Error Meeting: " + err.toString());
      return res;
    }
  }

  //Get reunions from Server
  Future<Meeting> createMeeting(Meeting meeting) async {
    logger.d("Adding meeting!");
    String meet = json.encode(meeting.toJson());
    try {
      Response response = await post(
        AppUrl.addMeeting,
        body: meet,
        headers: {'Content-Type': 'application/json'},
      ).timeout(Duration(seconds: 10));
      logger.d("Meeting Response:" + response.body);
      if (response.statusCode == 201) {
        //Logged In succesfully  from server
        try {
          Map responseData = jsonDecode(response.body);
          Meeting resMeeting = (Meeting.fromJson(responseData));
          return resMeeting;
        } catch (err) {
          logger.e("Error creating Meeting 404: " + err.toString());
          return meeting;
        }
      } else {
        return meeting;
      }
    } catch (err) {
      logger.e("Error creating Meeting: " + err.toString());
      return meeting;
    }
  }
  //*********************************************************************/

  //************************POL****************************/
  /// ================================================================================================
  ///!                                  Uload student parameters
  ///================================================================================================**/

  Future<int> upload(Student updated) async {
    int res = -1;
    logger.d("Trying to update student:");
    try {
      Response response = await put(
        AppUrl.editProfileStudent,
        body: json.encode(updated.toJson()),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        logger.d("Student updated:");
        notifyListeners();
        res = 0;
      }
    } catch (err) {
      logger.e("Error updating Student: " + err.toString());
      res = -1;
    }
    return res;
  }

//*******************************************************/
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
        List<CourseProjects> projects = decodedList.map((i) => CourseProjects.fromJson(i)).toList();
        //Send back List of Projects
        return projects;
      }
      return null;
    } catch (err) {
      logger.e("Error getting projects: " + err.toString());
      return null;
    }
  }

//************************PEP****************************/
  /// ================================================================================================
  ///!                    THIS FUNCTION IS DEPRECATED, KEEP JUST IN CASE
  ///================================================================================================**/
  Future<List<Student>> getCourseStudents() async {
    logger.d("Trying to get course students:");
    try {
      Response response = await get(
        AppUrl.getCourseStudents + '/464951543030303032303230', //HABRÁ QUE PASAR EL ID COMO PARÁMETRO
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        logger.d("Student retrieved:");
        //Convert from json List of Map to List of Student
        var decodedList = (json.decode(response.body) as List<dynamic>);
        List<Student> students = decodedList.map((i) => Student.fromJson(i)).toList();
        //Send back List of Students
        return students;
      }
      return null;
    } catch (err) {
      logger.e("Error getting student: " + err.toString());
      return null;
    }
  }
//*******************************************************/

//************************PEP****************************/
  /// ================================================================================================
  ///!                    GET MY COURSES AND STUDENTS WITH MY STUDENT ID
  ///                                  USED BY courseList
  ///================================================================================================**/
  Future<List<CourseAndStudents>> getStudentCourses(String id) async {
    logger.d("Trying to get student courses:");
    try {
      Response response = await get(
        AppUrl.getStudentsAndCourses + '/' + id,
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        logger.d("Courses retrieved:");
        //Convert from json List of Map to List of Student
        var decodedList = (json.decode(response.body) as List<dynamic>);
        List<CourseAndStudents> courses = decodedList.map((i) => CourseAndStudents.fromJson(i)).toList();
        //Send back List of Students
        return courses;
      }
      return null;
    } catch (err) {
      logger.e("Error getting student courses: " + err.toString());
      return null;
    }
  }

  Future<List<Invitation>> getInvitations(String userId) async {
    try {
      Response response = await get(
        AppUrl.getInvitations + userId,
      );
      if (response.statusCode == 200) {
        logger.d("Courses retrieved:");
        //Convert from json List of Map to List of Student
        var decodedList = (json.decode(response.body) as List<dynamic>);
        List<Invitation> inv = decodedList.map((i) => Invitation.fromJson(i)).toList();
        int c = 1;
        return inv;
      }
    }
    catch (err) {
      logger.e("Error getting invitations: " + err.toString());
      return null;
    }
  }
  Future<void> AcceptOrRejectInv(Invitation inv, String action) async {
    try {
      Response response = await get(
        AppUrl.acceptOrRejectInv + inv.invId + "/" + action
      );
      if (response.statusCode == 200) {
        logger.d(action + "invitation");
        //Convert from json List of Map to List of Student
      }
    }
    catch (err) {
      logger.e("Error getting invitations: " + err.toString());
      return null;
    }

  }
}
