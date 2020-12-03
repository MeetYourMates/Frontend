import 'dart:convert';
import 'package:meet_your_mates/api/models/university.dart';

String universitiesToJson(Universities data) => json.encode(data.toJson());

class Universities {
  List<University> universityList = new List<University>();

  Universities({this.universityList});

  List<String> getUniversityNames() {
    List<String> universityNames = [];
    universityList.forEach((uni) {
      universityNames.add(uni.name);
    });
    return universityNames;
  }

  University getUniversityByName(String name) {
    int index = getUniversityNames().indexOf(name);
    return universityList[index];
  }

  factory Universities.fromJson(Map<String, dynamic> json) => Universities(
        universityList: List<University>.from(
            json["universityList"].map((x) => University.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "universityList":
            List<dynamic>.from(universityList.map((x) => x.toJson())),
      };
}
