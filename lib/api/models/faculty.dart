import 'package:meet_your_mates/api/models/degree.dart';

class Faculty {
  String id;
  String name;
  List<Degree> degrees;

  Faculty({
    this.id,
    this.name,
    this.degrees,
  });

  List<String> getDegreeNames() {
    List<String> degreeNames;
    degrees.forEach((deg) {
      degreeNames.add(deg.name);
    });
    return degreeNames;
  }

  Degree getDegreeByName(String name) {
    int index = getDegreeNames().indexOf(name);
    return degrees[index];
  }

  factory Faculty.fromJson(Map<String, dynamic> json) => Faculty(
        id: json["_id"],
        name: json["name"],
        degrees:
            List<Degree>.from(json["degrees"].map((x) => Degree.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "degrees": List<dynamic>.from(degrees.map((x) => x.toJson())),
      };
}
