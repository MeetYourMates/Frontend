import 'package:flutter/material.dart';

class Logout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size * 0.95;
    return Scaffold(
      body: Center(
        child: Container(
          constraints: BoxConstraints.tightForFinite(width: 400, height: size.height),
          child: Center(
            child: Text("Thank You!"),
          ),
        ),
      ),
    );
  }
}
