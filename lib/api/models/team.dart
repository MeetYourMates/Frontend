import 'package:meet_your_mates/api/models/meeting.dart';
import 'package:meet_your_mates/api/models/task.dart';

class Team {
  String id;
  String name;
  num availability;
  List<Task> tasks;
  List<Meeting> meetings;

  Team({this.id, this.name, this.meetings, this.availability, this.tasks});
  factory Team.fromJson(Map<String, dynamic> responseData) {
    return Team(
        id: responseData['_id'],
        name: responseData['name'],
        meetings: responseData["meetings"] != null ? List<Meeting>.from(responseData["meetings"].map((x) => Meeting.fromJson(x))) : [],
        availability: responseData['availability'],
        tasks: responseData["tasks"] != null ? List<Task>.from(responseData["tasks"].map((x) => Task.fromJson(x))) : []);
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.id;
    data['name'] = this.name;
    data['meetings'] = List<dynamic>.from(meetings.map((x) => x.toJson()));
    data['availability'] = this.availability;
    data['tasks'] = List<dynamic>.from(tasks.map((x) => x.toJson()));
    return data;
  }
}
