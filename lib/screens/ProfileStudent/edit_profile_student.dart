import 'dart:io';

import 'package:file_picker/file_picker.dart';
import "package:flutter/material.dart";
import "package:flutter/widgets.dart";
import 'package:logger/logger.dart';
import 'package:meet_your_mates/api/models/student.dart';
import 'package:meet_your_mates/api/services/image_service.dart';
import 'package:meet_your_mates/api/services/student_service.dart';
import 'package:provider/provider.dart';

class EditProfileStudent extends StatefulWidget {
  final String currentstudentId;

  EditProfileStudent({this.currentstudentId});

  @override
  _EditProfileStudentState createState() => _EditProfileStudentState();
}

class _EditProfileStudentState extends State<EditProfileStudent> {
  var logger = Logger();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = new GlobalKey<FormState>();
  TextEditingController displayNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController passConfController = TextEditingController();
  Student student;
  bool _displayNameValid = true;
  bool _bioValid = true;
  File _imageFile;

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
          controller: emailController,
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
          controller: passController,
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
          controller: passConfController,
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
    ImagesProvider _imageProvider = Provider.of<ImagesProvider>(context);

    void _openFileExplorer() async {
      FilePickerResult result = await FilePicker.platform.pickFiles();
      if (result != null) {
        _imageFile = File(result.files.single.path);
      } else {
        // User canceled the picker
      }
    }

    updateUser() {
      final form = _formKey.currentState;
      Student updatedStu = _studentProvider.student;
      if (form.validate()) {
        if (displayNameController.text.length != 0) {
          updatedStu.user.name = displayNameController.text;
        }
        if (emailController.text.length != 0) {
          updatedStu.user.email = emailController.text;
        }
        if ((passController.text == passConfController.text) && (passController.text.length != 0) && (passConfController.text.length != 0)) {
          updatedStu.user.password = passController.text;
        } else if ((passController.text != passConfController.text) && (passController.text.length != 0) && (passConfController.text.length != 0)) {
          logger.w("Password not match");
        }
        if (_imageFile != null) {
          _imageProvider.uploadPhoto(_imageFile.path, updatedStu.id).then(
                (res) => {
                  updatedStu.user.picture = res,
                  _studentProvider.upload(updatedStu).then(
                    (response) {
                      logger.d("Sucesfully");
                    },
                  ),
                },
              );
        }
        form.save();
      } else {
        logger.e("form is invalid");
      }
    }

    return Scaffold(
      key: _scaffoldKey,
      body: ListView(
        children: <Widget>[
          Container(
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                      top: 16.0,
                      bottom: 8.0,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        _openFileExplorer();
                      },
                      child: CircleAvatar(
                        radius: 50.0,
                        backgroundImage: NetworkImage(_studentProvider.student.user.picture),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: <Widget>[buildDisplayNameField(), buildEmailField(), buildPassField(), buildPassConfirmField()],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RaisedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 18,
                      ),
                      RaisedButton(
                        onPressed: () {
                          updateUser();
                        },
                        child: Text(
                          "Update",
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
