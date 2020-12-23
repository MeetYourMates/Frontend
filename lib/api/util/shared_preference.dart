import 'dart:async';

import 'package:logger/logger.dart';
import 'package:meet_your_mates/api/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  var logger = Logger(level: Level.warning);
  Future<bool> saveUser(User user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("userId", user.id);
    prefs.setString("email", user.email);
    prefs.setString("picture", user.picture);
    prefs.setString("name", user.name);
    prefs.setString("token", user.token);
    prefs.setString("password", user.password);
    return prefs.getString("token") != null ? true : false;
  }

  Future<User> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    logger.d("Shared Preferences getUser");
    String userId = prefs.getString("userId");
    String email = prefs.getString("email");
    String picture = prefs.getString("picture");
    String name = prefs.getString("name");
    String token = prefs.getString("token");
    String password = prefs.getString("password");
    logger.d("getUser id: " + (userId == null ? "Null" : userId));
    logger.d("getUser email: " + (email == null ? "Null" : email));
    logger.d("getUser name: " + (name == null ? "Null" : name));
    logger.d("getUser picture: " + (picture == null ? "Null" : picture));
    logger.d("getUser token: " + (token == null ? "Null" : token));
    logger.d("getUser password: " + (password == null ? "Null" : password));
    return User(
        id: userId,
        email: email,
        token: token,
        password: password,
        name: name,
        picture: picture);
  }

  void removeUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("userId");
    prefs.remove("email");
    prefs.remove("name");
    prefs.remove("picture");
    prefs.remove("token");
    prefs.remove("password");
  }

  Future<String> getToken(args) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    return token;
  }
}
