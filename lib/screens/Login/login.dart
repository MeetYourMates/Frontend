import 'package:firebase_core/firebase_core.dart' as firebaseCore;
import 'package:firebase_auth/firebase_auth.dart' as firebaseAuth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:meet_your_mates/api/models/student.dart';
import 'package:meet_your_mates/api/services/student_service.dart';
import 'package:provider/provider.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';

//Services
import 'package:meet_your_mates/api/services/auth_service.dart';
//Utilities

//Constants
import 'package:meet_your_mates/constants.dart';
//Screens
import 'package:meet_your_mates/screens/Login/background.dart';
import 'package:meet_your_mates/api/util/validators.dart';
//Models
//Components
import 'package:meet_your_mates/components/already_have_an_account_acheck.dart';
import 'package:meet_your_mates/components/rounded_button.dart';
import 'package:meet_your_mates/components/text_field_container.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final formKey = new GlobalKey<FormState>();
  var logger = Logger();
  String _username, _password;

  @override
  Widget build(BuildContext context) {
    AuthProvider auth = Provider.of<AuthProvider>(context);
    var loading = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(),
        Text(" Authenticating ... Please wait")
      ],
    );

    final forgotLabel = Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        FlatButton(
          padding: EdgeInsets.all(0.0),
          child: Text("Forgot password?",
              style:
                  TextStyle(color: kPrimaryColor, fontWeight: FontWeight.w500)),
          onPressed: () {
            //Future
//            Navigator.pushReplacementNamed(context, '/reset-password');
          },
        )
      ],
    );

    var doLogin = () {
      final form = formKey.currentState;

      if (form.validate()) {
        form.save();
        logger.d("Do Login Pressed user:$_username pass:$_password");
        final Future<Map<String, dynamic>> successfulMessage =
            auth.login(_username, _password);
        //Callback to message recieved after login auth
        successfulMessage.then((response) {
          if (response['status'] == 0) {
            //Login Correct
            Student student = response['student'];
            Provider.of<StudentProvider>(context, listen: false)
                .setStudentWithUser(student);
            Navigator.pushReplacementNamed(context, '/dashboard');
            logger.d("Logged In Succesfull!");
          } else if (response['status'] == 1) {
            //Not Validated
            Student student = response['student'];
            Provider.of<StudentProvider>(context, listen: false)
                .setStudentWithUser(student);
            Navigator.pushReplacementNamed(context, '/validate');
            logger.d("Logged In Not Validated!");
          } else if (response['status'] == 2) {
            //Let's Get Started not completed
            Student student = response['student'];
            Provider.of<StudentProvider>(context, listen: false)
                .setStudentWithUser(student);
            Navigator.pushReplacementNamed(context, '/getStarted');
            logger.d("Logged In Let's Get Started not completed!");
          } else {
            logger.d("Logged In Failed: " + response['message'].toString());

            Flushbar(
              title: "Failed Login",
              message: response['message'].toString(),
              duration: Duration(seconds: 3),
            ).show(context);
          }
        });
      } else {
        logger.w("form is invalid");
      }
    };

/***************POL************************************************/

    final firebaseAuth.FirebaseAuth _firebaseAuth =
        firebaseAuth.FirebaseAuth.instance;
    final GoogleSignIn _googleSignIn = new GoogleSignIn();

    Future<firebaseAuth.FirebaseUser> _signIn(BuildContext context) async {
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final firebaseAuth.AuthCredential credential =
          firebaseAuth.GoogleAuthProvider.getCredential(
              accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

      firebaseAuth.FirebaseUser userDetails =
          await _firebaseAuth.signInWithCredential(credential);

      ProviderDetails providerInfo =
          new ProviderDetails(userDetails.providerId);
      List<ProviderDetails> providerData = new List<ProviderDetails>();
      providerData.add(providerInfo);

      UserDetails details = new UserDetails(
        userDetails.providerId,
        userDetails.displayName,
        userDetails.photoUrl,
        userDetails.email,
        providerData,
      );
      logger.d(userDetails.email);
    }

    Widget _iconGoogle() {
      return Column(children: <Widget>[
        GoogleSignInButton(
          onPressed: () => _signIn(context)
              .then((firebaseAuth.FirebaseUser user) => print(user))
              .catchError((e) => print(e)),
          darkMode: false, // default: false
        ),
      ]);
    }

/******************************************************************/

    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Background(
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "LOGIN",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                  SizedBox(height: size.height * 0.03),
                  Image.asset(
                    "assets/icons/login.png",
                    width: size.width * 0.35,
                  ),
                  SizedBox(height: size.height * 0.03),
                  TextFieldContainer(
                    child: TextFormField(
                      autofocus: false,
                      validator: validateEmail,
                      onSaved: (value) => _username = value,
                      cursorColor: kPrimaryColor,
                      decoration: InputDecoration(
                        icon: Icon(
                          Icons.person,
                          color: kPrimaryColor,
                        ),
                        hintText: "email/username",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  TextFieldContainer(
                    child: TextFormField(
                      autofocus: false,
                      obscureText: true,
                      validator: (value) =>
                          value.isEmpty ? "Please enter password" : null,
                      onSaved: (value) => _password = value,
                      cursorColor: kPrimaryColor,
                      decoration: InputDecoration(
                        icon: Icon(
                          Icons.person,
                          color: kPrimaryColor,
                        ),
                        hintText: "password",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  auth.loggedInStatus == Status.Authenticating
                      ? loading
                      : RoundedButton(
                          text: "LOGIN",
                          press: () {
                            doLogin();
                          }),
                  SizedBox(height: size.height * 0.03),
                  AlreadyHaveAnAccountCheck(
                    press: () {
                      Navigator.pushReplacementNamed(context, '/register');
                    },
                  ),
                  forgotLabel,
                  _iconGoogle(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class UserDetails {
  final String providerDetails;
  final String userName;
  final String photoUrl;
  final String userEmail;
  final List<ProviderDetails> providerData;

  UserDetails(this.providerDetails, this.userName, this.photoUrl,
      this.userEmail, this.providerData);
}

class ProviderDetails {
  ProviderDetails(this.providerDetails);
  final String providerDetails;
}
