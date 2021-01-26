import 'package:meet_your_mates/api/models/team.dart';

class TeamsList {
  String projectId;
  List<Team> teams = [];

  TeamsList({
    this.projectId,
    this.teams,
  });
  factory TeamsList.fromJson(Map<String, dynamic> json) => TeamsList(
        projectId: json["projectId"],
        teams: List<Team>.from(json["teams"].map((x) => Team.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "projectId": projectId,
        "teams": List<dynamic>.from(teams.map((x) => x.toJson())),
      };
}
