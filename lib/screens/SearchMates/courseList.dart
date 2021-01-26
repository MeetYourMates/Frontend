import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:meet_your_mates/api/models/courseAndStudents.dart';
import 'package:meet_your_mates/api/models/courseProjects.dart';
import 'package:meet_your_mates/api/models/student.dart';
import 'package:meet_your_mates/api/services/mate_provider.dart';
import 'package:meet_your_mates/api/services/student_service.dart';
import 'package:meet_your_mates/screens/ProfileStudent/otherprofile_student.dart';
import 'package:meet_your_mates/screens/ProfileStudent/rateprofile.dart';
import 'package:provider/provider.dart';

import '../../api/services/student_service.dart';
import '../../api/services/student_service.dart';
import '../ProfileStudent/otherprofile_student.dart';

class CourseList extends StatelessWidget {
  final CourseAndStudents queryResult;
  const CourseList({
    this.queryResult,
  });
  @override
  Widget build(BuildContext context) {
    //OtherStudentProvider _otherStudent = Provider.of<OtherStudentProvider>(context);
    MateProvider _otherStudent = Provider.of<MateProvider>(context);
    StudentProvider _studentProvider = Provider.of<StudentProvider>(context);
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
                    _otherStudent.setStudent(student);
                    var logger = Logger();
                    logger.i(_otherStudent.student.ratings);
                    Future<int> canrate = _studentProvider.verifyTeam(
                        _studentProvider.student.id, _otherStudent.student.id);
                    canrate.then((value) => {
                          if (value == null)
                            {
                              Navigator.push(
                                context,
                                new MaterialPageRoute(
                                  builder: (context) =>
                                      new OtherProfileStudent(),
                                ),
                              )
                            }
                        });
                    canrate.then((value) => {
                          if (value != null)
                            {
                              Navigator.push(
                                context,
                                new MaterialPageRoute(
                                  builder: (context) => new RateOtherStudent(),
                                ),
                              )
                            }
                        });
                  }),
            );
          },
        ),
      ],
    );
  }
}
