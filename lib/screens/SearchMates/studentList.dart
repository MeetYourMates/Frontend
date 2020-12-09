import 'package:flutter/material.dart';

class StudentList extends StatelessWidget {
  final List<Map<String, Object>> queryResult;
  StudentList(this.queryResult);
  String _imageUrl;

  @override
  Widget build(BuildContext context) {
    return ListView(
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
