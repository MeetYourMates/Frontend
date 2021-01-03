import 'package:flutter/material.dart';
import 'package:meet_your_mates/api/models/student.dart';
import 'package:meet_your_mates/api/models/courseAndStudents.dart';

class CourseList extends StatelessWidget {
  final CourseAndStudents _queryResult;
  CourseList(this._queryResult);
  /*
  @override
  Widget build(BuildContext context) {
    return StickyGroupedListView(
      elements: _queryResult,
      groupBy: (CourseAndStudents course) => course.subjectName,
      floatingHeader: true,
      groupSeparatorBuilder: (CourseAndStudents course) => Container(
        height: 50,
        child: Align(
          alignment: Alignment.center,
          child: Container(
            width: 120,
            decoration: BoxDecoration(
              color: Colors.blue,
              border: Border.all(
                color: Colors.blue,
              ),
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '${course.subjectName}',
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
      itemBuilder: (_, CourseAndStudents course) {
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.0),
          ),
          elevation: 8.0,
          margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          child: Container(
            child: ListTile(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              title: Text('${course.students[0].user.name}'),
              trailing: Text('TEST'),
            ),
          ),
        );
      },
    );
  }*/

  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _queryResult.students.length,
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      itemBuilder: (context, index) {
        Student tmpStudent = _queryResult.students[index];
        return Card(
          child: ListTile(
              leading: tmpStudent.user.picture != null
                  ? Image.network(tmpStudent.user.picture)
                  : Text("No Picture"),
              title: Text(tmpStudent.user.name != null
                  ? tmpStudent.user.name
                  : "No name"),
              subtitle: Text(_queryResult.students[index].degree != null
                  ? _queryResult.students[index].degree
                  : "No Degree"),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {/* REDIRECCIONAR A PERFIL SELECCIONADO */}),
        );
      },
    );
  }
}
