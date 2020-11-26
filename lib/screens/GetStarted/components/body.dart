import 'package:flutter/material.dart';
import 'package:flushbar/flushbar.dart';
import 'package:meet_your_mates/components/direct_options.dart';
import 'package:meet_your_mates/components/multiple_options.dart';
import 'package:meet_your_mates/components/rounded_button.dart';
import 'background.dart';
import 'package:flutter/foundation.dart';

class Body extends StatefulWidget {
  const Body({
    Key key,
  }) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final formKey = new GlobalKey<FormState>();
  String _university, _campus, _degree;
  List<String> _subjects = [];
  @override
  Widget build(BuildContext context) {
    var doStart = () {
      debugPrint('university: $_university');
      debugPrint('campus: $_campus');
      debugPrint('degree: $_degree');

      if (_university != "Select your university" &&
          _campus != "Select your campus" &&
          _degree != "Select your degree" &&
          _university != null &&
          _campus != null &&
          _degree != null) {
      } else {
        Flushbar(
          title: "Oops!",
          message: "You must enter your universtity, campus and degree first.",
          duration: Duration(seconds: 3),
        ).show(context);
      }
    };
    var selectSubjects = () {};
    Size size = MediaQuery.of(context).size;
    List<String> universities = [
      "Select your university",
      "UPC",
      "UB",
      "UAB",
      "UPF",
    ];
    List<String> campus = [
      "Select your campus",
      "EETAC",
      "ESAB",
      "ETSEIB",
    ];
    List<String> degrees = [
      "Select your degree",
      "Grau Enginyeria Telematica",
      "Grau Enginyeria Telecomunicacions",
      "Grau Enginyeria Aeroespacial",
    ];
    return SafeArea(
      child: Scaffold(
        body: Background(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: size.height * 0.03),
                Image.asset(
                  "assets/images/getstarted.png",
                  width: size.width * 0.6,
                ),
                SizedBox(height: size.height * 0.03),
                DirectOptions(
                    title: "University",
                    elements: universities,
                    onSelected: (value) => _university = value),
                DirectOptions(
                    title: "Campus",
                    elements: campus,
                    onSelected: (value) => _campus = value),
                DirectOptions(
                    title: "Degree",
                    elements: degrees,
                    onSelected: (value) => _degree = value),
                SizedBox(height: size.height * 0.03),
                MultipleOptions(title: "Subjects"),
                RoundedButton(
                  text: "START",
                  press: doStart,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
