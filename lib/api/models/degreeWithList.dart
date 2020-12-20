import 'package:meet_your_mates/api/models/subject.dart';

class DegreeWithList {
  String id;
  String name;
  List<Subject> subjects = <Subject>[];
  DegreeWithList({this.id, this.name, this.subjects});

  factory DegreeWithList.fromJson(Map<String, dynamic> json) => DegreeWithList(
      id: json["_id"],
      name: json["name"],
      subjects:
          List<Subject>.from(json["subjects"].map((x) => Subject.fromJson(x))));

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "subjects": List<dynamic>.from(subjects.map((x) => x.toJson()))
      };
}
