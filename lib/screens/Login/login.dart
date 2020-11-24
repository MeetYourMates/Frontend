import 'package:meet_your_mates/api/models/student.dart';
import 'package:provider/provider.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
//Services
import 'package:meet_your_mates/api/services/auth_service.dart';
import 'package:meet_your_mates/api/services/user_service.dart';
//Utilities

//Constants
import 'package:meet_your_mates/constants.dart';
//Screens
import 'package:meet_your_mates/screens/Login/background.dart';
import 'package:meet_your_mates/api/util/validators.dart';
//Models
import 'package:meet_your_mates/api/models/user.dart';
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

        final Future<Map<String, dynamic>> successfulMessage =
            auth.login(_username, _password);
        //Callback to message recieved after login auth
        successfulMessage.then((response) {
          if (response['status']) {
            Student student = response['student'];
            Provider.of<UserProvider>(context, listen: false)
                .setUser(student.user);
            Navigator.pushReplacementNamed(context, '/dashboard');
          } else {
            Flushbar(
              title: "Failed Login",
              message: response['message']['message'].toString(),
              duration: Duration(seconds: 3),
            ).show(context);
          }
        });
      } else {
        print("form is invalid");
      }
    };

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
                          press: doLogin,
                        ),
                  SizedBox(height: size.height * 0.03),
                  AlreadyHaveAnAccountCheck(
                    press: () {
                      Navigator.pushReplacementNamed(context, '/register');
                    },
                  ),
                  forgotLabel,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
