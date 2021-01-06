class Project {
  String id;
  String name;
  List<String> teamNames;
  num numberStudents;

  Project({this.id, this.name, this.teamNames, this.numberStudents});

  factory Project.fromJson(Map<String, dynamic> json) => Project(
      id: json["_id"],
      name: json["name"],
      teamNames: json['teanNames'],
      numberStudents: json['numberStudents']);

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "teamNames": teamNames,
        "numberStudents": numberStudents
      };
}
