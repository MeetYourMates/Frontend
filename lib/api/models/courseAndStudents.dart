import 'package:meet_your_mates/api/models/student.dart';

class CourseAndStudents {
  String id;
  String start;
  String end;
  String subjectName;
  List<Student> students = <Student>[];

  CourseAndStudents(
      {this.id, this.start, this.end, this.subjectName, this.students});

  factory CourseAndStudents.fromJson(Map<String, dynamic> responseData) {
    List<Student> tmp1 = responseData["students"] != null
        ? List<Student>.from(
            responseData["students"].map((x) => Student.fromJson(x)))
        : [];
    return CourseAndStudents(
        id: responseData['_id'],
        start: responseData['start'],
        end: responseData['end'],
        subjectName: responseData['subjectName'],
        students: tmp1);
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.id;
    data['start'] = this.start;
    data['end'] = this.end;
    return data;
  }
}
