import 'package:flutter/material.dart';
import 'package:meet_your_mates/screens/SearchMates/components/body.dart';

void main() => runApp(SearchMates());

class SearchMates extends StatelessWidget {
  SearchMates({
    Key key,
  }) : super(key: key);

  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(),
    );
  }
}
