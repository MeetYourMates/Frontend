import 'package:provider/provider.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
//Services
import 'package:meet_your_mates/api/services/auth_service.dart';
import 'package:meet_your_mates/api/services/user_service.dart';
//Utilities

//Constants
import '../../constants.dart';
//Screens
import 'package:meet_your_mates/screens/Register/background.dart';
//import 'package:meet_your_mates/api/util/shared_preference.dart';
import 'package:meet_your_mates/api/util/validators.dart';
//Models
import 'package:meet_your_mates/api/models/user.dart';
//Components
import 'package:meet_your_mates/components/already_have_an_account_acheck.dart';
import 'package:meet_your_mates/components/or_divider.dart';
import 'package:meet_your_mates/components/rounded_button.dart';
import 'package:meet_your_mates/components/social_icon.dart';
import 'package:meet_your_mates/components/text_field_container.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final formKey = new GlobalKey<FormState>();

  String _username, _password, _confirmPassword;

  @override
  Widget build(BuildContext context) {
    AuthProvider auth = Provider.of<AuthProvider>(context);

    var loading = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(),
        Text(" Registering ... Please wait")
      ],
    );
    var facebookAuth = () {
      //Not yet implemented
    };
    var googleAuth = () {
      //Not yet implemented
    };
    var twitterAuth = () {
      //Not yet implemented
    };
    var doRegister = () {
      final form = formKey.currentState;
      if (form.validate() && (_password == _confirmPassword)) {
        form.save();
        auth
            .register(
          _username,
          _password,
        )
            .then((response) {
          if (response['status']) {
            Navigator.pushReplacementNamed(context, '/validate');
          } else {
            Flushbar(
              title: "Registration Failed",
              message: response.toString(),
              duration: Duration(seconds: 10),
            ).show(context);
          }
        });
      } else {
        Flushbar(
          title: "Invalid form",
          message: "Please Complete the form properly",
          duration: Duration(seconds: 10),
        ).show(context);
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
                    "REGISTER",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                  SizedBox(height: size.height * 0.03),
                  Image.asset(
                    "assets/icons/signup.png",
                    width: size.width * 0.35,
                  ),
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
                        hintText: "email",
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
                  TextFieldContainer(
                    child: TextFormField(
                      autofocus: false,
                      validator: (value) =>
                          value.isEmpty ? "Please reenter password" : null,
                      onSaved: (value) => _confirmPassword = value,
                      cursorColor: kPrimaryColor,
                      decoration: InputDecoration(
                        icon: Icon(
                          Icons.person,
                          color: kPrimaryColor,
                        ),
                        hintText: "confirm password",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  auth.registeredInStatus == Status.Registering
                      ? loading
                      : RoundedButton(text: "REGISTER", press: doRegister),
                  SizedBox(height: size.height * 0.0),
                  AlreadyHaveAnAccountCheck(
                    login: false,
                    press: () {
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                  ),
                  //forgotLabel,
                  OrDivider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SocalIcon(
                        iconSrc: "assets/icons/facebook.png",
                        press: facebookAuth,
                      ),
                      SocalIcon(
                        iconSrc: "assets/icons/twitter.png",
                        press: twitterAuth,
                      ),
                      SocalIcon(
                        iconSrc: "assets/icons/google-plus.png",
                        press: googleAuth,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
