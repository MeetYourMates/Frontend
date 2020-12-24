import 'package:flutter/material.dart';
import 'package:meet_your_mates/api/models/student.dart';
import 'package:meet_your_mates/api/models/user.dart';

class StudentList extends StatelessWidget {
  final List<Student> _queryResult = [];
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
        User tmpUser = _queryResult[index].user;
        return Card(
          child: ListTile(
              leading: tmpUser.picture != null
                  ? Image.network(tmpUser.picture)
                  : Text("No Picture"),
              title: Text(tmpUser.name != null ? tmpUser.name : "No name"),
              subtitle: Text(_queryResult[index].degree != null
                  ? _queryResult[index].degree
                  : "No Degree"),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {/* REDIRECCIONAR A PERFIL SELECCIONADO */}),
        );
      },
    );
  }
}
