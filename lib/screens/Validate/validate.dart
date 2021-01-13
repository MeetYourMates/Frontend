import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:logger/logger.dart';
import 'package:meet_your_mates/api/models/professor.dart';
import 'package:meet_your_mates/api/models/student.dart';
import 'package:meet_your_mates/api/models/user.dart';
import 'package:meet_your_mates/api/services/auth_service.dart';
import 'package:meet_your_mates/api/services/professor_service.dart';
import 'package:meet_your_mates/api/services/student_service.dart';
import 'package:meet_your_mates/api/services/user_service.dart';
import 'package:meet_your_mates/api/util/shared_preference.dart';
import 'package:meet_your_mates/components/rounded_button.dart';
import 'package:meet_your_mates/components/text_field_container.dart';
import 'package:meet_your_mates/screens/Validate/background.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';

//Models

import '../../constants.dart';

class Validate extends StatefulWidget {
  @override
  _ValidateState createState() => _ValidateState();
}

class _ValidateState extends State<Validate> {
  /// [form] Reactive FormGroup with Integrated Validators, each member of this group correspond to a Text Widget
  final form = FormGroup(
    {
      'code': FormControl(validators: [
        Validators.required,
        Validators.maxLength(7),
        Validators.minLength(7),
      ]),
    },
  );
  var logger = Logger();
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AuthProvider auth = Provider.of<AuthProvider>(context, listen: true);
    var loading = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[CircularProgressIndicator(), Text(" Checking ... Please wait")],
    );
    Future<void> checkValidation() async {
      logger.d("Check Validation Called");
      //Check if Server Validated, if True than retrieve Student
      User user = Provider.of<UserProvider>(context, listen: false).user;
      final Future<Map<String, dynamic>> successfulMessage = auth.login(user.email, user.password);

      //Callback to message recieved after login auth
      successfulMessage.then((response) {
        if (response['status'] == 0) {
          //Validation Completed & Somehow GetStarted too!
          Student student = response['student'];
          Provider.of<StudentProvider>(context, listen: false).setStudent(student);
          EasyLoading.dismiss().then((value) => {
                Navigator.pushReplacementNamed(context, '/dashboardStudent'),
              });
          logger.d("Validated From SomeWhere Else!");
        } else if (response['status'] == 2) {
          //Let's Get Started not completed
          Student student = response['student'];
          Provider.of<StudentProvider>(context, listen: false).setStudent(student);
          //Navigator.pushReplacementNamed(context, '/getStartedStudent');
          EasyLoading.dismiss().then((value) => {
                Navigator.pushReplacementNamed(context, '/getStartedStudent'),
              });
          logger.d("Validated but --> Let's Get Started not completed!");
        } else if (response['status'] == 3) {
          //Validated and getStarted completed Dashboard Professor
          Professor professor = response['professor'];
          //Provider.of<StudentProvider>(context, listen: false).setPassword(student.user.password);
          Provider.of<ProfessorProvider>(context, listen: false).setProfessorWithUserWithPassword(professor);
          //Navigator.pushReplacementNamed(context, '/dashboardProfessor');
          EasyLoading.dismiss().then((value) => {
                Navigator.pushReplacementNamed(context, '/dashboardProfessor'),
              });
          logger.d("Logged In dashboard Professor!");
        } else if (response['status'] == 4) {
          //Validated but GetStarted Professor not Finished
          Professor professor = response['professor'];
          Provider.of<ProfessorProvider>(context, listen: false).setProfessorWithUserWithPassword(professor);
          //Navigator.pushReplacementNamed(context, '/getStartedProfessor');
          EasyLoading.dismiss().then((value) => {
                Navigator.pushReplacementNamed(context, '/getStartedProfessor'),
              });
          logger.d("Logged In getStartedProfessor not completed!");
        } else {
          //Not Validated
          //Remember to now user any other fields from Student other than user
          EasyLoading.dismiss().then((value) => {
                logger.d("Not Validated!"),
                Flushbar(
                  title: "Validation Failed",
                  message: "Not Verified Yet!",
                  duration: Duration(seconds: 3),
                ).show(context),
              });
        }
      });
    }

    void validateUser() {
      if (form.valid) {
        EasyLoading.show(
          status: 'loading...',
          maskType: EasyLoadingMaskType.black,
        ).then((value) {
          //

          logger.d("Valid Form");
          //We send the code to server and check if truly correct and based on that
          String code = this.form.control('code').value;
          logger.d("Valid Form 2 $code");
          auth.validateCode(code).then(
            (response) {
              logger.d("Validate Code then--> " + response['status'].toString());
              if (response['status']) {
                checkValidation();
              } else {
                //UnShow the Loader and FlushBar Incorrect Code...
                EasyLoading.dismiss().then(
                  (value) {
                    Flushbar(
                      title: "Validation Failed",
                      message: "Incorrect Code",
                      duration: Duration(seconds: 3),
                    ).show(context);
                  },
                );
              }
            },
          );
        });
      } else {
        logger.d("Form not filled");
        Flushbar(
          title: "Form not filled",
          message: "Please fill the form first!",
          duration: Duration(seconds: 3),
        ).show(context);
        form.markAllAsTouched();
      }
    }

    //* RESPONSIVE VALIDATE...
    Size size = MediaQuery.of(context).size * 0.95;
    return Scaffold(
      body: SafeArea(
        child: Background(
          child: Center(
            child: SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              child: Container(
                alignment: Alignment.center,
                constraints: BoxConstraints.tightForFinite(width: 400, height: size.height * 0.64),
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
                            "We are close to end!",
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
                            "Introduce the code that we just send to you email",
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
                        height: size.height * 0.08,
                        child: RoundedButton(
                          text: "Validate",
                          press: () => {
                            validateUser(),
                          },
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
                          text: "Logout",
                          press: () => {UserPreferences().removeUser(), Navigator.pushReplacementNamed(context, '/login')},
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
                        child: auth.loggedInStatus == Status.Authenticating
                            ? loading
                            : RoundedButton(
                                text: "Check Validated",
                                press: () => {
                                  EasyLoading.show(
                                    status: 'loading...',
                                    maskType: EasyLoadingMaskType.black,
                                  ).then((value) {
                                    //
                                    checkValidation();
                                  }),
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
