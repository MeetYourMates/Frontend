import 'package:flutter/material.dart';
import 'package:meet_your_mates/api/models/student.dart';
import 'package:meet_your_mates/screens/GetStarted/components/body.dart';

class GetStarted extends StatelessWidget {
  final Student student;
  GetStarted({Key key, @required this.student}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(student: student),
    );
  }
}
