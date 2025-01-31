import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'package:meet_your_mates/api/models/courseAndStudents.dart';
import 'package:meet_your_mates/api/models/courseProjects.dart';
import 'package:meet_your_mates/api/models/professor.dart';
import 'package:meet_your_mates/api/models/project.dart';
import 'package:meet_your_mates/api/models/team.dart';
import 'package:meet_your_mates/api/models/teamsList.dart';
import 'package:meet_your_mates/api/models/user.dart';
import 'package:meet_your_mates/api/util/app_url.dart';
import 'package:meet_your_mates/api/util/shared_preference.dart';

class ProfessorProvider with ChangeNotifier {
  Professor _professor = new Professor();
  var logger = Logger(level: Level.debug);
  Professor get professor => _professor;

  /// ========================================================================
  ///!      SHOULD BE USED TO SET STUDENT EVERYWHERE IN THE PROGRAM
  ///========================================================================**/
  void setProfessor(Professor professor) {
    if (professor != null) {
      User usr = new User();
      usr = _professor.user;
      _professor = professor;
      _professor.user = usr;
      notifyListeners();
    }
  }

  /// ================================================================================================
  ///!          DON'T USE IT, SHOULD ONLY BE USED ON LOGIN AND PROFILE PASSWORD UPDATE!
  ///================================================================================================**/

  void setProfessorWithUserWithPassword(Professor professor) {
    _professor = professor;
    notifyListeners();
  }

  /// ================================================================================================
  ///!   SHOULD ONLY BE USED WHEN PROFILE OF USER CHANGED BUT NOT PASSWORD. TO SET PROFESSOR USE SetProfessor
  ///================================================================================================**/
  void setProfessorWithUser(Professor professor) {
    if (professor != null) {
      String pass;
      pass = _professor.user.password;
      _professor = professor;
      _professor.user.password = pass;
      notifyListeners();
    }
  }

