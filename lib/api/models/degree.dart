import 'package:meet_your_mates/api/models/subject.dart';

class Degree {
  String id;
  String name;
  List<Subject> subjects;

  Degree({
    this.id,
    this.name,
    this.subjects,
  });

  factory Degree.fromJson(Map<String, dynamic> json) => Degree(
        id: json["_id"],
        name: json["name"],
        subjects: List<Subject>.from(
            json["subjects"].map((x) => Subject.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "subjects": List<dynamic>.from(subjects.map((x) => x.toJson())),
      };
}
