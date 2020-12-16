import 'package:flutter/material.dart';
import 'package:meet_your_mates/screens/SearchMates/components/body.dart';
import 'package:meet_your_mates/api/util/shared_preference.dart';
import 'package:meet_your_mates/api/services/student_service.dart';
import 'package:provider/provider.dart';
import 'package:logger/logger.dart';

void main() => runApp(SearchMates());

class SearchMates extends StatelessWidget {
  SearchMates({
    Key key,
  }) : super(key: key);

  Widget build(BuildContext context) {
    StudentProvider _studentProvider = Provider.of<StudentProvider>(context);
    List _queryResult;

    Future<List> _getStudents() async {
      final List queryResult = await _studentProvider.getCourseStudents();
      if (queryResult != null) {
        _queryResult = queryResult;
      } else {
        print('');
      }
    }

    return Scaffold(
      body: Body(queryResult: _queryResult),
    );
  }
}
