import 'dart:io';

import "package:flutter/material.dart";
import "package:flutter/widgets.dart";
import 'package:logger/logger.dart';

import 'package:meet_your_mates/api/services/professor_service.dart';
import 'package:provider/provider.dart';

import 'package:meet_your_mates/api/models/courseProjects.dart';

import 'package:meet_your_mates/screens/ProjectsProfessor/components/background.dart';
import 'package:meet_your_mates/screens/ProjectsProfessor/components/dropDown.dart';

class AddProject extends StatefulWidget {
  const AddProject();

  @override
  _AddProjectState createState() => _AddProjectState();
}

class _AddProjectState extends State<AddProject> {
  String _myActivity;
  String _myActivityResult;

  final _formKey = GlobalKey<FormState>();

  TextEditingController displayNameController = TextEditingController();
  TextEditingController displayNumberController = TextEditingController();

  bool _displayNameValid = true;

  void initState() {
    super.initState();
    _myActivity = '';
    _myActivityResult = '';
  }

  _saveForm() {
    var form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      setState(() {
        _myActivityResult = _myActivity;
      });
    }
  }

  Column buildDisplayNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 12.0),
          child: Text(
            "Project Name",
            style: TextStyle(color: Colors.black),
          ),
        ),
        TextField(
          controller: displayNameController,
          decoration: InputDecoration(
            hintText: "Project Name",
            errorText: _displayNameValid ? null : "Name invalid",
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 15.0),
        ),
      ],
    );
  }

  Column buildDisplayNumberField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 12.0),
          child: Text(
            "Team number",
            style: TextStyle(color: Colors.black),
          ),
        ),
        TextField(
          controller: displayNumberController,
          decoration: InputDecoration(
            hintText: "Number of teams for the project",
            errorText: _displayNameValid ? null : "Number invalid",
          ),
          keyboardType: TextInputType.number,
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 15.0),
        ),
      ],
    );
  }

  Column buildDisplaySubjectField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 12.0),
          child: Text(
            "Subject",
            style: TextStyle(color: Colors.black),
          ),
        ),
        DropDownFormField(
          hintText: 'Please choose one',
          value: _myActivity,
          onSaved: (value) {
            setState(() {
              _myActivity = value;
            });
          },
          onChanged: (value) {
            setState(() {
              _myActivity = value;
            });
          },
          dataSource: [
            {
              "display": "DummySubject1",
              "value": "DummySubject1",
            },
            {
              "display": "DummySubject2",
              "value": "DummySubject2",
            },
            {
              "display": "DummySubject3",
              "value": "DummySubject3",
            },
          ],
          textField: 'display',
          valueField: 'value',
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 15.0),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Background(
          child: Container(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                  ),
                  /*
                  *   Titulo del screen (Añadir proyecto)
                  */
                  Container(
                    height: 50,
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.cyan[400],
                          border: Border.all(
                            color: Colors.cyan[400],
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Añadir un nuevo proyecto',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                  /*
                  *   Formulario
                  */
                  Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                            top: 16.0,
                            bottom: 8.0,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            children: <Widget>[
                              buildDisplaySubjectField(),
                              buildDisplayNameField(),
                              buildDisplayNumberField(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
