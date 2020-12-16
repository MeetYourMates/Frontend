import 'package:another_flushbar/flushbar.dart';
import 'package:logger/logger.dart';
import 'package:meet_your_mates/api/services/auth_service.dart';
import 'package:meet_your_mates/api/services/student_service.dart';
import 'package:meet_your_mates/components/rounded_button.dart';
import 'package:meet_your_mates/components/text_field_container.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
//Services

//Utilities

//Screens
import 'package:meet_your_mates/screens/PasswordRecovery/background.dart';
import 'package:reactive_forms/reactive_forms.dart';
//Models

import '../../constants.dart';

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final emailText = TextEditingController();
  final form = FormGroup(
    {
      'code': FormControl(
        validators: [
          Validators.required,
          Validators.maxLength(7),
          Validators.minLength(7),
        ],
        touched: true,
      ),
      'password': FormControl(
        validators: [Validators.required],
        touched: true,
      ),
      'passwordConfirmation': FormControl(
        validators: [Validators.required],
        touched: true,
      ),
    },
    validators: [
      Validators.mustMatch('password', 'passwordConfirmation'),
    ],
  );
  var logger = Logger();
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    emailText.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AuthProvider auth = Provider.of<AuthProvider>(context);
    var loading = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(),
        Text(" Checking ... Please wait")
      ],
    );
    String email() {
      //Student Provider get email
      return Provider.of<StudentProvider>(context, listen: false)
          .student
          .user
          .email;
    }

    String code() => this.form.control('code').value;
    String password() => this.form.control('password').value;
    void _accept() {
      if (form.valid) {
        //We need to send the server the email and than see
        final Future<Map<String, dynamic>> successfulMessage =
            auth.changePassword(code(), email(), password());
        //Callback to message recieved after login auth
        successfulMessage.then(
          (response) {
            //If the email does exist status = true
            if (response['status']) {
              // Send the User to Login
              Navigator.pushReplacementNamed(context, '/login');
            } else {
              //If the email doesn't exist status = false
              //flushbar
              logger.d("Incorrect Recovery Code");
              Flushbar(
                title: "Failed changing password",
                message: "Incorrect recovery code or No connection!",
                duration: Duration(seconds: 3),
              ).show(context);
            }
          },
        );
      }
    }

    return SafeArea(
      child: Scaffold(
        body: Background(
          child: SingleChildScrollView(
            child: ReactiveForm(
              formGroup: this.form,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Reset Your Password?",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                  Text(
                    "Introduce your recieved code",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  TextFieldContainer(
                    child: ReactiveTextField(
                      formControlName: 'code',
                      decoration: InputDecoration(
                        icon: Icon(
                          Icons.code,
                          color: kPrimaryColor,
                        ),
                        hintText: "code",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  TextFieldContainer(
                    child: ReactiveTextField(
                      formControlName: 'password',
                      decoration: InputDecoration(
                        icon: Icon(
                          Icons.code,
                          color: kPrimaryColor,
                        ),
                        hintText: "password",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  TextFieldContainer(
                    child: ReactiveTextField(
                      formControlName: 'passwordConfirmation',
                      decoration: InputDecoration(
                        icon: Icon(
                          Icons.code,
                          color: kPrimaryColor,
                        ),
                        hintText: "Retype password",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  auth.loggedInStatus == Status.Sending
                      ? loading
                      : RoundedButton(
                          text: "Accept",
                          press: _accept,
                        ),
                  RoundedButton(
                    text: "Cancel",
                    press: () => {
                      Navigator.pushReplacementNamed(context, '/login'),
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
