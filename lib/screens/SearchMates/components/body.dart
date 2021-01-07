import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:meet_your_mates/api/models/student.dart';
import 'package:meet_your_mates/api/models/courseAndStudents.dart';
import 'package:meet_your_mates/api/services/student_service.dart';
import 'package:meet_your_mates/screens/SearchMates/components/statefulwrapper.dart';
import 'package:meet_your_mates/screens/SearchMates/courseList.dart';
import 'package:provider/provider.dart';

import 'background.dart';

class Body extends StatefulWidget {
  const Body({Key key}) : super(key: key);
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  var logger = Logger();

  Future<List<dynamic>> _futureCourseQueryResult;
  List<CourseAndStudents> _courseQueryResult = [];

  StudentProvider _studentProvider;

  //Consula los cursos de un estudiante (falta enviar id de estudiante como parametro)
  Future<void> _getCourses() async {
    final List<CourseAndStudents> queryResult =
        await _studentProvider.getStudentCourses(_studentProvider.student.id);
    setState(
      () {
        debugPrint("Executed course search");
        if (queryResult != null) {
          debugPrint("Courses found");
          _courseQueryResult.addAll(queryResult);
        } else {
          print('Error retrieving courses');
        }
      },
    );
  }

  //Inicializa todo el FUTURE (debe inicializarse buera del build)
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _studentProvider = Provider.of<StudentProvider>(context, listen: false);

      _getCourses();
    });
  }

  @override
  Widget build(BuildContext context) {
    return StatefulWrapper(
      onInit: () {},
      //MANEJAMOS LAS VARIABLES FUTURAS
      child: FutureBuilder<List<Student>>(
        future: _futureCourseQueryResult,
        builder: (BuildContext context, AsyncSnapshot<List<Student>> snapshot) {
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

          //DEVOLVEMOS EL WIDGET ENCARGADO DE MOSTRAR LA INFORMACIÓN
          return SafeArea(
            child: Scaffold(
              body: Background(
                //child: CourseList(_courseQueryResult),
                child: Container(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        for (CourseAndStudents course in _courseQueryResult)
                          CourseList(course)
                      ],
                    ),
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
