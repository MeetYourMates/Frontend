import 'package:another_flushbar/flushbar.dart';
import 'package:auth_buttons/auth_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:logger/logger.dart';
import 'package:meet_your_mates/api/models/professor.dart';
import 'package:meet_your_mates/api/models/student.dart';
import 'package:meet_your_mates/api/models/user.dart';
//Models
import 'package:meet_your_mates/api/models/userDetails.dart';
//Services
import 'package:meet_your_mates/api/services/auth_service.dart';
import 'package:meet_your_mates/api/services/professor_service.dart';
import 'package:meet_your_mates/api/services/student_service.dart';
import 'package:meet_your_mates/api/services/user_service.dart';
import 'package:meet_your_mates/api/util/route_uri.dart';
//Components
import 'package:meet_your_mates/components/already_have_an_account_check.dart';
import 'package:meet_your_mates/components/rounded_button.dart';
import 'package:meet_your_mates/components/text_field_container.dart';
//Constants
import 'package:meet_your_mates/constants.dart';
//Screens
import 'package:meet_your_mates/screens/Login/background.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  //final formKey = new GlobalKey<FormState>();
  var logger = Logger();

  /// [Reactive Form]
  final form = FormGroup({
    'password': FormControl(validators: [
      Validators.required,
      Validators.minLength(3),
    ]),
    'email': FormControl(validators: [
      Validators.required,
      Validators.email,
    ]),
  });
  String _username, _password;

  @override
  Widget build(BuildContext context) {
    /// [AuthProvider] Single Dependency Injection of Authentication
    AuthProvider auth = Provider.of<AuthProvider>(context, listen: true);

    /// [loading] Widget of Loading Indicator
    final loading = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[CircularProgressIndicator(), Text(" Authenticating ... Please wait")],
    );

    /// [forgotLabel] Widget of forgotLabel
    final forgotLabel = Center(
        child: GestureDetector(
      onTap: () {
        //Future
        Navigator.pushReplacementNamed(context, RouteUri.passwordRecovery);
      },
      child: Text(
        "Forgot password?",
        style: TextStyle(
          color: kPrimaryColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    ));

    final doLogin = () {
      //final form = formKey.currentState;

      if (form.valid) {
        //form.save();
        EasyLoading.show(
          status: 'loading...',
          maskType: EasyLoadingMaskType.black,
        ).then((value) {
          //
          _username = this.form.control('email').value;
          _password = this.form.control('password').value;
          logger.d("Do Login Pressed user:$_username pass:$_password");
          final Future<Map<String, dynamic>> successfulMessage = auth.login(_username, _password);
          //Callback to message recieved after login auth
          successfulMessage.then((response) {
            EasyLoading.dismiss().then((value) {
              if (response['status'] == 0) {
                //Login Correct
                Student student = response['student'];
                //Provider.of<StudentProvider>(context, listen: false).setPassword(student.user.password);
                Provider.of<StudentProvider>(context, listen: false).setStudentWithUserWithPassword(student);
                Navigator.pushReplacementNamed(context, RouteUri.dashboardStudent);
                logger.d("Logged In Succesfull!");
              } else if (response['status'] == 1) {
                //Not Validated
                User user = response['user'];
                //Provider.of<StudentProvider>(context, listen: false).setPassword(student.user.password);
                Provider.of<UserProvider>(context, listen: false).setUser(user);
                Navigator.pushReplacementNamed(context, RouteUri.validate);
                logger.d("Logged In Not Validated!");
              } else if (response['status'] == 2) {
                //Let's Get Started not completed
                Student student = response['student'];
                Provider.of<StudentProvider>(context, listen: false).setStudentWithUserWithPassword(student);
                Navigator.pushReplacementNamed(context, RouteUri.getStartedStudent);
                logger.d("Logged In Let's Get Started not completed!");
              } else if (response['status'] == 3) {
                //Validated and getStarted completed Dashboard Professor
                Professor professor = response['professor'];
                //Provider.of<StudentProvider>(context, listen: false).setPassword(student.user.password);
                Provider.of<ProfessorProvider>(context, listen: false).setProfessorWithUserWithPassword(professor);
                Navigator.pushReplacementNamed(context, RouteUri.dashboardProfessor);
                logger.d("Logged In dashboard Professor!");
              } else if (response['status'] == 4) {
                //Validated but GetStarted Professor not Finished
                Professor professor = response['professor'];
                Provider.of<ProfessorProvider>(context, listen: false).setProfessorWithUserWithPassword(professor);
                Navigator.pushReplacementNamed(context, RouteUri.getStartedProfessor);
                logger.d("Logged In getStartedProfessor not completed!");
              } else {
                logger.d("Logged In Failed: " + response['message'].toString());

                Flushbar(
                  title: "Failed Login",
                  message: response['message'].toString(),
                  duration: Duration(seconds: 3),
                ).show(context);
              }
            });
          });
        });
      } else {
        logger.w("form is invalid");
      }
    };

/***************POL************************************************/
    // ignore: todo
    //TODO: IN THE SIGNIN GOOGLE ALSO NEED TO CHECK IN FUTURE IF PROFESSOR OR USER!
    var signInGoogleCorrectly = (UserDetails userRegistered) {
      Student regGoogle = new Student();
      User userTemp =
          new User(email: userRegistered.userEmail, password: userRegistered.uid, name: userRegistered.userName, picture: userRegistered.photoUrl);
      logger.w("UserEmail 112: " + userRegistered.userEmail);
      regGoogle.user = userTemp;

      auth.registerWithGoogle(regGoogle).then((response) {
        if (response['status'] == true) {
          //If status is ok than we make the user login and continue with the process
          final Future<Map<String, dynamic>> successfulMessage = auth.login(userRegistered.userEmail, userRegistered.userEmail);
          //Callback to message recieved after login auth
          successfulMessage.then((response2) {
            logger.w("UserEmail 125: " + userRegistered.userEmail);
            if (response2['status'] == 0) {
              //Login Correct
              Student student = response2['student'];
              Provider.of<StudentProvider>(context, listen: false).setStudentWithUser(student);
              Navigator.pushReplacementNamed(context, RouteUri.dashboardStudent);
              logger.d("Logged In Succesfull!");
            } else if (response2['status'] == 2) {
              //Let's Get Started not completed
              Student student = response2['student'];
              Provider.of<StudentProvider>(context, listen: false).setStudentWithUser(student);
              Navigator.pushReplacementNamed(context, RouteUri.getStartedStudent);
              logger.d("Logged In Let's Get Started not completed!");
            } else {
              logger.d("Logged In Failed: " + response2['message'].toString());

              Flushbar(
                title: "Failed Login",
                message: response2['message'].toString(),
                duration: Duration(seconds: 3),
              ).show(context);
            }
          });
        } else if ((response['status'] == false)) {
          logger.w("UserEmail 150: " + userRegistered.userEmail);
          final Future<Map<String, dynamic>> successfulMessage = auth.login(userRegistered.userEmail, userRegistered.userEmail);
          //Callback to message recieved after login auth
          successfulMessage.then((response2) {
            if (response2['status'] == 0) {
              //Login Correct
              Student student = response2['student'];
              Provider.of<StudentProvider>(context, listen: false).setStudentWithUser(student);
              Navigator.pushReplacementNamed(context, RouteUri.dashboardStudent);
              logger.d("Logged In Succesfull!");
            } else if (response2['status'] == 2) {
              //Let's Get Started not completed
              Student student = response2['student'];
              Provider.of<StudentProvider>(context, listen: false).setStudentWithUser(student);
              Navigator.pushReplacementNamed(context, RouteUri.dashboardStudent);
              logger.d("Logged In Let's Get Started not completed!");
            } else {
              logger.d("Logged In Failed: " + response2['message'].toString());
              Flushbar(
                title: "Failed Login",
                message: response2['message'].toString(),
                duration: Duration(seconds: 3),
              ).show(context);
            }
          });
        } else {
          Flushbar(
            title: "Registration Failed",
            message: response['message'].toString(),
            duration: Duration(seconds: 10),
          ).show(context);
        }
      });
    };

    Widget _iconGoogle() {
      return Column(
        children: <Widget>[
          GoogleAuthButton(
            onPressed: () => auth.signInGoogle().then((UserDetails user) => signInGoogleCorrectly(user)).catchError((e) => logger.e(e)),
            darkMode: false, // default: false
          ),
        ],
      );
    }

/******************************************************************/
//* RESPONSIVE LOGIN...
    Size size = MediaQuery.of(context).size * 0.95;
    return Scaffold(
      body: SafeArea(
        child: Background(
          child: Center(
            child: SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              child: Container(
                alignment: Alignment.center,
                constraints: BoxConstraints.tightForFinite(width: 400, height: size.height * 0.92),
                child: ReactiveForm(
                  formGroup: this.form,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        width: size.width,
                        height: size.height * 0.4,
                        child: Image.asset(
                          "assets/icons/login.png",
                          //width: size.width * 0.35,
                        ),
                      ),
                      SizedBox(
                        width: size.width,
                        height: size.height * 0.12,
                        child: TextFieldContainer(
                          child: ReactiveTextField(
                            formControlName: 'email',
                            autofocus: false,
                            cursorColor: kPrimaryColor,
                            decoration: InputDecoration(
                              icon: Icon(
                                Icons.person,
                                color: kPrimaryColor,
                              ),
                              hintText: "email",
                              border: InputBorder.none,
                            ),
                            validationMessages: (control) =>
                                {'required': 'The email must not be empty', 'email': 'The email value must be a valid email'},
                          ),
                        ),
                      ),
                      SizedBox(
                        width: size.width,
                        height: size.height * 0.12,
                        child: TextFieldContainer(
                          child: ReactiveTextField(
                            formControlName: 'password',
                            obscureText: true,
                            autofocus: false,
                            cursorColor: kPrimaryColor,
                            decoration: InputDecoration(
                              icon: Icon(
                                Icons.person,
                                color: kPrimaryColor,
                              ),
                              hintText: "password",
                              border: InputBorder.none,
                            ),
                            validationMessages: (control) =>
                                {'required': 'The password must not be empty', 'minLenght': 'The password must have at least 8 characters'},
                          ),
                        ),
                      ),
                      SizedBox(
                        width: size.width,
                        height: size.height * 0.1,
                        child: auth.loggedInStatus == Status.Authenticating ? loading : RoundedButton(text: "LOGIN", press: doLogin),
                      ),
                      SizedBox(height: 6, width: size.width),
                      SizedBox(
                        width: size.width,
                        height: size.height * 0.03,
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: AlreadyHaveAnAccountCheck(
                            press: () {
                              Navigator.pushReplacementNamed(context, RouteUri.register);
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 6, width: size.width),
                      SizedBox(
                        width: size.width,
                        height: size.height * 0.03,
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: forgotLabel,
                        ),
                      ),
                      SizedBox(
                        width: size.width,
                        height: size.height * 0.01,
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: SizedBox(height: 6, width: size.width),
                        ),
                      ),
                      SizedBox(
                        width: size.width,
                        height: size.height * 0.08,
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: _iconGoogle(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
