import "package:flutter/material.dart";
import "package:flutter/widgets.dart";
import 'package:logger/logger.dart';
import 'package:flutter/services.dart';

import 'package:meet_your_mates/api/models/project.dart';
import 'package:meet_your_mates/api/services/professor_service.dart';

import 'package:provider/provider.dart';

import 'package:meet_your_mates/api/models/courseProjects.dart';

import 'package:meet_your_mates/screens/TeamProfessor/background.dart';
import 'package:meet_your_mates/screens/ProjectsProfessor/components/dropDown.dart';

class EditTeam extends StatefulWidget {
  const EditTeam();

  @override
  _EditTeamState createState() => _EditTeamState();
}

class _EditTeamState extends State<EditTeam> {
  final _formKey = GlobalKey<FormState>();

  _saveForm() {
    final form = _formKey.currentState;
    if (form.validate()) {
      Navigator.pop(context);
      form.save();
    }
  }

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
                            'Editar Team',
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
                        /*
                        *   Form inputs
                        */
                        Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            children: <Widget>[],
                          ),
                        ),
                        /*
                        *   Form buttons
                        */
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
                                  color: Colors.white,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              color: Colors.cyan[400],
                            ),
                            SizedBox(
                              width: 18,
                            ),
                            RaisedButton(
                              onPressed: () {
                                _saveForm();
                              },
                              child: Text(
                                "Update",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              color: Colors.cyan[400],
                            ),
                          ],
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
