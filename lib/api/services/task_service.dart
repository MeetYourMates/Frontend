import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:meet_your_mates/api/models/takslist.dart';
import 'package:meet_your_mates/api/models/task.dart';
import 'package:logger/logger.dart';
import 'package:meet_your_mates/api/util/app_url.dart';

class TaskProvider with ChangeNotifier {
  var logger = Logger(level: Level.error);
  Task _task = new Task();
  Task get task => _task;

  void setTask(Task task) {
    _task = task;
    notifyListeners();
  }

  Future<TaskList> getTasks(String teamId) async {
    logger.d("Trying to get tasks:");
    try {
      Response response = await get(
        AppUrl.getTasks + teamId,
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        notifyListeners();
        logger.d("Tasks retrieved:");
        Map responseData = jsonDecode(response.body);
        //Convert from json List of Map to List
        TaskList tasks = TaskList.fromJson(responseData);
        //Send back List of Projects
        return tasks;
      }
      return new TaskList(tasks: []);
    } catch (err) {
      logger.e("Error getting projects: " + err.toString());
      return null;
    }
  }

  //Add Task
  Future<Map<String, dynamic>> createTask(
      String name, String description, String date, String teamId) async {
    logger.d("Adding meeting!");
    var result;
    Response response;
    String json = '{"teamId":"' +
        teamId +
        '","name":"' +
        name +
        '","description":"' +
        description +
        '","deadline":"' +
        date +
        '"}';
    try {
      response = await post(
        AppUrl.addTask,
        body: json,
        headers: {'Content-Type': 'application/json'},
      ).timeout(Duration(seconds: 10));
      if (response.statusCode == 201) {
        notifyListeners();
        //Logged In succesfully  from server
        logger.d("Task Added");
        result = {
          'status': true,
          'message': 'Successful',
        };
      } else {
        notifyListeners();
        result = {'status': false, 'message': "Failed to add task"};
      }
      return result;
    } catch (err) {
      logger.e("Error adding task: " + err.toString());
      notifyListeners();
      result = {'status': false, 'message': "Failed"};
      return result;
    }
  }

  Future<Map<String, dynamic>> completeTask(bool comp, String taskId) async {
    logger.d("Adding meeting!");
    var result;
    String json =
        '{ "taskId" :' + taskId + ',"complete" : ' + comp.toString() + '}';
    try {
      Response response = await post(
        AppUrl.addTask,
        body: json,
        headers: {'Content-Type': 'application/json'},
      ).timeout(Duration(seconds: 10));
      if (response.statusCode == 201) {
        notifyListeners();
        //Logged In succesfully  from server
        result = {
          'status': true,
          'message': 'Successful',
        };
        logger.d("Task Complete");
        return result;
      } else {
        notifyListeners();
        result = {'status': false, 'message': "Failed to complete task"};
      }
      return result;
    } catch (err) {
      logger.e("Error completing task: " + err.toString());
      notifyListeners();
      result = {'status': false, 'message': "Failed"};
      return result;
    }
  }
}
