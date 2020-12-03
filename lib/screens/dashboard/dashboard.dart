import 'package:meet_your_mates/api/services/student_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
//Services

//Utilities

//Models

class DashBoard extends StatefulWidget {
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  @override
  Widget build(BuildContext context) {
    //Provides Access to Student and ability to update student in the whole app
    StudentProvider _studentProvider = Provider.of<StudentProvider>(context);
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
          Center(child: Text("User Entered!")),
          SizedBox(height: 100),
          RaisedButton(
            onPressed: () {},
            child: Text("Logout"),
            color: Colors.lightBlueAccent,
          )
        ],
      ),
    );
  }
}
