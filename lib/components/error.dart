import 'package:flutter/material.dart';
import 'package:meet_your_mates/constants.dart';

class ErrorShow extends StatelessWidget {
  final String errorText;
  const ErrorShow({
    Key key,
    @required this.errorText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Container(
        decoration: BoxDecoration(
          color: kPrimaryLightColor,
          borderRadius: BorderRadius.circular(29),
        ),
        child: Center(
          child: Text('Error: $errorText'),
        ),
      ),
    );
  }
}
