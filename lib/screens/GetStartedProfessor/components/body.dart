import 'dart:async';

import 'package:another_flushbar/flushbar.dart';
import 'package:async/async.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:logger/logger.dart';
import 'package:meet_your_mates/api/models/universities.dart';
import 'package:meet_your_mates/api/services/start_service.dart';
import 'package:meet_your_mates/api/services/professor_service.dart';
import 'package:meet_your_mates/components/direct_options.dart';
import 'package:meet_your_mates/components/error.dart';
import 'package:meet_your_mates/components/loading.dart';
import 'package:meet_your_mates/components/multiple_options.dart';
import 'package:meet_your_mates/components/rounded_button.dart';
import 'package:provider/provider.dart';

import 'background.dart';

class Body extends StatefulWidget {
  const Body({Key key, @required this.size}) : super(key: key);
  final Size size;
  @override
  _BodyState createState() => _BodyState();
}

/// -----------------------------------------------------------------------------------------------------------------------
///*                                   GET STARTED LOGIC BODY!
///-----------------------------------------------------------------------------------------------------------------------**/
class _BodyState extends State<Body> {
  /// [logger] to logg all of the logs in console prettily!
  var logger = Logger(level: Level.error);

  /// [_memoizerUniversities] to recieve all of the university from server just one
  /// all of the other runs it just gets data from local ram.
  final AsyncMemoizer _memoizerUniversities = AsyncMemoizer();

  ///[_university] and [_faculty] and [_degree] are used, when a choosen item is changed.
  ///it is saved here, for easier conditional chekcing if the next widget is hidden or shown, check down below!
  String _university = "", _faculty = "", _degree = "";

  /// [ValueNotifier] Value Notifier with Initial Values which only rebuilds the
  /// widgets it is used
  //ValueNotifier<List<String>> universityNames = ValueNotifier(["Select your University:"]);
  ValueNotifier<List<String>> facultyNames =
      ValueNotifier(["Select your Faculty:"]);
  List<String> universityNames = ["Select your University:"];
  ValueNotifier<List<String>> degreeNames =
      ValueNotifier(["Select your Degree:"]);
  ValueNotifier<List<Map<String, dynamic>>> _choicesSubjects = ValueNotifier([
    {"id": "Test", "name": "test", "group": "test"}
  ]);

  /// [universities] is used to store the universities Response Obtained
  Universities universities = new Universities();
  List<String> _subjects = [];

