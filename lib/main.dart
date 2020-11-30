import 'package:flutter/material.dart';
import 'package:meet_your_mates/api/models/student.dart';
import 'package:meet_your_mates/api/services/start_service.dart';
import 'package:meet_your_mates/api/util/shared_preference.dart';
import 'package:meet_your_mates/screens/Dashboard/dashboard.dart';
import 'package:meet_your_mates/screens/GetStarted/getstarted.dart';
import 'package:provider/provider.dart';
import 'api/models/user.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  Future<User> getUserData() => UserPreferences().getUser();
  Student getStudentData() {
    return Student(
        id: "5fbcd8854506b76778cf3949",
        name: "kru",
        university: "",
        degree: "",
        user: User(
          id: "",
          email: "",
          password: "",
          token: "",
        ));
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => StartProvider()),
        ],
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Meet Your Mates',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            home: GetStarted(student: getStudentData()),
            routes: {
              '/dashboard': (context) => DashBoard(),
            }));
  }
}
