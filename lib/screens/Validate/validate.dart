import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:meet_your_mates/api/models/student.dart';
import 'package:meet_your_mates/api/services/auth_service.dart';
import 'package:meet_your_mates/api/services/student_service.dart';
import 'package:meet_your_mates/api/util/shared_preference.dart';
import 'package:meet_your_mates/components/rounded_button.dart';
import 'package:meet_your_mates/components/text_field_container.dart';
import 'package:meet_your_mates/screens/Validate/background.dart';
import 'package:provider/provider.dart';

//Models

import '../../constants.dart';

class Validate extends StatefulWidget {
  @override
  _ValidateState createState() => _ValidateState();
}

class _ValidateState extends State<Validate> {
  final codeController = TextEditingController();
  var logger = Logger();
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var _validationCode;
    AuthProvider auth = Provider.of<AuthProvider>(context);
    var loading = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[CircularProgressIndicator(), Text(" Checking ... Please wait")],
    );
    var checkValidation = () {
      //Check if Server Validated, if True than retrieve Student
      final Future<Map<String, dynamic>> successfulMessage = auth.login(
          Provider.of<StudentProvider>(context, listen: false).student.user.email,
          Provider.of<StudentProvider>(context, listen: false).student.user.password);
      //Callback to message recieved after login auth
      successfulMessage.then((response) {
        if (response['status'] == 0) {
          //Validation Completed
          Student student = response['student'];
          Provider.of<StudentProvider>(context, listen: false).setStudent(student);
          Navigator.pushReplacementNamed(context, '/dashboard');
          logger.d("Validated From SomeWhere Else!");
        } else if (response['status'] == 2) {
          //Let's Get Started not completed
          Student student = response['student'];
          Provider.of<StudentProvider>(context, listen: false).setStudent(student);
          Navigator.pushReplacementNamed(context, '/getStarted');
          logger.d("Validated but --> Let's Get Started not completed!");
        } else {
          //Not Validated
          //Remember to now user any other fields from Student other than user
          logger.d("Not Validated!");
          Flushbar(
            title: "Validation Failed",
            message: "Not Verified Yet!",
            duration: Duration(seconds: 3),
          ).show(context);
        }
      });
    };
    return SafeArea(
      child: Scaffold(
        body: Background(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  "We are close to end!",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
                Text(
                  "Introduce the code that we just send to you email",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                TextFieldContainer(
                  child: TextFormField(
                    controller: codeController,
                    decoration: InputDecoration(
                      icon: Icon(
                        Icons.code,
                        color: kPrimaryColor,
                      ),
                      hintText: "Validation Code",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                RoundedButton(
                  text: "Validate",
                  press: () {
                    if (codeController.text != "") {
                      _validationCode = codeController.text;
                      auth.validateCode(_validationCode).then(
                            (response) => {
                              if (response['status'])
                                {
                                  checkValidation(),
                                }
                            },
                          );
                    } else {}
                  },
                ),
                RoundedButton(
                  text: "Logout",
                  press: () => {
                    UserPreferences().removeUser(),
                    Navigator.pushReplacementNamed(context, '/login')
                  },
                ),
                auth.loggedInStatus == Status.Authenticating
                    ? loading
                    : RoundedButton(
                        text: "Check Validated",
                        press: () => {
                          checkValidation(),
                        },
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
