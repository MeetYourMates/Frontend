import 'package:flutter/material.dart';
import 'package:meet_your_mates/api/models/courseAndStudents.dart';
import 'package:meet_your_mates/api/models/student.dart';
import 'package:meet_your_mates/api/services/otherStudent_service.dart';
import 'package:provider/provider.dart';
import 'package:meet_your_mates/screens/Profile/otherprofile.dart';

class CourseList extends StatelessWidget {
  final CourseAndStudents queryResult;
  final BuildContext context;
  const CourseList({this.queryResult, this.context});

  Widget build(context) {
    OtherStudentProvider _otherStudentProvider = Provider.of<OtherStudentProvider>(context);
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
          itemCount: queryResult.students.length,
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemBuilder: (context, index) {
            Student student = queryResult.students[index];
            return Card(
              child: ListTile(
                  leading: student.user.picture != null
                      ? Image.network(student.user.picture)
                      : Text("No Picture"),
                  title: Text(student.user.name != null
                      ? student.user.name
                      : "No name"),
                  subtitle: Text(student.degree != null
                      ? queryResult.students[index].degree
                      : "No Degree"),
                  trailing: Icon(Icons.arrow_forward),
                  onTap: () {
                    /* REDIRECCIONAR A PERFIL SELECCIONADO */
                    //_otherStudentProvider.setStudent(student);
                    Navigator.push(
                      context,
                      new MaterialPageRoute(
                        builder: (context) => new OtherProfile(),
                      ),
                    );
                  }),
            );
          },
        ),
      ],
    );
  }
}
