import 'package:meet_your_mates/api/services/auth_service.dart';
import 'package:meet_your_mates/components/rounded_button.dart';
import 'package:meet_your_mates/components/text_field_container.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
//Services

//Utilities

//Screens
import 'package:meet_your_mates/screens/Validate/background.dart';
//Models

import '../../constants.dart';

class Validate extends StatefulWidget {
  @override
  _ValidateState createState() => _ValidateState();
}

class _ValidateState extends State<Validate> {
  final codeController = TextEditingController();

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
          )),
          RoundedButton(
              text: "Send Code",
              press: () {
                if (codeController.text != "") {
                  _validationCode = codeController.text;
                  auth.validateCode(_validationCode).then((response) => {
                        if (response['status'])
                          {
                            Navigator.pushReplacementNamed(
                                context, '/dashboard')
                          }
                      });
                } else {}
              }),
        ])))));
  }
}
