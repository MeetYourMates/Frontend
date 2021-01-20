import 'package:flutter/foundation.dart';

class AppBarProvider with ChangeNotifier {
  /// Private Variable Title
  String _title = "Meet Your Mates";

  /// Private Variable _notifications
  List<String> _notifications = [];

  /// Get current title set on AppBar
  String get title => _title;
  List<String> get notifications => _notifications;

  /// Set Titile to the AppBar visible on the screen
  void setTitle(String title) {
    _title = title;
    notifyListeners();
  }

  /// Add a notification to the AppBar, which will be visible
  /// when user click on the "Bell Icon".
  void addNotification(String notification) {
    _notifications.add(notification);
    notifyListeners();
  }
}
