import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart';

import 'package:meet_your_mates/screens/SearchMates/components/statefulwrapper.dart';
import 'package:meet_your_mates/screens/SearchMates/studentList.dart';
import 'package:provider/provider.dart';
import 'background.dart';
import 'package:flutter/foundation.dart';
import 'package:meet_your_mates/api/util/shared_preference.dart';
import 'package:meet_your_mates/api/services/student_service.dart';

class Body extends StatefulWidget {
  const Body({Key key}) : super(key: key);
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  var logger = Logger();

  List _queryResult = [];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    StudentProvider _studentProvider = Provider.of<StudentProvider>(context);

    Future<void> _getStudents() async {
      final List queryResult = await _studentProvider.getCourseStudents();
      setState(
        () {
          debugPrint("Executed search");
          if (queryResult != null) {
            debugPrint("Students found");
            _queryResult.addAll(queryResult);
          } else {
            print('Error retrieving students');
          }
        },
      );
    }

    _getStudents();

    return StatefulWrapper(
      onInit: () {},
      child: SafeArea(
        child: Scaffold(
          body: Background(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Align(
                    alignment: Alignment.topCenter,
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: size.height * 0.05),
                        Text(
                          "Here are your class mates!",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 24),
                        ),
                        StudentList(_queryResult),
                        SizedBox(height: size.height * 0.03),
                      ],
                    ),
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
