import 'package:meet_your_mates/api/models/insignia.dart';
import 'package:meet_your_mates/api/models/trophy.dart';
import 'package:meet_your_mates/api/models/user.dart';
import 'package:meet_your_mates/screens/Trophies/trophies.dart';

class Student {
  String id;
  String name;
  String university;
  String degree;
  List<Trophy> trophies;
  List<Insignia> insignias;
  User user;

  Student(
      {this.id,
      this.name,
      this.university,
      this.degree,
      this.user,
      this.insignias,
      this.trophies});

  factory Student.fromJson(Map<String, dynamic> responseData) {
    return Student(
      id: responseData['_id'],
      name: responseData['name'],
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
    data['name'] = this.name;
    data['university'] = this.university;
    data['degree'] = this.degree;
    data['user'] = this.user;
    //data['trophies'] = this.trophies;
    //data['insignias'] = this.insignias;
    return data;
  }
}
