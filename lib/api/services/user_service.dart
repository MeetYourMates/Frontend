import 'package:flutter/foundation.dart';
import 'package:meet_your_mates/api/models/user.dart';

class UserProvider with ChangeNotifier {
  User _user = new User();

  User get user => _user;

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }
}
