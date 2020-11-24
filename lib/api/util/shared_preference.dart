import 'package:meet_your_mates/api/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class UserPreferences {
  Future<bool> saveUser(User user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString("userId", user.id);
    prefs.setString("email", user.email);
    prefs.setString("token", user.token);
    return prefs.getBool("token") ?? false;
  }

  Future<User> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String userId = prefs.getString("userId");
    String email = prefs.getString("email");
    String token = prefs.getString("token");

    return User(id: userId, email: email, token: token);
  }

  void removeUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("userId");
    prefs.remove("email");
    prefs.remove("token");
  }

  Future<String> getToken(args) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    return token;
  }
}
