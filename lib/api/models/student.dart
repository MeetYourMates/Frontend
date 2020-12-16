import 'package:meet_your_mates/api/models/user.dart';

class Student {
  String id;
  String name;
  String university;
  String degree;
  User user;
  String picture;

  //Falta implementar Rating, Trophies, insignias, chats y COURSES

  Student({
    this.id,
    this.name,
    this.university,
    this.degree,
    this.user,
  });

  factory Student.fromJson(Map<String, dynamic> responseData) {
    return Student(
      id: responseData['_id'],
      name: responseData['name'],
      university: responseData['university'],
      degree: responseData['degree'],
      user: User.fromJson(responseData['user']),
    );
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.id;
    data['name'] = this.name;
    data['university'] = this.university;
    data['degree'] = this.degree;
    data['user'] = this.user;

    return data;
  }
}
