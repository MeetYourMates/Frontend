import 'package:meet_your_mates/api/models/project.dart';

class CourseProjects {
  String id;
  String subjectName;
  List<Project> projects = <Project>[];

  CourseProjects({this.id, this.subjectName, this.projects});

  List<String> getProjectNames() {
    List<String> projectNames = [];
    if (projects != null) {
      if (projects.isNotEmpty) {
        projects.forEach((project) {
          projectNames.add(project.name);
        });
      }
    }
    return projectNames;
  }

  List<String> getSubjectNames() {
    List<String> subjectNames = [];
    if (projects != null) {
      if (projects.isNotEmpty) {
        projects.forEach((project) {
          subjectNames.add(subjectName);
        });
      }
    }
    return subjectNames;
  }

  factory CourseProjects.fromJson(Map<String, dynamic> json) => CourseProjects(
      id: json["_id"],
      subjectName: json["subjectName"],
      projects:
          List<Project>.from(json["projects"].map((x) => Project.fromJson(x))));

  Map<String, dynamic> toJson() => {
        "_id": id,
        "subjectName": subjectName,
        "projects": List<dynamic>.from(projects.map((x) => x.toJson()))
      };
}
