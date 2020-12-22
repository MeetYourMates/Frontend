import 'package:flutter/material.dart';
import 'package:http/http.dart';

class StudentList extends StatelessWidget {
  String _imageUrl;
  final queryResultDummy = [
    {
      'ratings': [],
      'trophies': [],
      'insignias': [],
      'chats': [],
      'courses': ['44554d4d59434f5552534531', '44554d4d5953424a43543033'],
      '_id': '44554d4d595354444e543031',
      'user': '44554d4d5955534552303031',
      'name': 'Student01',
      'university': '',
      'degree': 'Degree01',
      'picture': '',
      'rating': null
    }
  ];

  final List queryResult;
  StudentList(this.queryResult);

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      children: [
        ...(queryResultDummy).map((item) {
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

    /*
    return ListView.builder(
        itemCount: queryResult.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            contentPadding: EdgeInsets.all(10.0),
            title: new Text(queryResult[index]['title']),
            trailing: new Image.network(
              queryResult[index]['thumbnailUrl'],
              fit: BoxFit.cover,
              height: 40.0,
              width: 40.0,
            ),
          );
        });
        */
  }
}
