import 'package:meet_your_mates/api/models/meeting.dart';
import 'package:meet_your_mates/api/models/task.dart';

class Team {
  String id;
  String name;
  num numberStudents;
  List<Task> tasks;
  List<Meeting> meetings;

  Team({this.id, this.name, this.meetings, this.numberStudents, this.tasks});
  factory Team.fromJson(Map<String, dynamic> responseData) {
    return Team(
        id: responseData['_id'],
        name: responseData['name'],
        meetings: responseData["meetings"] != null ? List<Meeting>.from(responseData["meetings"].map((x) => Meeting.fromJson(x))) : [],
        numberStudents: responseData['numberStudents'],
        tasks: responseData["tasks"] != null ? List<Task>.from(responseData["tasks"].map((x) => Task.fromJson(x))) : []);
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.id;
    data['name'] = this.name;
    if (meetings != null) {
      data['meetings'] = List<dynamic>.from(meetings.map((x) => x.toJson()));
    }
    data['numberStudents'] = this.numberStudents;
    if (tasks != null) {
      data['tasks'] = List<dynamic>.from(tasks.map((x) => x.toJson()));
    }
    return data;
  }
}
