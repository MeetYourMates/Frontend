import 'package:meet_your_mates/api/models/insignia.dart';
import 'package:meet_your_mates/api/models/rating.dart';
import 'package:meet_your_mates/api/models/trophy.dart';
import 'package:meet_your_mates/api/models/user.dart';

class Student {
  String id;
  String university;
  String degree;
  List<Trophy> trophies;
  List<Insignia> insignias;
  User user = new User();
  List<Rating> ratings;

  Student(
      {this.id,
      this.university,
      this.degree,
      this.user,
      this.insignias,
      this.trophies,
      this.ratings});

  factory Student.fromJson(Map<String, dynamic> responseData) {
    return new Student(
        id: responseData['_id'],
        university: responseData['university'],
        degree: responseData['degree'],
        user: User.fromJson(responseData['user']),
        ratings: List<Rating>.from(
            responseData["ratings"].map((x) => Rating.fromJson(x))),
        trophies: List<Trophy>.from(
            responseData["trophies"].map((x) => Trophy.fromJson(x))),
        insignias: List<Insignia>.from(
            responseData["insignias"].map((x) => Insignia.fromJson(x))));

    //trophies: (responseData['trophies']),
    //insignias: (responseData['insignias']));
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.id;
    data['university'] = this.university;
    data['degree'] = this.degree;
    data['user'] = this.user;
    data['ratings'] = this.ratings;
    data['trophies'] = this.trophies;
    data['insignias'] = this.insignias;
    return data;
  }
}
