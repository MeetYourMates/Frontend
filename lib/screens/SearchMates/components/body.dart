import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart';

import 'package:meet_your_mates/screens/SearchMates/components/statefulwrapper.dart';
import 'package:meet_your_mates/screens/SearchMates/studentList.dart';
import 'background.dart';
import 'package:flutter/foundation.dart';

class Body extends StatefulWidget {
  final List queryResult;
  const Body({Key key, this.queryResult}) : super(key: key);
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  var logger = Logger();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

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
                        StudentList(widget.queryResult),
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
