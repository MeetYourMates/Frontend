import 'package:flutter/material.dart';
import 'package:meet_your_mates/screens/GetStarted/components/body.dart';

class GetStarted extends StatelessWidget {
  GetStarted({
    Key key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size * 0.96;
    return Scaffold(
      body: Body(
        size: size,
      ),
    );
  }
}
