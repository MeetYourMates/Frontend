
import "package:flutter/material.dart";
import 'package:meet_your_mates/api/models/student.dart';
import 'package:meet_your_mates/api/services/student_service.dart';
import 'package:provider/provider.dart';


class EditProfile extends StatefulWidget {
  final String currentstudentId;

  EditProfile({this.currentstudentId});

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController displayNameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  bool isLoading = false;
  Student student;
  bool _displayNameValid = true;
  bool _bioValid = true;
  
  
  @override
  void initState() {
    super.initState();
    getstudent();
  }

  getstudent(){
    
  }

  Column buildDisplayNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.only(top: 12.0),
            child: Text(
              "Display Name",
              style: TextStyle(color: Colors.grey),
            )),
        TextField(
          controller: displayNameController,
          decoration: InputDecoration(
            hintText: "Update Display Name",
            errorText: _displayNameValid ? null : "Display Name too short",
          ),
        )
      ],
    );
  }

  Column buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 12.0),
          child: Text(
            "Email",
            style: TextStyle(color: Colors.grey),
          ),
        ),
        TextField(
          controller: bioController,
          decoration: InputDecoration(
            hintText: "Update email",
            errorText: _bioValid ? null : "Email too long",
          ),
        )
      ],
    );
  }

  Column buildPassField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 12.0),
          child: Text(
            "Password",
            style: TextStyle(color: Colors.grey),
          ),
        ),
        TextField(
          controller: bioController,
          decoration: InputDecoration(
            hintText: "Update password",
            errorText: _bioValid ? null : "Wrong password",
          ),
        )
      ],
    );
  }

  Column buildPassConfirmField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 12.0),
          child: Text(
            "Confirm password ",
            style: TextStyle(color: Colors.grey),
          ),
        ),
        TextField(
          controller: bioController,
          decoration: InputDecoration(
            hintText: "Confirm password",
            errorText: _bioValid ? null : "Passwords not match",
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    StudentProvider _studentProvider = Provider.of<StudentProvider>(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Edit Profile",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.done,
              size: 30.0,
              color: Colors.green,
            ),
          ),
        ],
      ),
      body: ListView(
              children: <Widget>[
                Container(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                          top: 16.0,
                          bottom: 8.0,
                        ),
                        child: CircleAvatar(
                          radius: 50.0,
                          backgroundImage: NetworkImage(_studentProvider.student.picture),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          children: <Widget>[
                            buildDisplayNameField(),
                            buildEmailField(),
                            buildPassField(),
                            buildPassConfirmField()
                          ],
                        ),
                      ),
                      RaisedButton(
                        onPressed: (){},
                        child: Text(
                          "Update Profile",
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),


                    ],
                  ),
                ),
              ],
            ),
    );
  }
}