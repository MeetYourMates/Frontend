import 'package:flutter/material.dart';

class StudentList extends StatelessWidget {
  final List _queryResult = [];
  StudentList(queryResult) {
    this._queryResult.addAll(queryResult);
  }

  @override
  Widget build(BuildContext context) {
    String _imageUrl;
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
                leading:
                    Image.network(_imageUrl != null ? _imageUrl : "No Image"),
                title: Text(item['name'] != null ? item['name'] : "No name"),
                subtitle:
                    Text(item['degree'] != null ? item['degree'] : "No Degree"),
                trailing: Icon(Icons.arrow_forward),
                onTap: () {/* REDIRECCIONAR A PERFIL SELECCIONADO */}),
          );
        }).toList()
      ],
    );
  }
}
