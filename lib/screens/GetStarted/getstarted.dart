import 'package:flutter/material.dart';
import 'package:meet_your_mates/api/services/student_service.dart';
import 'package:meet_your_mates/screens/GetStarted/components/body.dart';
import 'package:provider/provider.dart';

class GetStarted extends StatelessWidget {
  GetStarted({
    Key key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(),
    );
  }
}
