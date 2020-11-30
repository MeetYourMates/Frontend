import 'package:flutter/material.dart';
import 'package:flushbar/flushbar.dart';
import 'package:meet_your_mates/api/models/student.dart';
import 'package:meet_your_mates/api/models/universities.dart';
import 'package:meet_your_mates/api/services/start_service.dart';
import 'package:meet_your_mates/components/direct_options.dart';
import 'package:meet_your_mates/components/multiple_options.dart';
import 'package:meet_your_mates/components/rounded_button.dart';
import 'package:meet_your_mates/screens/GetStarted/components/statefulwrapper.dart';
import 'package:provider/provider.dart';
import 'background.dart';
import 'package:flutter/foundation.dart';

class Body extends StatefulWidget {
  final Student student;
  const Body({Key key, @required this.student}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final formKey = new GlobalKey<FormState>();
  String _university, _faculty, _degree;
  bool enabled = false;
  bool choiceUni = false;
  bool choiceFac = false;
  List<String> _subjects = [];

  validate() {
    if (_university != "Select your university" &&
        _faculty != "Select your campus" &&
        _degree != "Select your degree" &&
        _university != null &&
        _faculty != null &&
        _degree != null) {
      return true;
    } else {
      return false;
    }
  }

  validateUni() {
    if (_university != "Select your university" && _university != null) {
      return true;
    } else {
      return false;
    }
  }

  void _toggleUniversity() {
    setState(() {
      if (validateUni()) {
        choiceUni = true;
      } else {
        choiceFac = false;
      }
    });
  }

  validateFac() {
    if (_university != "Select your university" && _university != null) {
      return true;
    } else {
      return false;
    }
  }

  void _toggleFaculty() {
    setState(() {
      if (validateFac()) {
        choiceFac = true;
      } else {
        choiceFac = false;
      }
    });
  }

  void _toggleValidate() {
    setState(() {
      if (validate()) {
        enabled = true;
      } else {
        enabled = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    StartProvider start = Provider.of<StartProvider>(context);
    Universities universities;
    List<String> universityNames = ["Select your University:"];
    List<String> facultyNames = ["Select your Faculty:"];
    List<String> degreeNames = ["Select your Degree:"];
    var loading = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(),
        Text("We are getting you enrolled ... Please wait")
      ],
    );
    var doFlushbar = () {
      Flushbar(
        title: "Oops!",
        message:
            "You must enter your universtity, faculty, degree and subjects first.",
        duration: Duration(seconds: 3),
      ).show(context);
    };
    var loadUniversities = () {
      final Future<Map<String, dynamic>> successfulMessage =
          start.getStartedData();
      //Callback to message recieved after login auth
      successfulMessage.then((response) {
        if (response['status']) {
          universities = response['universities'];
          print(universities);
          universityNames.addAll(universities.getUniversityNames());
          print(universityNames);
        } else {
          Flushbar(
            title: "Failed Login",
            message: response['message']['message'].toString(),
            duration: Duration(seconds: 3),
          ).show(context);
        }
      });
    };
    var loadSubjects = (String degreeId) {
      //   final Future<Map<String, dynamic>> successfulMessage =
      //         start.;
      //     //Callback to message recieved after login auth
      //     successfulMessage.then((response) {
      //       if (response['status']) {
      //          universities = response['universities'];
      //       } else {
      //         Flushbar(
      //           title: "Failed Login",
      //           message: response['message']['message'].toString(),
      //           duration: Duration(seconds: 3),
      //         ).show(context);
    };
    var doStart = () {
      debugPrint('university: $_university');
      debugPrint('faculty: $_faculty');
      debugPrint('degree: $_degree');
      debugPrint('subjects: $_subjects');

      if (_university != "Select your university" &&
          _faculty != "Select your faculty" &&
          _degree != "Select your degree" &&
          _university != null &&
          _faculty != null &&
          _degree != null &&
          _subjects.isEmpty == true) {
      } else {
        doFlushbar();
      }
    };
    Size size = MediaQuery.of(context).size;
    return StatefulWrapper(
      onInit: () {
        loadUniversities();
      },
      child: SafeArea(
        child: Scaffold(
          body: Background(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: size.height * 0.03),

                  Image.asset(
                    "assets/images/getstarted.png",
                    width: size.width * 0.4,
                  ),
                  //loadUniversities(),
                  DirectOptions(
                      title: "University",
                      elements: universityNames,
                      enable: true,
                      onSelected: (value) => {
                            _university = value,
                            _toggleUniversity(),
                            facultyNames.addAll(universities
                                .getUniversityByName(_university)
                                .getFacultyNames())
                          }),
                  DirectOptions(
                      title: "Faculty",
                      enable: choiceUni,
                      elements: facultyNames,
                      onSelected: (value) => {
                            _faculty = value,
                            _toggleFaculty(),
                            degreeNames.addAll(universities
                                .getUniversityByName(_university)
                                .getFacultyByName(_faculty)
                                .getDegreeNames())
                          }),
                  DirectOptions(
                      title: "Degree",
                      enable: choiceFac,
                      elements: degreeNames,
                      onSelected: (value) =>
                          {_degree = value, _toggleValidate()}),
                  MultipleOptions(
                      title: "Subjects",
                      enabled: enabled,
                      onSelected: (value) => {_subjects = value},
                      notEnableTap: doFlushbar),
                  SizedBox(height: size.height * 0.03),
                  start.enrolledStatus == Status.GettingEnrolled
                      ? loading
                      : RoundedButton(
                          text: "START",
                          press: doStart,
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
