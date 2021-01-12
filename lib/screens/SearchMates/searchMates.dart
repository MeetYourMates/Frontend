import 'package:flutter/material.dart';
import 'package:meet_your_mates/screens/SearchMates/components/body.dart';

class SearchMates extends StatelessWidget {
  const SearchMates({
    Key key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(),
    );
  }
}
