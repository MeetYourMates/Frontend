import 'package:flutter/material.dart';
import 'package:flushbar/flushbar.dart';
import 'package:async/async.dart';
import 'package:logger/logger.dart';
import 'package:meet_your_mates/api/services/student_service.dart';
import '../../../choices.dart' as choices;
import 'package:meet_your_mates/api/models/universities.dart';
import 'package:meet_your_mates/api/services/start_service.dart';
import 'package:meet_your_mates/components/direct_options.dart';
import 'package:meet_your_mates/components/multiple_options.dart';
import 'package:meet_your_mates/components/rounded_button.dart';
import 'package:provider/provider.dart';
import 'background.dart';
import 'package:flutter/foundation.dart';

class Body extends StatefulWidget {
  const Body({Key key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  var logger = Logger(level: Level.warning);
  final AsyncMemoizer _memoizerUniversities = AsyncMemoizer();
  final formKey = new GlobalKey<FormState>();
  String _university = "", _faculty = "", _degree = "";
  //Value Notifier with Initial Values
  ValueNotifier<List<String>> universityNames =
      ValueNotifier(["Select your University:"]);
  ValueNotifier<List<String>> facultyNames =
      ValueNotifier(["Select your Faculty:"]);
  ValueNotifier<List<String>> degreeNames =
      ValueNotifier(["Select your Degree:"]);
  bool enabled = false;
  bool chosenUni = false;
  bool chosenFaculty = false;
  bool chosenDegree = false;
  Universities universities = new Universities();
  ValueNotifier<List<Map<String, dynamic>>> _choicesSubjects = ValueNotifier([
    {"id": "Test", "name": "test", "group": "test"}
  ]);
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
      if (_university != "Select your University:" && _university != null) {
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
    StudentProvider _studentProvider = Provider.of<StudentProvider>(context);
    StartProvider start = Provider.of<StartProvider>(context, listen: false);
    Future _fetchUniversities() async {
      return _memoizerUniversities.runOnce(() async {
        logger.d("_memoizerUniversities Executed");
        Map<String, dynamic> status = await start.getStartedData();
        return status;
      });
    }

    var loading = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(),
        Text("We are getting you enrolled ... Please wait")
      ],
    );

    var doFlushbar = (String message) {
      Flushbar(
        title: "Oops!",
        message: message,
        duration: Duration(seconds: 3),
      ).show(context);
    };

    var loadchoicesSubjects = (String degreeId) {
      final Future<Map<String, dynamic>> successfulMessage =
          start.getSubjectData(degreeId);
      //Callback to message recieved after login auth
      successfulMessage.then((response) {
        if (response['status']) {
          _choicesSubjects.value.clear();
          _choicesSubjects.value = response['subjects'];
          logger.d("_choicesSubjects" + _choicesSubjects.value.toString());
          _toggleValidate();
        } else {
          Flushbar(
            title: "Failed",
            message: response['message'].toString(),
            duration: Duration(seconds: 3),
          ).show(context);
        }
      });
    };

    Future<bool> enrollStudents() async {
      bool enrollStatus = false;
      //For and Not ForEach because stupid dart makes the await call useless
      //and we loose syncronicity between the result and the code execution
      for (int i = 0; i < _subjects.length; i++) {
        Map<String, dynamic> response =
            await start.start(_subjects[i], _studentProvider.student.id);
        enrollStatus = enrollStatus || response['status'];
        logger.d("Subjects Do Start stateBool: " + enrollStatus.toString());
        logger.d("Enrolling in Selected Subject $i");
      }
      return enrollStatus;
    }

    void doStart() async {
      logger.d('university: $_university');
      logger.d('faculty: $_faculty');
      logger.d('degree: $_degree');
      logger.d('choicesSubjects: $_choicesSubjects');

      if (_university != "Select your university:" &&
          _faculty != "Select your faculty:" &&
          _degree != "Select your degree:" &&
          _university != null &&
          _faculty != null &&
          _degree != null &&
          _subjects.isNotEmpty) {
        //Execute Enrollment
        final bool enrollStatus = await enrollStudents();
        logger.d("enrollStudents Status: " + enrollStatus.toString());
        if (enrollStatus) {
          logger.d("Succesfully Enrolled and Launched Dashboard");
          Navigator.pushReplacementNamed(context, '/dashboard');
        } else {
          //Failed
          logger.d("Failed Enrollment in all Subjects!");
          doFlushbar("Failed Enrollment in all Subjects!");
        }
      } else {
        doFlushbar(
            "You must enter your universtity, faculty, degree and subjects first.");
      }
    }

    //var doStart = () async {};

    //Local Temperory Variable
    List<String> temp = new List<String>();
    Size size = MediaQuery.of(context).size;
    return FutureBuilder<dynamic>(
        future: _fetchUniversities(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            default:
              if (snapshot.hasError)
                return Text('Error: ${snapshot.error}');
              else if ((snapshot.hasData)) if (snapshot.data['status']) {
                //logger.d("Printing" + response['universities']);
                universities.universityList = snapshot.data['universities'];
                universityNames.value.addAll(universities.getUniversityNames());
                universityNames.value.remove("Select your University:");
                logger.d("Load Universities: " + universityNames.toString());
              } else {
                return Text('Unable to Retrieve Universities');
              }
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
                                        logger
                                            .d("University Changed: " + value),
                                        _toggleUniversity(),
                                        if (chosenUni)
                                          {
                                            //Clearing current degreeList and adding new Data
                                            temp.clear(),
                                            temp.addAll(universities
                                                .getUniversityByName(
                                                    _university)
                                                .getFacultyNames()),
                                            facultyNames.value.removeWhere(
                                                (item) =>
                                                    item !=
                                                    "Select your University:"),
                                            facultyNames.value.addAll(temp),
                                            logger.d("Faculties Name List: " +
                                                temp.join("/"))
                                          }
                                        else
                                          {
                                            //Changed back to not correct Option
                                            facultyNames.value.removeWhere(
                                                (item) =>
                                                    item !=
                                                    "Select your Faculty:"),
                                            degreeNames.value.removeWhere(
                                                (item) =>
                                                    item !=
                                                    "Select your Degree:"),
                                          }
                                      });
                            },
                            valueListenable: universityNames,
                            child: Container(),
                          ),
                          ValueListenableBuilder(
                            builder: (BuildContext context,
                                List<String> _facultNames, Widget child) {
                              // This builder will only get called when the _counter
                              // is updated.
                              return DirectOptions(
                                  title: "Faculty",
                                  elements: _facultNames,
                                  enable: chosenUni,
                                  onSelected: (value) => {
                                        _faculty = value,
                                        logger.d("Faculty Changed: " + value),
                                        _toggleFaculty(),
                                        if (chosenFaculty)
                                          {
                                            //Clearing current degreeList and adding new Data
                                            temp.clear(),
                                            temp.addAll(universities
                                                .getUniversityByName(
                                                    _university)
                                                .getFacultyByName(_faculty)
                                                .getDegreeNames()),
                                            degreeNames.value.removeWhere(
                                                (item) =>
                                                    item !=
                                                    "Select your Faculty:"),
                                            degreeNames.value.addAll(temp),
                                            logger.d("Degrees Name List: " +
                                                temp.join("/"))
                                          }
                                        else
                                          {
                                            //Changed back to not correct Option
                                            facultyNames.value.removeWhere(
                                                (item) =>
                                                    item !=
                                                    "Select your Faculty:"),
                                            degreeNames.value.removeWhere(
                                                (item) =>
                                                    item !=
                                                    "Select your Degree:"),
                                          }
                                      });
                            },
                            valueListenable: facultyNames,
                            child: Container(),
                          ),
                          ValueListenableBuilder(
                            builder: (BuildContext context,
                                List<String> _degreeNames, Widget child) {
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
                                            degreeNames.value[
                                                _degreeNames.indexOf(_degree)],
                                            id = universities
                                                .getUniversityByName(
                                                    _university)
                                                .getFacultyByName(_faculty)
                                                .getDegreeByName(_degree)
                                                .id,
                                            loadchoicesSubjects(id)
                                          }
                                        else
                                          {
                                            //Changed back to not correct Option
                                            facultyNames.value.removeWhere(
                                                (item) =>
                                                    item !=
                                                    "Select your Faculty:"),
                                            degreeNames.value.removeWhere(
                                                (item) =>
                                                    item !=
                                                    "Select your Degree:"),
                                          }
                                      });
                            },
                            valueListenable: degreeNames,
                            child: Container(),
                          ),
                          ValueListenableBuilder(
                            builder: (BuildContext context,
                                List<Map<String, dynamic>> _subjsList,
                                Widget child) {
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
                                        onSelected: (value) =>
                                            {_subjects = value},
                                      )));
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
              );
          }
        });
  }
}
