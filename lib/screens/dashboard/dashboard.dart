import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
//Services
import 'package:meet_your_mates/api/services/user_service.dart';
//Utilities

//Screens
import 'package:meet_your_mates/screens/Profile/profile.dart';
//Models
import 'package:meet_your_mates/api/models/user.dart';

class DashBoard extends StatefulWidget{
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context).user;

    return Scaffold(
      appBar: AppBar(
        title: Text("DASHBOARD PAGE"),
        elevation: 0.1,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 100,
          ),
          Center(child: Text(user.email)),
          SizedBox(height: 100),
          RaisedButton(
            onPressed: () {},
            child: Text("Logout"),
            color: Colors.lightBlueAccent,
          ),
          SizedBox(height: 100),
          RaisedButton(
            onPressed: () {
              Navigator.push(context,new MaterialPageRoute(builder: (context) => new Profile()));
            },
            child: Text("Profile"),
            color: Colors.lightBlueAccent,
          )
        ],
      ),
    );
  }
}
