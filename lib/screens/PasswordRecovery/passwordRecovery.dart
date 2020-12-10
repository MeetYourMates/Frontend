import 'package:another_flushbar/flushbar.dart';
import 'package:logger/logger.dart';
import 'package:meet_your_mates/api/models/student.dart';
import 'package:meet_your_mates/api/models/user.dart';
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

class PasswordRecovery extends StatefulWidget {
  @override
  _PasswordRecoveryState createState() => _PasswordRecoveryState();
}

class _PasswordRecoveryState extends State<PasswordRecovery> {
  final emailText = TextEditingController();
  final form = FormGroup(
    {
      'email': FormControl(
        validators: [
          Validators.required,
          Validators.email,
        ],
        touched: true,
      ),
    },
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
    String email() => this.form.control('email').value;
    void sendEmail() {
      if (form.valid) {
        //We need to send the server the email and than see
        final Future<Map<String, dynamic>> successfulMessage =
            auth.recoverPassword(email());
        //Callback to message recieved after login auth
        successfulMessage.then(
          (response) {
            //If the email does exist status = true
            if (response['status']) {
              //Means the email is correct --> save it in student->user->email
              Student student = new Student();
              User usr = new User();
              usr.email = email();
              student.user = usr;
              //We have the email in our student for further use in change password
              Provider.of<StudentProvider>(context, listen: false)
                  .setStudentWithUser(student);
              Navigator.pushReplacementNamed(context, '/changePassword');
            } else {
              //If the email doesn't exist status = false
              //flushbar
              logger.d("Email Not Sent, Email Doesn't Exist!");
              Flushbar(
                title: "Email Not Sent",
                message: "User with email doesn't exist",
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
                    "Forgot Your Password?",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                  Text(
                    "Introduce your email",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  TextFieldContainer(
                    child: ReactiveTextField(
                      formControlName: 'email',
                      validationMessages: (control) => {
                        'required': 'The email must not be empty',
                        'email': 'The email value must be a valid email'
                      },
                      decoration: InputDecoration(
                        icon: Icon(
                          Icons.code,
                          color: kPrimaryColor,
                        ),
                        hintText: "email",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  auth.loggedInStatus == Status.Sending
                      ? loading
                      : RoundedButton(
                          text: "Send",
                          press: sendEmail,
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
