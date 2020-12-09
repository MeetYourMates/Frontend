import 'package:flutter/material.dart';
import 'package:async/async.dart';
import 'package:meet_your_mates/api/services/start_service.dart';
import 'package:meet_your_mates/screens/GetStarted/getstarted.dart';
//Screens
import 'package:meet_your_mates/screens/Login/login.dart';
import 'package:meet_your_mates/screens/Register/register.dart';
import 'package:meet_your_mates/screens/Dashboard/dashboard.dart';
import 'package:meet_your_mates/screens/Validate/validate.dart';
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

final AsyncMemoizer _memoizerLogin = AsyncMemoizer();
final AsyncMemoizer _memoizerPreferences = AsyncMemoizer();
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
  //Future<User> getUserData() => UserPreferences().getUser();
  //Future<int> autoLogin(email, password) async =>
  //    StudentProvider().autoLogin(email, password);
  @override
  Widget build(BuildContext context) {
    //Accessing the same Student Provider as the MultiProvider, Not instantiating any new
    StudentProvider _studentProvider =
        Provider.of<StudentProvider>(context, listen: false);
    var connectivityResult = (Connectivity().checkConnectivity());
    Future _fetchLogin(String email, String password) async {
      return _memoizerLogin.runOnce(() async {
        print("AutoLogin Executed");
        int status = await _studentProvider.autoLogin(email, password);
        return status;
      });
    }

    Future _fetchPreferences() async {
      return _memoizerPreferences.runOnce(() async {
        print("AutoLogin Executed");
        User status = await UserPreferences().getUser();
        return status;
      });
    }

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
            : FutureBuilder<dynamic>(
                future: _fetchPreferences(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return Center(child: CircularProgressIndicator());
                    default:
                      if (snapshot.hasError)
                        return Text('Error: ${snapshot.error}');
                      else if ((snapshot.data == null ||
                          snapshot.data.password == null))
                        return Login();
                      else {
                        //Create another future builder to check if the user is still valid!
                        return FutureBuilder<dynamic>(
                          future: _fetchLogin(
                              snapshot.data.email, snapshot.data.password),
                          builder: (context, snapshot2) {
                            switch (snapshot2.connectionState) {
                              case ConnectionState.none:
                              case ConnectionState.waiting:
                                return Center(
                                    child: CircularProgressIndicator());
                              default:
                                if (snapshot2.hasError) {
                                  return Text('Error: ${snapshot2.error}');
                                } else if (snapshot2.data == 0) {
                                  return DashBoard();
                                } else if (snapshot2.data == 1) {
                                  return Validate();
                                } else if (snapshot2.data == 2) {
                                  return GetStarted();
                                } else {
                                  //Error in Autologgin --> Login probably -1
                                  return Login();
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
        });
  }
}
