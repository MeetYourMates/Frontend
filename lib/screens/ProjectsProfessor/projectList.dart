import 'package:flutter/material.dart';
import 'package:meet_your_mates/api/models/courseProjects.dart';
import 'package:provider/provider.dart';

class ProjectList extends StatelessWidget {
  final CourseProjects queryResult;
  const ProjectList({
    this.queryResult,
  });
  @override
  Widget build(BuildContext context) {
    return Text(queryResult.subjectName);
  }
}
