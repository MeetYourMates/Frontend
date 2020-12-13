import 'package:meet_your_mates/api/models/user.dart';


class Professor {
  String name;
  User user;
  String picture;

  Professor(
      {this.name, this.user, this.picture});
  factory Professor.fromJson(Map<String, dynamic> responseData) {
    return Professor(
        name: responseData['name'],
        user: responseData['user'],
        picture: responseData['picture']
);
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['user'] = this.user;
    data['picture'] = this.picture;
    return data;
  }
}