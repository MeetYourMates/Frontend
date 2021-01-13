import 'package:flutter/material.dart';
import 'package:meet_your_mates/screens/SearchStudents/components/body.dart';

class SearchStudents extends StatelessWidget {
  const SearchStudents({
    Key key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(),
    );
  }
}
