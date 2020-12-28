import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
//Services
import 'package:meet_your_mates/api/services/auth_service.dart';
import 'package:meet_your_mates/api/services/image_service.dart';
import 'package:meet_your_mates/api/services/start_service.dart';
import 'package:meet_your_mates/api/services/stream_socket_service.dart';
import 'package:meet_your_mates/api/services/student_service.dart';
import 'package:meet_your_mates/api/services/user_service.dart';
import 'package:meet_your_mates/components/error.dart';
import 'package:meet_your_mates/components/loading.dart';
import 'package:meet_your_mates/screens/Dashboard/dashboard.dart';
import 'package:meet_your_mates/screens/GetStarted/getstarted.dart';
//Screens
import 'package:meet_your_mates/screens/Login/login.dart';
import 'package:meet_your_mates/screens/PasswordRecovery/changePassword.dart';
import 'package:meet_your_mates/screens/PasswordRecovery/passwordRecovery.dart';
import 'package:meet_your_mates/screens/Profile/edit_profile.dart';
import 'package:meet_your_mates/screens/Profile/profile.dart';
import 'package:meet_your_mates/screens/Register/register.dart';
import 'package:meet_your_mates/screens/SearchMates/searchMates.dart';
import 'package:meet_your_mates/screens/Validate/validate.dart';
import 'package:overlay_support/overlay_support.dart';
//Utilities
import 'package:provider/provider.dart';

import 'api/models/user.dart';
import 'api/util/shared_preference.dart';

//Models

void main() async {
  /// Due to [firebase] requires the Main App to be initalized
  WidgetsFlutterBinding.ensureInitialized();

  /// [Firebase] still in beta, most errors of java, due to this!
  await Firebase.initializeApp();

  /// [runApp] which is a Dart funciton to initalize the [Widget Tree]
  runApp(
    /// Providers are above [MyApp] instead of inside it, so that [Other Widgets] including [MyApp]
    /// can use, while mocking the providers. Which means change the state inside it.
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

/// [MyApp] The Main Application, from which all of the Activity Occur
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    /// Accessing the same Student Provider from the MultiProvider
    StudentProvider _studentProvider = Provider.of<StudentProvider>(context, listen: true);

    /// [_fetchLogin] Fetches AutoLogin Response
    Future<int> _fetchLogin(String email, String password) async {
      print("AutoLogin Executed");
      return await _studentProvider.autoLogin(email, password);
    }

    /// [_fetchPreferences] We fetch the preference from the storage and notify in future
    Future<User> _fetchPreferences() async {
      print("AutoLogin Executed");
      User user = await UserPreferences().getUser();
      return user;
    }

    /// [getFutureBuildWidget] Depending on the Result from SharedPreferences or Server, we Build the Widget
    final getFutureBuildWidget = FutureBuilder<dynamic>(
      future: _fetchPreferences(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return LoadingPage();
          default:
            if (snapshot.hasError)
              return ErrorShow(
                errorText: snapshot.error,
              );
            else if (snapshot.data == null || snapshot.data.password == null)
              return Login();
            else {
              /// We use another [FutureBuilder] to get the data in a future to be exact
              /// we ask server [_fetchlogin] if the user is still valid
              /// untill than we show something else to user.
              return FutureBuilder<int>(
                future: _fetchLogin(snapshot.data.email, snapshot.data.password),
                builder: (context, snapshot2) {
                  switch (snapshot2.connectionState) {
                    case ConnectionState.none:

                      /// Show [ErrorScreen], as we are unable to get the response...
                      return ErrorShow(errorText: "Cannot Connect to Server...");
                    case ConnectionState.waiting:

                      /// Show [LoadingScreen], as we are waiting for the response...
                      return LoadingPage();
                    default:
                      if (snapshot2.hasError) {
                        /// Show [ErrorScreen], as we got a error
                        return ErrorShow(
                          errorText: snapshot2.error,
                        );
                      } else if (snapshot2.data == 0) {
                        /// Redirect to [DashBoard]
                        return DashBoard();
                      } else if (snapshot2.data == 1) {
                        /// Redirect to [Validate]
                        return Validate();
                      } else if (snapshot2.data == 2) {
                        /// Redirect to [GetStarted]
                        return GetStarted();
                      } else {
                        //Error in Autologgin --> Login probably -1
                        /// Redirect to [Login]
                        return Login();
                      }
                  }
                },
              );
            }
        }
      },
    );

    /// [MaterialApp] The main UI build of the application
    return OverlaySupport(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Meet Your Mates',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        builder: EasyLoading.init(),

        /// We use [ConnectivityBuilder] to check if connectivity
        /// we recieve the data from [isConnected] which is a stream we are listening to, if state change occurs
        /// widget tree is rebuit. If [Null] Or [NotConnected] we show noConnection Wdiget
        /// else we try to connect to our Backend Server
        home: getFutureBuildWidget,
        /* OfflineBuilder(
          child: SizedBox.expand(
            child: Container(
              child: Text("Checking Connection..."),
            ),
          ),
          connectivityBuilder:
              (BuildContext context, ConnectivityResult connectivity, Widget child) {
            if (connectivity == ConnectivityResult.none) {
              return NoConnection();
            } else {
              return /
              ;
            }
          },
        ) */
        routes: {
          '/dashboard': (context) => DashBoard(),
          '/login': (context) => Login(),
          '/register': (context) => Register(),
          '/validate': (context) => Validate(),
          '/getStarted': (context) => GetStarted(),
          '/searchMates': (context) => SearchMates(),
          '/passwordRecovery': (context) => PasswordRecovery(),
          '/changePassword': (context) => ChangePassword(),
          '/profile': (context) => Profile(),
          '/editProfile': (context) => EditProfile(),
        },
      ),
    );
  }
}
