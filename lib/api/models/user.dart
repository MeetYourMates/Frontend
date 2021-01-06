import 'package:meet_your_mates/api/models/message.dart';

class User {
  String id;
  String email;
  String password;
  String picture;
  String name;
  String token;
  DateTime lastActiveAt;
  bool isOnline = false;

  List<Message> messagesList = <Message>[];

  User({this.id, this.email, this.password, this.token, this.picture, this.lastActiveAt, this.name});
  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["_id"] == null ? null : json["_id"],
        email: json["email"] == null ? null : json["email"],
        password: json["password"] == null ? null : json["password"],
        token: json["email"] == null ? null : json["token"],
        picture: json["picture"] == null ? null : json["picture"],
        name: json["name"] == null ? null : json["name"],
        lastActiveAt: json["lastActiveAt"] == null ? null : DateTime.parse(json["lastActiveAt"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id == null ? null : id,
        "email": email == null ? null : email,
        "password": password == null ? null : password,
        "token": email == null ? null : token,
        "picture": picture == null ? null : picture,
        "name": name == null ? null : name,
        "lastActiveAt": lastActiveAt == null ? null : lastActiveAt.toIso8601String(),
      };
  @override
  bool operator ==(Object other) => other is User && other.id == id;

  @override
  int get hashCode => id.hashCode;
  @override
  String toString() {
    return "id: " +
        (id == null ? "NULL" : id) +
        "email:" +
        (email == null ? "NULL" : email) +
        "picture:" +
        (picture == null ? "NULL" : picture) +
        "name:" +
        (name == null ? "NULL" : name) +
        " password: " +
        (password == null ? "NULL" : password) +
        " token:" +
        (token == null ? "NULL" : token);
  }
}
