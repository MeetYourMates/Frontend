import 'package:async/async.dart';
import 'package:meet_your_mates/api/models/courseProjects.dart';
import 'package:flutter/material.dart';
import 'package:meet_your_mates/components/error.dart';
import 'package:meet_your_mates/components/loading.dart';
//Services

//Utilities

//Constants
import 'package:provider/provider.dart';
import 'package:logger/logger.dart';
//Screens
import 'package:meet_your_mates/screens/Projects/background.dart';

//Models
import 'package:meet_your_mates/api/services/student_service.dart';
//Components

class Projects extends StatefulWidget {
  @override
  _ProjectsState createState() => _ProjectsState();
}

class _ProjectsState extends State<Projects> {
  final formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Projects"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.info),
              color: Colors.white,
              onPressed: () {},
            )
          ],
        ),
        body: Background(
          child: ProjectList(),
        ),
      ),
    );
  }
}

class ProjectList extends StatefulWidget {
  @override
  _ProjectListState createState() => _ProjectListState();
}

class _ProjectListState extends State<ProjectList> {
  var logger = Logger();
  final AsyncMemoizer _memoizerProjects = AsyncMemoizer();
  List<CourseProjects> projectsList = [];
  List<String> subjects = [];
  List<String> projects = [];

  ///**================================================================================================
  ///*                                         WIDGET BUILDER OF PROJECT LIST
  ///*===================================================================================================
  @override
  Widget build(BuildContext context) {
    StudentProvider _studentProvider = Provider.of<StudentProvider>(context);
    Future _fetchProjects() async {
      return _memoizerProjects.runOnce(() async {
        logger.d("_memoizerProjects Executed");
        List<CourseProjects> result =
            await _studentProvider.getProjects(_studentProvider.student.id);
        return result;
      });
    }

    return FutureBuilder<dynamic>(
        future: _fetchProjects(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return LoadingPage();
            default:
              if (snapshot.hasError)
                return ErrorShow(errorText: 'Error: ${snapshot.error}');
              else if ((snapshot.hasData)) {
                projectsList = snapshot.data;
                subjects.clear();
                projects.clear();
                //We clear the Universities List as, this fetch is runce every new update of the widget and we don't want to just add
                projectsList.forEach((project) {
                  subjects.addAll(project.getSubjectNames());
                  projects.addAll(project.getProjectNames());
                });
                //universityNames.value.remove("Select your University:");
                logger.d("Load Projects: " + projects.toString());
              } else {
                return ErrorShow(
                    errorText: "Unexpected error. Unable to Retrieve Projects");
              }

              return ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) => ProjectCard(
                  project: projects[index],
                  subject: subjects[index],
                ),
                shrinkWrap: true,
                itemCount: projects.length,
              );
          }
        });
  }
}

class ProjectCard extends StatelessWidget {
  final String project;
  final String subject;

  const ProjectCard({Key key, @required this.project, @required this.subject})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 21.0,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.account_balance,
                  size: 40.0,
                  color: Colors.blue,
                ),
              ),
              SizedBox(width: 24.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    this.project,
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    "Subject: " + this.subject,
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 12.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
