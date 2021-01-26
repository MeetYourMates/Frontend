import 'package:flutter/material.dart';
import 'package:meet_your_mates/api/models/courseProjects.dart';
import 'package:meet_your_mates/api/models/project.dart';
import 'package:meet_your_mates/api/services/appbar_service.dart';
import 'package:meet_your_mates/screens/TeamStudent/teams_student.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class ProjectListStudent extends StatelessWidget {
  final CourseProjects queryResult;
  const ProjectListStudent({
    this.queryResult,
  });
  @override
  Widget build(BuildContext context) {
    AppBarProvider _appBarProvider = Provider.of<AppBarProvider>(context, listen: false);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
        ),
        Container(
          height: 50,
          child: Align(
            alignment: Alignment.center,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.cyan[400],
                border: Border.all(
                  color: Colors.cyan[400],
                ),
                borderRadius: BorderRadius.all(Radius.circular(30.0)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  queryResult.subjectName,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ),
        ListView.builder(
          itemCount: queryResult.projects.length,
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemBuilder: (context, index) {
            Project project = queryResult.projects[index];
            return Card(
              child: ListTile(
                leading: Icon(
                  Icons.account_balance,
                  size: 40.0,
                  color: Colors.blue,
                ),
                title: Text(project.name != null ? project.name : "No name"),
                onTap: () {
                  // add new teams with a selectable groccery type view
                  pushNewScreen(
                    context,
                    screen: TeamsStudent(
                      projectId: project.id,
                      //BDD always store location as latitude, longitude!
                    ),
                    withNavBar: true, // OPTIONAL VALUE. True by default.
                    pageTransitionAnimation: PageTransitionAnimation.cupertino,
                  ).then(
                    (value) => {
                      //? To set the original Launching Screen appBarTitle, in this case we are coming back to meetings
                      _appBarProvider.setTitle("Projects"),
                    },
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
