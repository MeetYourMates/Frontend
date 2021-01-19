import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:logger/logger.dart';
//Services
import 'package:meet_your_mates/api/services/auth_service.dart';
import 'package:meet_your_mates/api/util/route_uri.dart';
//Components
import 'package:meet_your_mates/components/already_have_an_account_check.dart';
import 'package:meet_your_mates/components/or_divider.dart';
import 'package:meet_your_mates/components/rounded_button.dart';
import 'package:meet_your_mates/components/social_icon.dart';
import 'package:meet_your_mates/components/text_field_container.dart';
//Screens
import 'package:meet_your_mates/screens/Register/background.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';

//Constants
import '../../constants.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final formKey = new GlobalKey<FormState>();
  //final formKey = new GlobalKey<FormState>();
  Logger logger = Logger();

  /// [Reactive Form]
  final form = FormGroup(
    {
      'password': FormControl(validators: [
        Validators.required,
        Validators.minLength(3),
      ]),
      'passwordConfirmation': FormControl(validators: [Validators.required]),
      'email': FormControl(validators: [
        Validators.required,
        Validators.email,
      ]),
      'name': FormControl(validators: [
        Validators.required,
        Validators.minLength(3),
      ]),
    },
    validators: [
      Validators.mustMatch('password', 'passwordConfirmation'),
    ],
  );

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
      if (form.valid) {
        String _email = this.form.control('email').value;
        String _password = this.form.control('password').value;
        String _name = this.form.control('name').value;
        EasyLoading.show(
          status: 'loading...',
          maskType: EasyLoadingMaskType.black,
        ).then((value) {
          //Function
          auth.register(_email, _password, _name).then((response) {
            if (response['status']) {
              //If status is ok than we make the user login and continue with the process
              EasyLoading.dismiss().then((value) => {
                    Navigator.pushReplacementNamed(context, RouteUri.login),
                  });
            } else {
              EasyLoading.dismiss().then((value) => {
                    Flushbar(
                      title: "Registration Failed",
                      message: response['message'].toString(),
                      duration: Duration(seconds: 10),
                    ).show(context),
                  });
            }
          });
        });
      } else {
        Flushbar(
          title: "Invalid form",
          message: "Please Fill The Form Properly",
          duration: Duration(seconds: 3),
        ).show(context);
      }
    };
    //* RESPONSIVE Register...
    Size size = MediaQuery.of(context).size * 0.95;
    return Scaffold(
      body: SafeArea(
        child: Background(
          child: Center(
            child: SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              child: Container(
                alignment: Alignment.center,
                constraints: BoxConstraints.tightForFinite(
                    width: 400, height: size.height * 0.95),
                child: ReactiveForm(
                  formGroup: this.form,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        width: size.width,
                        height: size.height * 0.32,
                        child: Image.asset(
                          "assets/icons/signup.png",
                          //width: size.width * 0.35,
                        ),
                      ),
                      SizedBox(
                        width: size.width,
                        height: size.height * 0.1,
                        child: TextFieldContainer(
                          child: ReactiveTextField(
                            formControlName: 'name',
                            autofocus: false,
                            cursorColor: kPrimaryColor,
                            decoration: InputDecoration(
                              icon: Icon(
                                Icons.face_rounded,
                                color: kPrimaryColor,
                              ),
                              hintText: "name",
                              border: InputBorder.none,
                            ),
                            validationMessages: (control) =>
                                {'required': 'The name must not be empty'},
                          ),
                        ),
                      ),
                      SizedBox(
                        width: size.width,
                        height: size.height * 0.1,
                        child: TextFieldContainer(
                          child: ReactiveTextField(
                            formControlName: 'email',
                            autofocus: false,
                            cursorColor: kPrimaryColor,
                            decoration: InputDecoration(
                              icon: Icon(
                                Icons.email_rounded,
                                color: kPrimaryColor,
                              ),
                              hintText: "email",
                              border: InputBorder.none,
                            ),
                            validationMessages: (control) => {
                              'required': 'The email must not be empty',
                              'email': 'The email value must be a valid email'
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        width: size.width,
                        height: size.height * 0.1,
                        child: TextFieldContainer(
                          child: ReactiveTextField(
                            formControlName: 'password',
                            obscureText: true,
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
                            validationMessages: (control) => {
                              'required': 'The password must not be empty',
                              'minLenght':
                                  'The password must have at least 3 characters'
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        width: size.width,
                        height: size.height * 0.1,
                        child: TextFieldContainer(
                          child: ReactiveTextField(
                            formControlName: 'passwordConfirmation',
                            obscureText: true,
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
                            validationMessages: (control) => {
                              'required':
                                  'The password confirm field must not be empty'
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        width: size.width,
                        height: size.height * 0.08,
                        child: auth.registeredInStatus == Status.Registering
                            ? loading
                            : RoundedButton(
                                text: "REGISTER", press: doRegister),
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
                        height: size.height * 0.03,
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: AlreadyHaveAnAccountCheck(
                            login: false,
                            press: () {
                              Navigator.pushReplacementNamed(
                                  context, RouteUri.login);
                            },
                          ),
                        ),
                      ),
                      //forgotLabel,
                      SizedBox(
                        width: size.width,
                        height: size.height * 0.01,
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: OrDivider(),
                        ),
                      ),
                      SizedBox(
                        width: size.width,
                        height: size.height * 0.1,
                        child: Row(
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
                        ),
                      )
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
