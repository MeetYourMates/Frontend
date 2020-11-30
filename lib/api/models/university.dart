import 'dart:convert';
import 'package:meet_your_mates/api/models/faculty.dart';

String universityToJson(University data) => json.encode(data.toJson());

class University {
  String id;
  String name;
  List<Faculty> faculties;

  University({
    this.id,
    this.name,
    this.faculties,
  });

  List<String> getFacultyNames() {
    List<String> facultyNames = [];
    faculties.forEach((fac) {
      facultyNames.add(fac.name);
    });
    return facultyNames;
  }

  Faculty getFacultyByName(String name) {
    int index = getFacultyNames().indexOf(name);
    return faculties[index];
  }

  factory University.fromJson(Map<String, dynamic> json) => University(
        id: json["_id"],
        name: json["name"],
        faculties: List<Faculty>.from(
            json["faculties"].map((x) => Faculty.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "faculties": List<dynamic>.from(faculties.map((x) => x.toJson())),
      };
}
