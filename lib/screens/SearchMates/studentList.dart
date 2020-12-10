import 'package:flutter/material.dart';

class StudentList extends StatelessWidget {
  StudentList();
  String _imageUrl;
  final queryResult = [
    {
      'ratings': [],
      'trophies': [],
      'insignias': [],
      'chats': [],
      'courses': ['44554d4d59434f5552534531', '44554d4d5953424a43543033'],
      '_id': '44554d4d595354444e543031',
      'user': '44554d4d5955534552303031',
      'name': 'Mauricio',
      'university': '',
      'degree': 'Telematica',
      'picture': 'https://randomuser.me/api/portraits/men/75.jpg',
      'rating': null
    },
    {
      'ratings': [],
      'trophies': [],
      'insignias': [],
      'chats': [],
      'courses': ['44554d4d59434f5552534531', '44554d4d5953424a43543032'],
      '_id': '44554d4d595354444e543032',
      'user': '44554d4d5955534552303032',
      'name': 'Filomena',
      'university': '',
      'degree': 'Aeros',
      'picture': 'https://randomuser.me/api/portraits/women/91.jpg',
      'rating': null
    }
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      children: [
        ...(queryResult as List<Map<String, Object>>).map((item) {
          item['picture'] != ''
              ? _imageUrl = item['picture']
              : _imageUrl =
                  'https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png';
          return Card(
            child: ListTile(
              leading: Image.network(_imageUrl),
              title: Text(item['name']),
              subtitle: Text(item['degree']),
            ),
          );
        }).toList()
      ],
    );
  }
}
