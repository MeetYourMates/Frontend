import 'package:meet_your_mates/api/models/message.dart';

class ChatUser {
  String id;
  String email;
  String name;
  String surname;
  List<Message> messagesList = <Message>[];

  ChatUser({this.id, this.email, this.name, this.surname});
  factory ChatUser.fromJson(Map<String, dynamic> responseData) {
    return ChatUser(
        id: responseData['_id'],
        name: responseData['name'],
        surname: responseData['surname'],
        email: responseData['email']);
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.id;
    data['email'] = this.email;
    data['name'] = this.name;
    data['surname'] = this.surname;
    return data;
  }

  @override
  String toString() {
    return "id: " +
        (id == null ? "NULL" : id) +
        "email:" +
        (email == null ? "NULL" : email) +
        " name: " +
        (name == null ? "NULL" : name) +
        " token:" +
        (surname == null ? "NULL" : surname);
  }
}
