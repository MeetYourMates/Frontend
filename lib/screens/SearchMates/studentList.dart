import 'package:flutter/material.dart';
import 'package:http/http.dart';

class StudentList extends StatelessWidget {
  String _imageUrl;

  final List _queryResult = [];
  StudentList(queryResult) {
    this._queryResult.addAll(queryResult);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      children: [
        ...(_queryResult).map((item) {
          item['picture'] != ''
              ? _imageUrl = item['picture']
              : _imageUrl =
                  'https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png';
          return Card(
            child: ListTile(
                leading: Image.network(_imageUrl),
                title: Text(item['name']),
                subtitle: Text(item['degree']),
                trailing: Icon(Icons.arrow_forward),
                onTap: () {/* REDIRECCIONAR A PERFIL SELECCIONADO */}),
          );
        }).toList()
      ],
    );
  }
}
