import 'package:flutter/material.dart';
import 'package:meet_your_mates/screens/GetStarted/components/body.dart';

class GetStarted extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      home: Body(title: 'Get Started'),
    );
  }
}