  /// ======================
  ///    KRUNAL
  ///========================**/
  Future<List<CourseAndStudents>> getProfessorCourses(String id) async {
    logger.d("Trying to get student courses:");
    try {
      Response response = await get(
        AppUrl.getProfessorCoursesAndStudents + '/' + id,
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        logger.d("Courses retrieved:");
        //Convert from json List of Map to List of Student
        var decodedList = (json.decode(response.body) as List<dynamic>);
        List<CourseAndStudents> courses =
            decodedList.map((i) => CourseAndStudents.fromJson(i)).toList();
        //Send back List of Students
        return courses;
      }
      return null;
    } catch (err) {
      logger.e("Error getting student courses: " + err.toString());
      return null;
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
      ).timeout(Duration(seconds: 10));
      logger.d("AutoLogging Response:" + response.body);
      if (response.statusCode == 200) {
        //Logged In succesfully from server
        try {
          Map responseData = jsonDecode(response.body);
          _professor = (Professor.fromJson(responseData));
          _professor.user.password = password;
          logger.d("200 AutoLogging response body");
          logger.d(response.body.toString());
          logger.d("200 AutoLogging Professor");
          logger.d(_professor.toJson().toString());
          UserPreferences().saveUser(_professor.user);
          res = 3; //Dashboard Professor
        } catch (err) {
          logger.e("Error AutoLogin 200: " + err.toString());
          res = -1;
        }
      } else if (response.statusCode == 203) {
        //Not Validated
        try {
          Map responseData = jsonDecode(response.body);
          _professor.user = (User.fromJson(responseData));
          _professor.user.password = password;
          UserPreferences().saveUser(_professor.user);
          res = 1; //Same validation screen for both professor and Student
        } catch (err) {
          logger.e("Error AutoLogin 203: " + err.toString());
          res = -1;
        }
      } else if (response.statusCode == 206) {
        //Let's Get Started not completed for professor
        try {
          Map responseData = jsonDecode(response.body);
          _professor = (Professor.fromJson(responseData));
          _professor.user.password = password;
          UserPreferences().saveUser(_professor.user);
          res = 4;
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

  /// Create a team
  //Get reunions from Server
  Future<List<Team>> createTeams(List<Team> teams, String projectId) async {
    logger.d("Adding meeting!");
    List<Team> res = [];
    //String _team = jsonEncode(teams);
    TeamsList teamsList = new TeamsList(teams: teams, projectId: projectId);
    /* json.encode(team.toJson()) */
    try {
      Response response = await post(
        AppUrl.addTeam,
        body: json.encode(teamsList.toJson()),
        headers: {'Content-Type': 'application/json'},
      ).timeout(Duration(seconds: 10));
      logger.d("Team Response:" + response.body);
      if (response.statusCode == 201) {
        //Logged In succesfully  from server
        try {
          List<dynamic> responseData = jsonDecode(response.body);
          res = responseData != null
              ? List<Team>.from(responseData.map((x) => Team.fromJson(x)))
              : res;
          return res;
        } catch (err) {
          logger.e("Error creating Meeting 404: " + err.toString());
          return res;
        }
      } else {
        return res;
      }
    } catch (err) {
      logger.e("Error creating Meeting: " + err.toString());
      return res;
    }
  }

  //Get reunions from Server
  Future<List<Team>> getTeams(String projectId) async {
    logger.d("Getting ReunionsData!");
    List<Team> res = [];
    try {
      Response response = await get(
        AppUrl.getTeams + projectId,
        headers: {'Content-Type': 'application/json'},
      ).timeout(Duration(seconds: 10));
      logger.d("Meeting Response:" + response.body);
      if (response.statusCode == 200) {
        //Logged In succesfully  from server
        try {
          List<dynamic> responseData = jsonDecode(response.body);
          res = responseData != null
              ? List<Team>.from(responseData.map((x) => Team.fromJson(x)))
              : [];
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

  //************************PEP****************************/
  /// ================================================================================================
  ///!                UPDATE TEAM INFO
  ///
  ///================================================================================================**/
  Future<int> updateTeam(Team team) async {
    logger.d("Trying to add new project:");
    try {
      Response response = await put(
        AppUrl.updateTeam,
        body: json.encode(team.toJson()),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 201) {
        logger.d("Team updated");
        return 0;
      } else
        return -2;
    } catch (err) {
      logger.e("Error updating team: " + err.toString());
      return -1;
    }
  }

  ///*******************************************************/

  /// ================================================================================================
  ///!                                  Upload professor parameters
  ///================================================================================================**/

  Future<int> upload(Professor updated) async {
    int res = -1;
    logger.d("Trying to update student:");
    try {
      Response response = await put(
        AppUrl.editProfileProfessor,
        body: json.encode(updated.toJson()),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        logger.d("Professor updated:");
        notifyListeners();
        res = 0;
      }
    } catch (err) {
      logger.e("Error updating Professor: " + err.toString());
      res = -1;
    }
    return res;
  }

//*******************************************************/
//***********************************KRUNAL***********************************************************/

//************************PEP****************************/
  /// ================================================================================================
  ///!                GET MY COURSES AND THEIR PROJECTS WITH MY PROFESSOR ID
  ///                                  USED BY projectList (professor)
  ///================================================================================================**/
  Future<List<CourseProjects>> getCourseProjects(String id) async {
    logger.d("Trying to get professor projects:");
    try {
      Response response = await get(
        AppUrl.getCourseProjectsProfessor + '/' + id,
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        logger.d("Projects retrieved:");
        //Convert from json List of Map to List of courseProjects
        var decodedList = (json.decode(response.body) as List<dynamic>);
        List<CourseProjects> courses =
            decodedList.map((i) => CourseProjects.fromJson(i)).toList();
        //Send back List of Courses and Projects
        return courses;
      }
      return null;
    } catch (err) {
      logger.e("Error getting projects courses: " + err.toString());
      return null;
    }
  }

//*******************************************************/

//************************PEP****************************/
  /// ================================================================================================
  ///!                ADD NEW PROJECT TO TO THE SUBJECT
  ///
  ///================================================================================================**/
  Future<int> addProject(Project project, String _id) async {
    logger.d("Trying to add new project:");
    try {
      var req = project.toJson();
      req["id"] = _id;
      Response response = await post(
        AppUrl.addProject,
        body: json.encode(req),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 201) {
        logger.d("Project added");
        return 0;
      } else
        return -2;
    } catch (err) {
      logger.e("Error adding new project: " + err.toString());
      return -1;
    }
  }

  ///*******************************************************/
}
