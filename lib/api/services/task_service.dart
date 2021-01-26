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
        logger.d("Tasks retrieved:");
        Map responseData = jsonDecode(response.body);
        //Convert from json List of Map to List
        TaskList tasks = TaskList.fromJson(responseData);
        //Send back List of Projects
        return tasks;
      }
      return null;
    } catch (err) {
      logger.e("Error getting projects: " + err.toString());
      return null;
    }
  }

  //Add Task
  Future createTask(Task task) async {
    logger.d("Adding meeting!");
    String taskCreate = json.encode(task.toJson());
    try {
      Response response = await post(
        AppUrl.addTask,
        body: taskCreate,
        headers: {'Content-Type': 'application/json'},
      ).timeout(Duration(seconds: 10));
      if (response.statusCode == 201) {
        //Logged In succesfully  from server
        logger.d("Task Added");
      }
    } catch (err) {
      logger.e("Error adding task: " + err.toString());
    }
  }

  Future completeTask(bool comp, String taskId) async {
    logger.d("Adding meeting!");
    String json =
        '{ "taskId" :' + taskId + ',"complete" : ' + comp.toString() + '}';
    try {
      Response response = await post(
        AppUrl.addTask,
        body: json,
        headers: {'Content-Type': 'application/json'},
      ).timeout(Duration(seconds: 10));
      if (response.statusCode == 201) {
        //Logged In succesfully  from server
        logger.d("Task Complete");
      }
    } catch (err) {
      logger.e("Error completing task: " + err.toString());
    }
  }
}
