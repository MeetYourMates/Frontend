// To parse this JSON data, do
//
//     final privateChatHistory = privateChatHistoryFromJson(jsonString);

import 'dart:convert';

import 'package:meet_your_mates/api/models/message.dart';
import 'package:meet_your_mates/api/models/user.dart';

class PrivateChatHistory {
  PrivateChatHistory({
    this.id,
    this.users,
    this.messages,
  });

  String id;
  List<User> users;
  List<Message> messages;

  factory PrivateChatHistory.fromRawJson(String str) => PrivateChatHistory.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PrivateChatHistory.fromJson(Map<String, dynamic> json) => PrivateChatHistory(
        id: json["_id"] == null ? "no Id" : json["_id"],
        users: json["users"] == null ? [] : List<User>.from(json["users"].map((x) => User.fromJson(x))),
        messages: json["messages"] == null ? [] : List<Message>.from(json["messages"].map((x) => Message.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "_id": id == null ? null : id,
        "users": users == null ? [] : List<dynamic>.from(users.map((x) => x.toJson())),
        "messages": messages == null ? [] : List<dynamic>.from(messages.map((x) => x.toJson())),
      };
}
