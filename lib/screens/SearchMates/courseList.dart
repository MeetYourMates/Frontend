import 'package:flutter/material.dart';
import 'package:meet_your_mates/api/models/student.dart';
import 'package:meet_your_mates/api/models/courseAndStudents.dart';

class CourseList extends StatelessWidget {
  final CourseAndStudents _queryResult;
  CourseList(this._queryResult);

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
              width: 120,
              decoration: BoxDecoration(
                color: Colors.blue[300],
                border: Border.all(
                  color: Colors.blue[300],
                ),
                borderRadius: BorderRadius.all(Radius.circular(3.0)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  _queryResult.subjectName,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
        ListView.builder(
          itemCount: _queryResult.students.length,
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemBuilder: (context, index) {
            Student student = _queryResult.students[index];
            return Card(
              child: ListTile(
                  leading: student.user.picture != null
                      ? Image.network(student.user.picture)
                      : Text("No Picture"),
                  title: Text(student.user.name != null
                      ? student.user.name
                      : "No name"),
                  subtitle: Text(student.degree != null
                      ? _queryResult.students[index].degree
                      : "No Degree"),
                  trailing: Icon(Icons.arrow_forward),
                  onTap: () {/* REDIRECCIONAR A PERFIL SELECCIONADO */}),
            );
          },
        ),
      ],
    );
  }
}
