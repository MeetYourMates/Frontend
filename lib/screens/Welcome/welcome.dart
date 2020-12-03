import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
//Services
import 'package:meet_your_mates/api/services/user_service.dart';
//Models
import 'package:meet_your_mates/api/models/user.dart';

class Welcome extends StatelessWidget {
  final User user;

  Welcome({Key key, @required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<UserProvider>(context).setUser(user);

    return Scaffold(
      body: Container(
        child: Center(
          child: Text("WELCOME PAGE"),
        ),
      ),
    );
  }
}
