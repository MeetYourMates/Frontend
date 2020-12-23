import 'package:async/async.dart';
import 'package:flutter/material.dart';
//Services
import 'package:meet_your_mates/api/services/auth_service.dart';
import 'package:meet_your_mates/api/services/image_service.dart';
import 'package:meet_your_mates/api/services/start_service.dart';
import 'package:meet_your_mates/api/services/stream_socket_service.dart';
import 'package:meet_your_mates/api/services/student_service.dart';
import 'package:meet_your_mates/api/services/user_service.dart';
import 'package:meet_your_mates/screens/Dashboard/dashboard.dart';
import 'package:meet_your_mates/screens/GetStarted/getstarted.dart';
//Screens
import 'package:meet_your_mates/screens/Login/login.dart';
import 'package:meet_your_mates/screens/Profile/edit_profile.dart';
import 'package:meet_your_mates/screens/Profile/profile.dart';
import 'package:meet_your_mates/screens/Register/register.dart';
import 'package:meet_your_mates/screens/Validate/validate.dart';
import 'package:meet_your_mates/screens/SearchMates/searchMates.dart';
import 'package:meet_your_mates/screens/Profile/profile.dart';
import 'package:meet_your_mates/screens/Profile/edit_profile.dart';
//Services
import 'package:meet_your_mates/api/services/auth_service.dart';
import 'package:meet_your_mates/api/services/user_service.dart';
import 'package:meet_your_mates/api/services/student_service.dart';
import 'package:meet_your_mates/api/services/image_service.dart';
//Utilities
import 'package:provider/provider.dart';

import 'api/models/user.dart';
import 'api/util/shared_preference.dart';

//Models

final AsyncMemoizer _memoizerLogin = AsyncMemoizer();
final AsyncMemoizer _memoizerPreferences = AsyncMemoizer();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // ignore: unused_local_variable
  //SocketService socketService = new StrSocketService();
  runApp(
    /// Providers are above [MyApp] instead of inside it, so that tests
    /// can use [MyApp] while mocking the providers
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => StudentProvider()),
        ChangeNotifierProvider(create: (_) => StartProvider()),
        ChangeNotifierProvider(create: (_) => ImagesProvider()),
        ChangeNotifierProvider(create: (_) => StreamSocketProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  //*******************************KRUNAL**************************************/
  @override
  Widget build(BuildContext context) {
    /// Accessing the same Student Provider from the MultiProvider
    StudentProvider _studentProvider =
        Provider.of<StudentProvider>(context, listen: false);

    /// [connectivity] to ensure network connectivity check on start of application
    //var connectivityResult = (Connectivity().checkConnectivity());

    /// [_fetchLogin] Run Once and memorize the recieved data from the serverç
    /// to no execute multiple quieries even when the application rebuilds completely
    /// but when restarts it is executed again
    Future _fetchLogin(String email, String password) async {
      return _memoizerLogin.runOnce(
        () async {
          print("AutoLogin Executed");
          int status = await _studentProvider.autoLogin(email, password);
          return status;
        },
      );
    }

    /// [_fetchPreferences] Run Once and memorize the recieved data from the serverç
    /// to no execute multiple quieries even when the application rebuilds completely
    /// but when restarts it is executed again
    Future _fetchPreferences() async {
      return _memoizerPreferences.runOnce(
        () async {
          print("AutoLogin Executed");
          User status = await UserPreferences().getUser();
          return status;
        },
      );
    }

    /// [MaterialApp] The main UI build of the application
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Meet Your Mates',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        // ignore: unrelated_type_equality_checks
        home:

            /// We use [FutureBuilder] to get the data in a future to be exact
            /// we recieve the data from [UserPreferences] and untill
            /// than we show something else to user.
            FutureBuilder<dynamic>(
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
                        /// We use another [FutureBuilder] to get the data in a future to be exact
                        /// we ask server [_fetchlogin] if the user is still valid
                        /// untill than we show something else to user.
                        return FutureBuilder<dynamic>(
                          future: _fetchLogin(
                              snapshot.data.email, snapshot.data.password),
                          builder: (context, snapshot2) {
                            switch (snapshot2.connectionState) {
                              case ConnectionState.none:
                              case ConnectionState.waiting:
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              default:
                                if (snapshot2.hasError) {
                                  return Text('Error: ${snapshot2.error}');
                                } else if (snapshot2.data == 0) {
                                  //Means everything correct
                                  //Connect to Socket
                                  Provider.of<StreamSocketProvider>(context,
                                          listen: false)
                                      .createSocketConnection(
                                          _studentProvider.student.user.token);
                                  //Redirect to DashBoard
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
          '/searchMates': (context) => SearchMates(),
          '/profile': (context) => Profile(),
          '/editProfile': (context) => EditProfile(),
        });
  }
}
