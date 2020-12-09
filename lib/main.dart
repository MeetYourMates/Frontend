import 'package:flutter/material.dart';
import 'package:meet_your_mates/api/services/start_service.dart';
import 'package:meet_your_mates/screens/GetStarted/getstarted.dart';
//Screens
import 'package:meet_your_mates/screens/Login/login.dart';
import 'package:meet_your_mates/screens/Register/register.dart';
import 'package:meet_your_mates/screens/Dashboard/dashboard.dart';
import 'package:meet_your_mates/screens/Validate/validate.dart';
import 'package:meet_your_mates/screens/SearchMates/searchMates.dart';
//Services
import 'package:meet_your_mates/api/services/auth_service.dart';
import 'package:meet_your_mates/api/services/user_service.dart';
import 'package:meet_your_mates/api/services/student_service.dart';
//Utilities
import 'package:provider/provider.dart';
import 'package:connectivity/connectivity.dart';
import 'api/models/user.dart';
import 'api/util/shared_preference.dart';
//Models

void main() {
  runApp(
    /// Providers are above [MyApp] instead of inside it, so that tests
    /// can use [MyApp] while mocking the providers
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => StudentProvider()),
        ChangeNotifierProvider(create: (_) => StartProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  Future<User> getUserData() => UserPreferences().getUser();
  Future<bool> autoLogin(email, password) async =>
      StudentProvider().autoLogin(email, password);
  @override
  Widget build(BuildContext context) {
    //
    var connectivityResult = (Connectivity().checkConnectivity());
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Meet Your Mates',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        // ignore: unrelated_type_equality_checks
        home: (connectivityResult == ConnectivityResult.none)
            ? Center(child: Text("No Network Connection"))
            : FutureBuilder(
                future: getUserData(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return Center(child: CircularProgressIndicator());
                    default:
                      if (snapshot.hasError)
                        return Text('Error: ${snapshot.error}');
                      else if ((snapshot.data.email == null ||
                          snapshot.data.password == null))
                        return Login();
                      else {
                        //Create another future builder to check if the user is still valid!
                        return FutureBuilder(
                          future: autoLogin(
                              snapshot.data.email, snapshot.data.password),
                          builder: (context, snapshot2) {
                            switch (snapshot2.connectionState) {
                              case ConnectionState.none:
                              case ConnectionState.waiting:
                                return Center(
                                    child: CircularProgressIndicator());
                              default:
                                if (snapshot2.hasError)
                                  return Text('Error: ${snapshot.error}');
                                else if (!(snapshot2.data))
                                  return Login();
                                else {
                                  return DashBoard();
                                }
                            }
                          },
                        );
                      }
                  }
                }),
        routes: {
          '/dashboard': (context) => DashBoard(),
          '/login': (context) => Login(),
          '/register': (context) => Register(),
          '/validate': (context) => Validate(),
          '/getStarted': (context) => GetStarted(),
          '/searchMates': (context) => SearchMates(),
        });
  }
}
