import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:meet_your_mates/api/services/student_service.dart';
import 'package:meet_your_mates/screens/SearchMates/components/statefulwrapper.dart';
import 'package:meet_your_mates/screens/SearchMates/studentList.dart';
import 'package:provider/provider.dart';

import 'background.dart';

class Body extends StatefulWidget {
  const Body({Key key}) : super(key: key);
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  var logger = Logger();

  Future<List<dynamic>> _futureQueryResult;
  List<dynamic> _queryResult = [];
  StudentProvider _studentProvider;

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

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _studentProvider = Provider.of<StudentProvider>(context, listen: false);

      _getStudents();
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return StatefulWrapper(
      onInit: () {},
      child: FutureBuilder<List>(
        future: _futureQueryResult,
        builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
          // ignore: unused_local_variable
          List<Widget> children;
          if (snapshot.hasData) {
            children = <Widget>[
              Icon(
                Icons.check_circle_outline,
                color: Colors.green,
                size: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text('Result: ${snapshot.data}'),
              )
            ];
          } else if (snapshot.hasError) {
            children = <Widget>[
              Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text('Error: ${snapshot.error}'),
              )
            ];
          } else {
            children = <Widget>[
              SizedBox(
                child: CircularProgressIndicator(),
                width: 60,
                height: 60,
              ),
              const Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('Awaiting result...'),
              )
            ];
          }
          return SafeArea(
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
          );
        },
      ),
    );
  }
}
