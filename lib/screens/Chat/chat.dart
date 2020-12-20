import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
//Services
import 'package:meet_your_mates/api/services/student_service.dart';
//Screens
import 'package:meet_your_mates/screens/Login/background.dart';
import 'package:provider/provider.dart';

//Models
//Components

class Chat extends StatefulWidget {
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  var logger = Logger();

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    StudentProvider _studentProvider = Provider.of<StudentProvider>(context);
    // ignore: unused_local_variable
    var loading = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(),
        Text(" Getting Users Online... Please wait")
      ],
    );

    // ignore: unused_local_variable
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Background(
          child: Container(),
        ),
      ),
    );
  }
}
