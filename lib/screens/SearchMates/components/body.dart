import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import 'package:meet_your_mates/screens/GetStarted/components/statefulwrapper.dart';
import 'background.dart';
import 'package:flutter/foundation.dart';

class Body extends StatefulWidget {
  const Body({Key key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  var logger = Logger();

  @override
  Widget build(BuildContext context) {
    //Local Temperory Variable
    List<String> temp = new List<String>();
    Size size = MediaQuery.of(context).size;
    return StatefulWrapper(
      onInit: () {},
      child: SafeArea(
        child: Scaffold(
          body: Background(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: size.height * 0.03),
                  SizedBox(height: size.height * 0.03),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
