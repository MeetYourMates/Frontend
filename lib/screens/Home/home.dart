import 'package:flutter/material.dart';
import 'package:meet_your_mates/screens/Home/components/background.dart';
import 'package:meet_your_mates/screens/Home/components/homeBody.dart';

class Home extends StatelessWidget {
  const Home({
    Key key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Background(
          child: HomeBody(),
        ),
      ),
    );
  }
}
