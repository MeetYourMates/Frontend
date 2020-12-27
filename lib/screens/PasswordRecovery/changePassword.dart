import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:logger/logger.dart';
import 'package:meet_your_mates/api/services/auth_service.dart';
import 'package:meet_your_mates/api/services/student_service.dart';
import 'package:meet_your_mates/components/rounded_button.dart';
import 'package:meet_your_mates/components/text_field_container.dart';
//Screens
import 'package:meet_your_mates/screens/PasswordRecovery/background.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';

//Models

import '../../constants.dart';

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  /// [form] Reactive FormGroup with Integrated Validators, each member of this group correspond to a Text Widget
  final form = FormGroup(
    {
      'code': FormControl(validators: [
        Validators.required,
        Validators.maxLength(7),
        Validators.minLength(7),
      ]),
      'password': FormControl(validators: [Validators.required]),
      'passwordConfirmation': FormControl(validators: [Validators.required]),
    },
    validators: [
      Validators.mustMatch('password', 'passwordConfirmation'),
    ],
  );

  ///[logger] Logger to Debug the Application
  var logger = Logger();

  /// [build] Where this Widget UI is Built
  @override
  Widget build(BuildContext context) {
    AuthProvider auth = Provider.of<AuthProvider>(context);
    var loading = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[CircularProgressIndicator(), Text(" Checking ... Please wait")],
    );

    void _accept() {
      if (form.valid) {
        EasyLoading.show(
          status: 'loading...',
          maskType: EasyLoadingMaskType.black,
        ).then((value) {
          //
          String email = Provider.of<StudentProvider>(context, listen: false).student.user.email;
          String code = this.form.control('code').value;
          String password = this.form.control('password').value;
          //We need to send the server the email and than see
          final Future<Map<String, dynamic>> successfulMessage =
              auth.changePassword(code, email, password);
          //Callback to message recieved after login auth
          successfulMessage.then(
            (response) {
              EasyLoading.dismiss().then((value) {
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
              });
            },
          );
        });
      } else {
        toast("Please form completly...");
      }
    }

    //* RESPONSIVE ChANGE PASSWORD...
    Size size = MediaQuery.of(context).size * 0.95;
    return Scaffold(
      body: SafeArea(
        child: Background(
          child: Center(
            child: SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              child: Container(
                alignment: Alignment.center,
                constraints: BoxConstraints.tightForFinite(width: 400, height: size.height * 0.81),
                child: ReactiveForm(
                  formGroup: this.form,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        width: size.width,
                        height: size.height * 0.20,
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: Text(
                            "Reset Your Password?",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 24, color: kPrimaryColor),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: size.width,
                        height: size.height * 0.06,
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: Text(
                            "Introduce your recieved code",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: size.width,
                        height: size.height * 0.12,
                        child: TextFieldContainer(
                          child: ReactiveTextField(
                            formControlName: 'code',
                            autofocus: false,
                            cursorColor: kPrimaryColor,
                            decoration: InputDecoration(
                              icon: Icon(
                                Icons.code_sharp,
                                color: kPrimaryColor,
                              ),
                              hintText: "code",
                              border: InputBorder.none,
                            ),
                            validationMessages: (control) => {
                              'required': 'The code must not be empty',
                              'maxLength': 'The code can only be 7 characters long',
                              'minLength': 'The code has to be atleast 7 characters long'
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        width: size.width,
                        height: size.height * 0.12,
                        child: TextFieldContainer(
                          child: ReactiveTextField(
                            formControlName: 'password',
                            autofocus: false,
                            cursorColor: kPrimaryColor,
                            decoration: InputDecoration(
                              icon: Icon(
                                Icons.code_sharp,
                                color: kPrimaryColor,
                              ),
                              hintText: "password",
                              border: InputBorder.none,
                            ),
                            validationMessages: (control) =>
                                {'required': 'The password field must not be empty'},
                          ),
                        ),
                      ),
                      SizedBox(
                        width: size.width,
                        height: size.height * 0.12,
                        child: TextFieldContainer(
                          child: ReactiveTextField(
                            formControlName: 'passwordConfirmation',
                            autofocus: false,
                            cursorColor: kPrimaryColor,
                            decoration: InputDecoration(
                              icon: Icon(
                                Icons.code_sharp,
                                color: kPrimaryColor,
                              ),
                              hintText: "Retype Password",
                              border: InputBorder.none,
                            ),
                            validationMessages: (control) =>
                                {'required': 'The password confirm field must not be empty'},
                          ),
                        ),
                      ),
                      SizedBox(
                        width: size.width,
                        height: size.height * 0.08,
                        child: auth.loggedInStatus == Status.Sending
                            ? loading
                            : RoundedButton(
                                text: "Accept",
                                press: _accept,
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
                            Navigator.pushReplacementNamed(context, '/login'),
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
