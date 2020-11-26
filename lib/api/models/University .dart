// To parse this JSON data, do
//
//     final university = universityFromJson(jsonString);

import 'dart:convert';

University universityFromJson(String str) =>
    University.fromJson(json.decode(str));

String universityToJson(University data) => json.encode(data.toJson());

class University {
  University({
    this.name,
    this.faculties,
  });

  String name;
  List<Faculty> faculties;

  factory University.fromJson(Map<String, dynamic> json) => University(
        name: json["name"],
        faculties: List<Faculty>.from(
            json["faculties"].map((x) => Faculty.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "faculties": List<dynamic>.from(faculties.map((x) => x.toJson())),
      };
}

class Faculty {
  Faculty({
    this.faculty,
    this.degrees,
  });

  String faculty;
  List<Degree> degrees;

  factory Faculty.fromJson(Map<String, dynamic> json) => Faculty(
        faculty: json["faculty"],
        degrees:
            List<Degree>.from(json["degrees"].map((x) => Degree.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "faculty": faculty,
        "degrees": List<dynamic>.from(degrees.map((x) => x.toJson())),
      };
}

class Degree {
  Degree({
    this.name,
    this.subjects,
  });

  String name;
  List<Subject> subjects;

  factory Degree.fromJson(Map<String, dynamic> json) => Degree(
        name: json["name"],
        subjects: List<Subject>.from(
            json["subjects"].map((x) => Subject.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "subjects": List<dynamic>.from(subjects.map((x) => x.toJson())),
      };
}

class Subject {
  Subject({
    this.name,
  });

  String name;

  factory Subject.fromJson(Map<String, dynamic> json) => Subject(
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
      };
}
