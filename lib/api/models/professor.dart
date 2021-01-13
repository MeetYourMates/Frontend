import 'package:meet_your_mates/api/models/user.dart';

class Professor {
  String id;
  String university;
  String degree;
  User user = new User();
  Professor({this.id, this.university, this.degree, this.user});

  factory Professor.fromJson(Map<String, dynamic> responseData) {
    //Check all of the lists if not null than assign  temp var to hold the maps
    return new Professor(
      id: responseData['_id'],
      university: responseData['university'],
      degree: responseData['degree'],
      user: User.fromJson(responseData['user']),
    );

    //trophies: (responseData['trophies']),
    //insignias: (responseData['insignias']));
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.id;
    data['university'] = this.university;
    data['degree'] = this.degree;
    data['user'] = this.user;
    return data;
  }
}
