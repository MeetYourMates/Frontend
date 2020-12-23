import 'package:meet_your_mates/api/models/insignia.dart';
import 'package:meet_your_mates/api/models/rating.dart';
import 'package:meet_your_mates/api/models/trophy.dart';
import 'package:meet_your_mates/api/models/user.dart';

class Student {
  String id;
  String name;
  String university;
  String degree;
  String picture;
  List<Trophy> trophies;
  List<Insignia> insignias;
  User user = new User();
  String photo;
  List<Rating> ratings;

  Student(
      {this.id,
      this.name,
      this.university,
      this.degree,
      this.user,
      this.insignias,
      this.trophies,
      this.picture,
      this.photo,
      this.ratings});

  factory Student.fromJson(Map<String, dynamic> responseData) {
    return Student(
        id: responseData['_id'],
        name: responseData['name'],
        university: responseData['university'],
        degree: responseData['degree'],
        user: User.fromJson(responseData['user']),
        picture: responseData['picture'],
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
    data['name'] = this.name;
    data['university'] = this.university;
    data['degree'] = this.degree;
    data['user'] = this.user;
    data['picture'] = this.picture;
    data['photo'] = this.photo;
    data['ratings'] = this.ratings;
    data['trophies'] = this.trophies;
    data['insignias'] = this.insignias;
    return data;
  }
}
