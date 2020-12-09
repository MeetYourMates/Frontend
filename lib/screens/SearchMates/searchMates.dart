import 'package:flutter/material.dart';

import './studentList.dart';

void main() => runApp(SearchMates());

class SearchMates extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SearchMatesState();
  }
}

class _SearchMatesState extends State<SearchMates> {
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
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Conoce tus compañeros!'),
        ),
        body: StudentList(queryResult),
      ),
    );
  }
}