  /// [validateAll] Validates if the corresponding variables have a valid value!
  validateAll() {
    if (_university != "Select your University:" &&
        _faculty != "Select your Faculty:" &&
        _degree != "Select your Degree:" &&
        _university != null &&
        _faculty != null &&
        _degree != null &&
        _university.isNotEmpty &&
        _faculty.isNotEmpty &&
        _degree.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  ///**================================================================================================
  ///*                                         WIDGET BUILDER OF GETSTARTED
  ///*===================================================================================================
  @override
  Widget build(BuildContext context) {
    ProfessorProvider _professorProvider =
        Provider.of<ProfessorProvider>(context, listen: false);
    StartProvider _start = Provider.of<StartProvider>(context, listen: true);
    Future _fetchUniversities() async {
      return _memoizerUniversities.runOnce(() async {
        logger.d("_memoizerUniversities Executed");
        Map<String, dynamic> result = await _start
            .getStartedData(_professorProvider.professor.user.token);
        return result;
      });
    }

    /*----------------------------------------------
     **              loading
     *? Builds the loading widget?
     *@param none
     *@return Row
     *---------------------------------------------**/
    Row loading = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(),
        Text("We are getting you enrolled ... Please wait")
      ],
    );

    /*----------------------------------------------
     **              doFlushbar
     *? Shows Flusbar with a custom message?
     *@param message String
     *@return null
     *---------------------------------------------**/
    Null Function(String message) doFlushbar = (String message) {
      Flushbar(
        title: "Oops!",
        message: message,
        duration: Duration(seconds: 3),
      ).show(context);
    };

    /*----------------------------------------------
     **              loadchoicesSubjects
     *?  When a user has selected a degree, this loads the subjects of this degree from server?
     *@param degreeId String
     *@return null
     *---------------------------------------------**/
    Null Function(String degreeId) loadchoicesSubjects = (String degreeId) {
      final Future<Map<String, dynamic>> successfulMessage =
          _start.getSubjectData(degreeId);
      //Callback to message recieved after login auth
      successfulMessage.then((response) {
        if (response['status']) {
          _choicesSubjects.value.clear();
          _choicesSubjects.value = response['subjects'];
          EasyLoading.dismiss().then((value) => {
                logger.d("_choicesSubjects" + _choicesSubjects.value.toString())
              });
        } else {
          EasyLoading.dismiss().then((value) => {
                Flushbar(
                  title: "Failed",
                  message: response['message'].toString(),
                  duration: Duration(seconds: 3),
                ).show(context),
              });
        }
      });
    };

    /*----------------------------------------------
     **              enrollStudent
     *?  Asynchronous function, which is only called by the do start function, when all of the choosen fields are valid
     *@param none
     *@return status bool
     *---------------------------------------------**/
    Future<bool> enrollProfessor() async {
      bool enrollStatus = false;

      ///[For loop] and Not [ForEach] because stupid dart makes the [await call useless]
      ///and we loose [syncronicity] between the result and the code execution
      for (int i = 0; i < _subjects.length; i++) {
        Map<String, dynamic> response = await _start.startProfessor(
            _subjects[i],
            _professorProvider.professor.id,
            _university,
            _degree);
        enrollStatus = enrollStatus || response['status'];
        if (response['status']) {
          //Correctly Enrolled
          _professorProvider.setProfessorWithUser(response['professor']);
        }
        logger.d("Subjects Do Start stateBool: " + enrollStatus.toString());
        logger.d("Enrolling in Selected Subject $i");
      }
      return enrollStatus;
    }

    /*----------------------------------------------
     **              do start
     *?  When a user has selected university, faculty, degree and subjects. This Function enrolls him/her?
     *@param none
     *@return void
     *---------------------------------------------**/
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
        EasyLoading.show(
          status: 'loading...',
          maskType: EasyLoadingMaskType.black,
        ).then((value) {
          //Execute Enrollment
          //final bool enrollStatus = await enrollStudents();
          enrollProfessor().then((enrollStatus) {
            //Enroll
            logger.d("enrollStudents Status: " + enrollStatus.toString());
            if (enrollStatus) {
              EasyLoading.dismiss().then((value) {
                logger.d("Succesfully Enrolled and Launched Dashboard");
                Navigator.pushReplacementNamed(context, '/dashboardProfessor');
              });
            } else {
              //Failed
              EasyLoading.dismiss().then((value) {
                logger.d("Failed Enrollment in all Subjects!");
                doFlushbar("Failed Enrollment in all Subjects!");
              });
            }
          });
        });
      } else {
        doFlushbar(
            "You must choose your universtity, faculty, degree and subjects first...");
      }
    }

    /*----------------------------------------------
     **              universityDirectOptions
     *?  Builds the University Widget with DirectOption and Title?
     *@param none
     *@return widget
     *---------------------------------------------**/
    Widget universityDirectOptions = DirectOptions(
      title: "University",
      sizeDirectSelect: new Size(widget.size.width, widget.size.height * 0.08),
      sizeText: new Size(widget.size.width, widget.size.height * 0.06),
      elements: universityNames,
      isEnabled: true,
      onItemSelected: (value) => {
        _university = value,
        logger.d("University Changed: " + value),
        if (_university != "Select your University:" &&
            _university != null &&
            _university.isNotEmpty)
          {
            facultyNames.value =
                universities.getUniversityByName(_university).getFacultyNames()
          }
      },
    );
    /*----------------------------------------------
     **              facultyDirectOptions
     *?  Builds the faculty Widget with DirectOption and Title?
     *@param none
     *@return widget
     *---------------------------------------------**/
    Widget facultyDirectOption = ValueListenableBuilder(
      builder: (BuildContext context, List<String> _facultNames, Widget child) {
        // This builder will only get called when the _counter
        // is updated.
        return DirectOptions(
          key: UniqueKey(),
          title: "Faculty",
          sizeDirectSelect:
              new Size(widget.size.width, widget.size.height * 0.08),
          sizeText: new Size(widget.size.width, widget.size.height * 0.06),
          elements: _facultNames,
          isEnabled: (_university != "Select your University:" &&
              _university != null &&
              _university.isNotEmpty),
          onItemSelected: (value) => {
            _faculty = value,
            logger.d("Faculty Changed: " + value),
            _choicesSubjects.value.clear(),
            if (_faculty != "Select your Faculty:" &&
                _faculty != null &&
                _faculty.isNotEmpty)
              {
                //Clearing current degreeList and adding new Data
                degreeNames.value = universities
                    .getUniversityByName(_university)
                    .getFacultyByName(_faculty)
                    .getDegreeNames()
              }
          },
        );
      },
      valueListenable: facultyNames,
      child: ErrorShow(
          errorText: "Unexpected error occured, Please Restart the App"),
    );
    /*----------------------------------------------
     **              degreeDirectOptions
     *?  Builds the degree Widget with DirectOption and Title?
     *@param none
     *@return widget
     *---------------------------------------------**/
    Widget degreeDegreeOption = ValueListenableBuilder(
      builder: (BuildContext context, List<String> _degreeNames, Widget child) {
        // This builder will only get called when the _counter
        // is updated.
        return DirectOptions(
          title: "Degree",
          sizeDirectSelect:
              new Size(widget.size.width, widget.size.height * 0.08),
          sizeText: new Size(widget.size.width, widget.size.height * 0.06),
          elements: _degreeNames,
          isEnabled: (_faculty != "Select your Faculty:" &&
              _faculty != null &&
              _faculty.isNotEmpty),
          onItemSelected: (value) => {
            _degree = value,
            if (_degree != "Select your Degree:" &&
                _degree != null &&
                _degree.isNotEmpty)
              {
                EasyLoading.show(
                  status: 'loading...',
                  maskType: EasyLoadingMaskType.black,
                ),
                //Here we make a request to server for Subjects
                loadchoicesSubjects(universities
                    .getUniversityByName(_university)
                    .getFacultyByName(_faculty)
                    .getDegreeByName(_degree)
                    .id)
              }
          },
        );
      },
      valueListenable: degreeNames,
      child: ErrorShow(
          errorText: "Unexpected error occured, Please Restart the App"),
    );
    Widget subjectMultipleOption = ValueListenableBuilder(
      builder: (BuildContext context, List<Map<String, dynamic>> _subjsList,
          Widget child) {
        // This builder will only get called when the _counter
        // is updated.
        bool isActive = validateAll();
        return AbsorbPointer(
          absorbing: !isActive,
          child: Opacity(
            opacity: isActive ? 1 : 0.35,
            child: MultipleOptions(
              key: UniqueKey(),
              title: "Subjects",
              elements: _subjsList,
              onSelected: (value) => {_subjects = value},
              sizeMultiSelect:
                  new Size(widget.size.width, widget.size.height * 0.08),
              sizeText: new Size(widget.size.width, widget.size.height * 0.06),
            ),
          ),
        );
      },
      valueListenable: _choicesSubjects,
      child: ErrorShow(
          errorText: "Unexpected error occured, Please Restart the App"),
    );
    //Local Temperory Variable
    //List<String> temp = <String>[];

    ///*------------------------------------------------------------------------------------------------
    ///*                              Build the UI of GetStarted
    ///*------------------------------------------------------------------------------------------------**/
    ///[_fetchUniversities --> FutureBuilder] Build the Screen based on Response from Server
    return FutureBuilder<dynamic>(
        future: _fetchUniversities(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return LoadingPage();
            default:
              if (snapshot.hasError)
                return ErrorShow(errorText: 'Error: ${snapshot.error}');
              else if ((snapshot.hasData)) if (snapshot.data['status']) {
                //logger.d("Printing" + response['universities']);

                universities.universityList = snapshot.data['universities'];
                universityNames.clear();
                //We clear the Universities List as, this fetch is runce every new update of the widget and we don't want to just add
                universityNames.addAll(universities.getUniversityNames());
                //universityNames.value.remove("Select your University:");
                logger.d("Load Universities: " + universityNames.toString());
              } else {
                return ErrorShow(
                    errorText:
                        "Unexpected error. Unable to Retrieve Universities");
              }
              return SafeArea(
                child: Background(
                  child: SingleChildScrollView(
                    physics: NeverScrollableScrollPhysics(),
                    child: Container(
                      alignment: Alignment.center,
                      constraints: BoxConstraints.tightForFinite(
                          width: 600, height: widget.size.height * 0.95),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          //* GET STARTED IMAGE WIDGET
                          SizedBox(
                            width: widget.size.width,
                            height: widget.size.height * 0.2,
                            child: Image.asset(
                              "assets/images/getstarted.png",
                            ),
                          ),
                          /**============================================
                           **               UNIVERSITY DIRECT OPTIONS
                           *=============================================**/
                          universityDirectOptions,
                          /**============================================
                           **               Faculty DIRECT OPTIONS
                           *=============================================**/
                          facultyDirectOption,
                          /**============================================
                           **               Degree DIRECT OPTIONS
                           *=============================================**/
                          degreeDegreeOption,
                          /**============================================
                           **               SUBJECTS MULTIPLE OPTIONS
                           *=============================================**/
                          subjectMultipleOption,
                          /**============================================
                           **        DYNAMIC SPACER 
                           *=============================================**/
                          SizedBox(
                            width: widget.size.width,
                            height: widget.size.height * 0.01,
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child:
                                  SizedBox(height: 6, width: widget.size.width),
                            ),
                          ),
                          /**============================================
                           **        Do Start Button
                           *=============================================**/
                          SizedBox(
                            width: widget.size.width,
                            height: widget.size.height * 0.08,
                            child:
                                _start.enrolledStatus == Status.GettingEnrolled
                                    ? loading
                                    : RoundedButton(
                                        text: "START",
                                        press: doStart,
                                      ),
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
