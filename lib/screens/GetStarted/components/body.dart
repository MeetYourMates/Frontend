import 'package:flutter/material.dart';
import 'package:flushbar/flushbar.dart';
import 'package:meet_your_mates/api/models/student.dart';
import '../../../choices.dart' as choices;
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
  String _university = "", _faculty = "", _degree = "";
  //Value Notifier with Initial Values
  final ValueNotifier<List<String>> universityNames =
      ValueNotifier(["Select your University:"]);
  final ValueNotifier<List<String>> facultyNames =
      ValueNotifier(["Select your Faculty:"]);
  final ValueNotifier<List<String>> degreeNames =
      ValueNotifier(["Select your Degree:"]);
  bool enabled = false;
  bool chosenUni = false;
  bool chosenFaculty = false;
  bool chosenDegree = false;
  Universities universities = new Universities();
  //List<String> universityNames = ["Select your University:"];
  //List<String> facultyNames = ["Select your Faculty:"];
  //List<String> degreeNames = ["Select your Degree:"];
  final ValueNotifier<List<Map<String, dynamic>>> _choicesSubjects =
      ValueNotifier([
    {"id": "Test", "name": "test", "group": "test"}
  ]);
  //List<Map<String, dynamic>> _choicesSubjects =
  //    new List<Map<String, dynamic>>();
  List<String> _subjects = [];
  validateAll() {
    if (_university != "Select your University:" &&
        _faculty != "Select your Faculty:" &&
        _degree != "Select your Degree:" &&
        _university != null &&
        _faculty != null &&
        _degree != null) {
      return true;
    } else {
      return false;
    }
  }

  void _toggleUniversity() {
    setState(() {
      if (_university != "Select your university" && _university != null) {
        chosenUni = true;
      } else {
        chosenUni = false;
      }
    });
  }

  void _toggleFaculty() {
    setState(() {
      if (_faculty != "Select your Faculty:" && _faculty != null) {
        chosenFaculty = true;
      } else {
        chosenFaculty = false;
      }
    });
  }

  void _toggleDegree() {
    setState(() {
      if (_degree != "Select your Degree:" && _degree != null) {
        chosenDegree = true;
      } else {
        chosenDegree = false;
      }
    });
  }

  void _toggleValidate() {
    setState(() {
      if (validateAll()) {
        enabled = true;
      } else {
        enabled = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    StartProvider start = Provider.of<StartProvider>(context);
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
            "You must enter your universtity, faculty, degree and choicesSubjects first.",
        duration: Duration(seconds: 3),
      ).show(context);
    };
    var loadUniversities = () {
      final Future<Map<String, dynamic>> successfulMessage =
          start.getStartedData();
      //Callback to message recieved after login auth
      successfulMessage.then((response) {
        if (response['status']) {
          //print("Printing" + response['universities']);
          universities.universityList = response['universities'];
          universityNames.value.addAll(universities.getUniversityNames());
        } else {
          Flushbar(
            title: "Failed",
            message: response['message']['message'].toString(),
            duration: Duration(seconds: 3),
          ).show(context);
        }
      });
    };
    var startEnrollment = (String subjectId, String studentId) {
      //SubjectName SubjectId student
      final Future<Map<String, dynamic>> successfulMessage =
          start.start(subjectId, studentId);
      //Callback to message recieved after login auth
      successfulMessage.then((response) {
        if (response['status']) {
          //print("Printing" + response['universities']);
          universities.universityList = response['universities'];
          universityNames.value.addAll(universities.getUniversityNames());
        } else {
          Flushbar(
            title: "Failed",
            message: response['message']['message'].toString(),
            duration: Duration(seconds: 3),
          ).show(context);
        }
      });
    };
    var loadchoicesSubjects = (String degreeId) {
      final Future<Map<String, dynamic>> successfulMessage =
          start.getSubjectData(degreeId);
      //Callback to message recieved after login auth
      successfulMessage.then((response) {
        if (response['status']) {
          _choicesSubjects.value.clear();
          _choicesSubjects.value = response['subjects'];
          print("_choicesSubjects" + _choicesSubjects.value.toString());
          _toggleValidate();
        } else {
          Flushbar(
            title: "Failed",
            message: response['message']['message'].toString(),
            duration: Duration(seconds: 3),
          ).show(context);
        }
      });
    };
    var doStart = () {
      debugPrint('university: $_university');
      debugPrint('faculty: $_faculty');
      debugPrint('degree: $_degree');
      debugPrint('choicesSubjects: $_choicesSubjects');

      if (_university != "Select your university" &&
          _faculty != "Select your faculty" &&
          _degree != "Select your degree" &&
          _university != null &&
          _faculty != null &&
          _degree != null &&
          _subjects.isNotEmpty) {
        //Execute Enrollment
        _subjects.forEach((_subjId) {
          startEnrollment(_subjId, widget.student.id);
          print("Subject On Each: " +
              _subjId +
              " For Student: " +
              widget.student.id);
        });
      } else {
        doFlushbar();
      }
    };

    //Local Temperory Variable
    List<String> temp = new List<String>();
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
                  ValueListenableBuilder(
                    builder: (BuildContext context,
                        List<String> _universityNames, Widget child) {
                      // This builder will only get called when the _counter
                      // is updated.
                      return DirectOptions(
                          title: "University",
                          elements: _universityNames,
                          enable: true,
                          onSelected: (value) => {
                                _university = value,
                                print("University Changed: " + value),
                                _toggleUniversity(),
                                if (chosenUni)
                                  {
                                    //Clearing current degreeList and adding new Data
                                    temp.clear(),
                                    temp.addAll(universities
                                        .getUniversityByName(_university)
                                        .getFacultyNames()),
                                    facultyNames.value.removeWhere((item) =>
                                        item != "Select your University:"),
                                    facultyNames.value.addAll(temp),
                                    print("Faculties Name List: " +
                                        temp.join("/"))
                                  }
                                else
                                  {
                                    //Changed back to not correct Option
                                    facultyNames.value.removeWhere((item) =>
                                        item != "Select your Faculty:"),
                                    degreeNames.value.removeWhere((item) =>
                                        item != "Select your Degree:"),
                                  }
                              });
                    },
                    valueListenable: universityNames,
                    child: Container(),
                  ),
                  ValueListenableBuilder(
                    builder: (BuildContext context, List<String> _facultNames,
                        Widget child) {
                      // This builder will only get called when the _counter
                      // is updated.
                      return DirectOptions(
                          title: "Faculty",
                          elements: _facultNames,
                          enable: chosenUni,
                          onSelected: (value) => {
                                _faculty = value,
                                print("Faculty Changed: " + value),
                                _toggleFaculty(),
                                if (chosenFaculty)
                                  {
                                    //Clearing current degreeList and adding new Data
                                    temp.clear(),
                                    temp.addAll(universities
                                        .getUniversityByName(_university)
                                        .getFacultyByName(_faculty)
                                        .getDegreeNames()),
                                    degreeNames.value.removeWhere((item) =>
                                        item != "Select your Faculty:"),
                                    degreeNames.value.addAll(temp),
                                    print(
                                        "Degrees Name List: " + temp.join("/"))
                                  }
                                else
                                  {
                                    //Changed back to not correct Option
                                    facultyNames.value.removeWhere((item) =>
                                        item != "Select your Faculty:"),
                                    degreeNames.value.removeWhere((item) =>
                                        item != "Select your Degree:"),
                                  }
                              });
                    },
                    valueListenable: facultyNames,
                    child: Container(),
                  ),
                  ValueListenableBuilder(
                    builder: (BuildContext context, List<String> _degreeNames,
                        Widget child) {
                      // This builder will only get called when the _counter
                      // is updated.
                      var id;
                      return DirectOptions(
                          title: "Degree",
                          elements: _degreeNames,
                          enable: chosenFaculty,
                          onSelected: (value) => {
                                _degree = value,
                                _toggleDegree(),
                                if (chosenDegree)
                                  {
                                    //Here we call for choicesSubjects and show gettingEnrolled Status!
                                    //Find the Degreeid from name
                                    degreeNames
                                        .value[_degreeNames.indexOf(_degree)],
                                    id = universities
                                        .getUniversityByName(_university)
                                        .getFacultyByName(_faculty)
                                        .getDegreeByName(_degree)
                                        .id,
                                    loadchoicesSubjects(id)
                                  }
                                else
                                  {
                                    //Changed back to not correct Option
                                    facultyNames.value.removeWhere((item) =>
                                        item != "Select your Faculty:"),
                                    degreeNames.value.removeWhere((item) =>
                                        item != "Select your Degree:"),
                                  }
                              });
                    },
                    valueListenable: degreeNames,
                    child: Container(),
                  ),
                  ValueListenableBuilder(
                    builder: (BuildContext context,
                        List<Map<String, dynamic>> _subjsList, Widget child) {
                      // This builder will only get called when the _counter
                      // is updated.
                      return AbsorbPointer(
                          absorbing: !chosenDegree,
                          child: Opacity(
                              opacity: chosenDegree ? 1 : 0.35,
                              child: MultipleOptions(
                                  title: "Subjects",
                                  elements: _subjsList != null
                                      ? _subjsList
                                      : choices.subjects,
                                  enabled: chosenDegree,
                                  onSelected: (value) => {_subjects = value},
                                  notEnableTap: doFlushbar)));
                    },
                    valueListenable: _choicesSubjects,
                    child: Container(),
                  ),
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
