import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import 'package:meet_your_mates/api/models/courseProjects.dart';
import 'package:meet_your_mates/api/services/professor_service.dart';

import 'package:meet_your_mates/components/error.dart';
import 'package:meet_your_mates/components/loading.dart';

import 'package:meet_your_mates/screens/ProjectsProfessor/projectList.dart';
import 'package:meet_your_mates/screens/ProjectsProfessor/addProject.dart';

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

  ProfessorProvider _professorProvider;

  //Inicializa todo el FUTURE (debe inicializarse buera del build)
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //Consula los cursos de un estudiante (falta enviar id de estudiante como parametro)
    Future<List<CourseProjects>> _getProjects() async {
      _professorProvider =
          Provider.of<ProfessorProvider>(context, listen: false);
      List<CourseProjects> _projects = await _professorProvider
          .getCourseProjects(_professorProvider.professor.id);
      return _projects;
    }

    List<Widget> buildProjectList(List<CourseProjects> data) {
      List<Widget> _courses = [];
      for (CourseProjects course in data) {
        _courses.add(ProjectList(
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
                  floatingActionButton: FloatingActionButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        new MaterialPageRoute(
                          builder: (context) => new AddProject(),
                        ),
                      );
                    },
                    child: Icon(Icons.add),
                    backgroundColor: Colors.cyan[400],
                  ),
                ),
              );
            }
        }
      },
    );
  }
}
