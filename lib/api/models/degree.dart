import 'package:meet_your_mates/api/models/subject.dart';

class Degree {
  String id;
  String name;
  Degree({
    this.id,
    this.name,
  });

  factory Degree.fromJson(Map<String, dynamic> json) =>
      Degree(id: json["_id"], name: json["name"]);

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
      };
}
