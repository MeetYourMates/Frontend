import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:meet_your_mates/api/models/courseProjects.dart';
import 'package:meet_your_mates/api/services/student_service.dart';
import 'package:meet_your_mates/components/error.dart';
import 'package:meet_your_mates/components/loading.dart';
import 'package:meet_your_mates/screens/ProjectsSudent/projectListStudent.dart';
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
    Future<List<CourseProjects>> _getProjects() async {
      _studentProvider = Provider.of<StudentProvider>(context, listen: false);
      List<CourseProjects> _projects = await _studentProvider.getCourseProjects(_studentProvider.student.id);
      return _projects;
    }

    List<Widget> buildProjectList(List<CourseProjects> data) {
      List<Widget> _courses = [];
      for (CourseProjects course in data) {
        _courses.add(ProjectListStudent(
          queryResult: course,
        ));
      }
      return _courses;
    }

    return FutureBuilder<List<CourseProjects>>(
      future: _getProjects(),
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
                    child: Container(
                      child: SingleChildScrollView(
                        child: Column(
                          children: buildProjectList(snapshot.data),
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
