import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:meet_your_mates/api/models/courseAndStudents.dart';
import 'package:meet_your_mates/api/services/student_service.dart';
import 'package:meet_your_mates/components/error.dart';
import 'package:meet_your_mates/components/loading.dart';
import 'package:meet_your_mates/screens/SearchMates/courseList.dart';
import 'package:provider/provider.dart';

import 'background.dart';

class Body extends StatefulWidget {
  const Body({
    Key key,
  }) : super(key: key);
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  var logger = Logger(level: Level.info);

  StudentProvider _studentProvider;

  //Inicializa todo el FUTURE (debe inicializarse buera del build)
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //Consula los cursos de un estudiante (falta enviar id de estudiante como parametro)
    Future<List<CourseAndStudents>> _getCourses() async {
      _studentProvider = Provider.of<StudentProvider>(context, listen: false);
      logger.d(_studentProvider.student);
      List<CourseAndStudents> _courses = await _studentProvider.getStudentCourses(_studentProvider.student.id);
      logger.d("COURSES BE CAREFULL!!");
      logger.d(_courses);
      return _courses;
    }

    List<Widget> buildCourseList(List<CourseAndStudents> data) {
      List<Widget> _courses = [];
      for (CourseAndStudents course in data) {
        _courses.add(CourseList(
          queryResult: course,
        ));
      }
      return _courses;
    }

    return FutureBuilder<List<CourseAndStudents>>(
      future: _getCourses(),
      builder: (context, snapshot) {
        //REDO FUTURE BUILDER, AS THE OLD VERSION HAD THE TREE OF CONTEXT OUTSIDE DUE TO THE WAY IT RETURN!
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return LoadingPage();
          default:
            if (snapshot.hasError || snapshot.data.isEmpty)
              return ErrorShow(errorText: 'Error: ${snapshot.error}');
            else {
              //No Error
              //DEVOLVEMOS EL WIDGET ENCARGADO DE MOSTRAR LA INFORMACIÓN
              return SafeArea(
                child: Scaffold(
                  body: Background(
                    //child: CourseList(_courseQueryResult),
                    child: Container(
                      child: SingleChildScrollView(
                        child: Column(
                          children: buildCourseList(snapshot.data),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }
        }
      },
    );
  }
}
