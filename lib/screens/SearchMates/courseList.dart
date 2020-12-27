import 'package:flutter/material.dart';
import 'package:meet_your_mates/api/models/student.dart';
import 'package:meet_your_mates/api/models/course.dart';

class StudentList extends StatelessWidget {
  final List<Course> _queryResult = [];
  StudentList(queryResult) {
    this._queryResult.addAll(queryResult);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _queryResult.length,
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      itemBuilder: (context, index) {
        Course tmpCourse = _queryResult[index];
        return Card(
          child: ListTile(),
        );
      },
    );
  }
}
