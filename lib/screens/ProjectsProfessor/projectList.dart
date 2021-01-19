import 'package:flutter/material.dart';
import 'package:meet_your_mates/api/models/courseProjects.dart';
import 'package:meet_your_mates/api/models/project.dart';
import 'package:provider/provider.dart';

class ProjectList extends StatelessWidget {
  final CourseProjects queryResult;
  const ProjectList({
    this.queryResult,
  });
  @override
  Widget build(BuildContext context) {
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
                  title: Text(project.name != null ? project.name : "No name"),
                  onTap: () {}),
            );
          },
        ),
      ],
    );
  }
}
