import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
//Services
import 'package:meet_your_mates/api/services/auth_service.dart';
import 'package:meet_your_mates/api/services/image_service.dart';
import 'package:meet_your_mates/api/services/mate_provider.dart';
import 'package:meet_your_mates/api/services/professor_service.dart';
import 'package:meet_your_mates/api/services/socket_service.dart';
import 'package:meet_your_mates/api/services/start_service.dart';
import 'package:meet_your_mates/api/services/student_service.dart';
import 'package:meet_your_mates/api/services/user_service.dart';
import 'package:meet_your_mates/api/util/route_uri.dart';
import 'package:meet_your_mates/components/error.dart';
import 'package:meet_your_mates/components/loading.dart';
import 'package:meet_your_mates/screens/DashboardProfessor/dashboardProfessor.dart';
import 'package:meet_your_mates/screens/DashboardStudent/dashboardStudent.dart';
import 'package:meet_your_mates/screens/GetStarted/getstarted_student.dart';
import 'package:meet_your_mates/screens/GetStartedProfessor/getstarted_professor.dart';
//Screens
import 'package:meet_your_mates/screens/Login/login.dart';
import 'package:meet_your_mates/screens/PasswordRecovery/changePassword.dart';
import 'package:meet_your_mates/screens/PasswordRecovery/passwordRecovery.dart';
import 'package:meet_your_mates/screens/ProfileProfessor/edit_profile_professor.dart';
import 'package:meet_your_mates/screens/ProfileStudent/edit_profile_student.dart';
import 'package:meet_your_mates/screens/ProjectsProfessor/projectsProfessor.dart';
import 'package:meet_your_mates/screens/Register/register.dart';
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
        ChangeNotifierProvider(create: (_) => ProfessorProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => StudentProvider()),
        ChangeNotifierProvider(create: (_) => MateProvider()),
        ChangeNotifierProvider(create: (_) => StartProvider()),
        ChangeNotifierProvider(create: (_) => ImagesProvider()),
        ChangeNotifierProvider(create: (_) => SocketProvider()),
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
    ProfessorProvider _professorProvider = Provider.of<ProfessorProvider>(context, listen: true);

    /// [_fetchLogin] Fetches AutoLogin Response
    Future<int> _fetchLogin(String email, String password) async {
      print("AutoLogin Executed");
      //Check if Email contains estudiantat, if not then its probably of professor
      if (email.contains('@estudiantat.upc.edu')) {
        return await _studentProvider.autoLogin(email, password);
      } else {
        return await _professorProvider.autoLogin(email, password);
      }
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
                        /// Redirect to [DashBoard Student]
                        return DashBoardStudent();
                      } else if (snapshot2.data == 1) {
                        /// Redirect to [Validate Both Professor and Student]
                        Provider.of<UserProvider>(context, listen: false).user.email = snapshot.data.email;
                        Provider.of<UserProvider>(context, listen: false).user.password = snapshot.data.password;
                        return Validate();
                      } else if (snapshot2.data == 2) {
                        /// Redirect to [GetStarted Student]
                        return GetStartedStudent();
                      } else if (snapshot2.data == 3) {
                        /// Redirect to [DashBoard Professor]
                        return DashBoardProfessor();
                      } else if (snapshot2.data == 4) {
                        /// Redirect to [GetStarted Professor]
                        return GetStartedProfessor();
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

        routes: {
          //* User Screens
          RouteUri.login: (context) => Login(),
          RouteUri.register: (context) => Register(),
          RouteUri.validate: (context) => Validate(),
          RouteUri.passwordRecovery: (context) => PasswordRecovery(),
          RouteUri.changePassword: (context) => ChangePassword(),
          //* All Else
          RouteUri.dashboardStudent: (context) => DashBoardStudent(),
          RouteUri.dashboardProfessor: (context) => DashBoardProfessor(),

          RouteUri.getStartedStudent: (context) => GetStartedStudent(),
          RouteUri.getStartedProfessor: (context) => GetStartedProfessor(),

          RouteUri.editProfileStudent: (context) => EditProfileStudent(),
          RouteUri.editProfileProfessor: (context) => EditProfileProfessor(),

          //* Project Screens
          RouteUri.projectsProfessor: (context) => ProjectsProfessor(),
        },
      ),
    );
  }
}
