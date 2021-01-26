import 'package:meet_your_mates/api/models/task.dart';

class TaskList {
  List<Task> tasks = <Task>[];

  TaskList({this.tasks});

  List<String> getTaskNames() {
    List<String> taskNames = [];
    if (tasks != null) {
      if (tasks.isNotEmpty) {
        tasks.forEach((task) {
          taskNames.add(task.name);
        });
      }
    }
    return taskNames;
  }

  List<String> getTaskDates() {
    List<String> taskDates = [];
    if (tasks != null) {
      if (tasks.isNotEmpty) {
        tasks.forEach((task) {
          taskDates.add(task.deadline.toString());
        });
      }
    }
    return taskDates;
  }

  factory TaskList.fromJson(Map<String, dynamic> json) {
    List<Task> tmp1 = json["tasks"] != null ? List<Task>.from(json["tasks"].map((x) => Task.fromJson(x))) : [];

    return TaskList(tasks: tmp1);
  }

  Map<String, dynamic> toJson() => {"tasks": List<dynamic>.from(tasks.map((x) => x.toJson()))};
}
