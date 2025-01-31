import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:logger/logger.dart';
import 'package:meet_your_mates/api/models/student.dart';
import 'package:meet_your_mates/api/models/user.dart';
import 'package:meet_your_mates/api/services/auth_service.dart';
import 'package:meet_your_mates/api/services/student_service.dart';
import 'package:meet_your_mates/api/util/route_uri.dart';
import 'package:meet_your_mates/components/rounded_button.dart';
import 'package:meet_your_mates/components/text_field_container.dart';
//Screens
import 'package:meet_your_mates/screens/PasswordRecovery/background.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
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
      children: <Widget>[CircularProgressIndicator(), Text(" Checking ... Please wait")],
    );
    String email() => this.form.control('email').value;
    void sendEmail() {
      if (form.valid) {
        EasyLoading.show(
          status: 'loading...',
          maskType: EasyLoadingMaskType.black,
        ).then((value) {
          //We need to send the server the email and than see
          final Future<Map<String, dynamic>> successfulMessage = auth.recoverPassword(email());
          //Callback to message recieved after login auth
          successfulMessage.then(
            (response) {
              EasyLoading.dismiss().then((value) {
                //If the email does exist status = true
                if (response['status']) {
                  //Means the email is correct --> save it in student->user->email
                  Student student = new Student();
                  User usr = new User();
                  usr.email = email();
                  student.user = usr;
                  //We have the email in our student for further use in change password
                  Provider.of<StudentProvider>(context, listen: false).setStudentWithUser(student);
                  Navigator.pushReplacementNamed(context, RouteUri.changePassword);
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
              });
            },
          );
        });
      } else {
        toast('Email must not be empty...');
        form.markAllAsTouched();
      }
    }

    final alreadyHaveCodeLabel = Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        FlatButton(
          padding: EdgeInsets.all(0.0),
          child: Text("Already Have Code?", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.w500, fontSize: 24)),
          onPressed: () {
            //Future
            Navigator.pushReplacementNamed(context, RouteUri.changePassword);
          },
        )
      ],
    );
    //* RESPONSIVE Password Recovery...
    Size size = MediaQuery.of(context).size * 0.95;
    return Scaffold(
      body: SafeArea(
        child: Background(
          child: Center(
            child: SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              child: Container(
                alignment: Alignment.center,
                constraints: BoxConstraints.tightForFinite(width: 400, height: size.height * 0.60),
                child: ReactiveForm(
                  formGroup: this.form,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        width: size.width,
                        height: size.height * 0.16,
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: Text(
                            "Forgot Your Password?",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: kPrimaryColor),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: size.width,
                        height: size.height * 0.06,
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: Text(
                            "Introduce your email",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
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
                        height: size.height * 0.06,
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: alreadyHaveCodeLabel,
                        ),
                      ),
                      SizedBox(
                        width: size.width,
                        height: size.height * 0.08,
                        child: auth.loggedInStatus == Status.Sending
                            ? loading
                            : RoundedButton(
                                text: "Send",
                                press: sendEmail,
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
                        child: RoundedButton(
                          text: "Cancel",
                          press: () => {
                            Navigator.pushReplacementNamed(context, RouteUri.login),
                          },
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
