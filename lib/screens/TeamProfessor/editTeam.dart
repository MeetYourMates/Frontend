import "package:flutter/material.dart";
import "package:flutter/widgets.dart";
import 'package:logger/logger.dart';
import 'package:flutter/services.dart';

import 'package:meet_your_mates/api/models/team.dart';
import 'package:meet_your_mates/api/services/professor_service.dart';

import 'package:provider/provider.dart';

import 'package:meet_your_mates/api/models/courseProjects.dart';

import 'package:meet_your_mates/screens/TeamProfessor/background.dart';
import 'package:meet_your_mates/screens/ProjectsProfessor/components/dropDown.dart';

class EditTeam extends StatefulWidget {
  final Team team;
  const EditTeam({this.team});

  @override
  _EditTeamState createState() => _EditTeamState();
}

class _EditTeamState extends State<EditTeam> {
  var logger = Logger(level: Level.debug);

  final _formKey = GlobalKey<FormState>();

  TextEditingController displayNameController = TextEditingController();
  TextEditingController displayNumberController = TextEditingController();

  bool _displayNameValid = true;

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
            hintText: widget.team.name,
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
            hintText: widget.team.numberStudents.toString(),
            errorText: _displayNameValid ? null : "Number invalid",
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 15.0),
        ),
      ],
    );
  }

  Widget build(BuildContext context) {
    ProfessorProvider _professorProvider =
        Provider.of<ProfessorProvider>(context);

    _saveForm() {
      final form = _formKey.currentState;
      if (form.validate()) {
        Team team;
        if (displayNameController.text.length != 0 &&
            int.parse(displayNumberController.text) > 0) {
          team = new Team(
              id: widget.team.id,
              name: displayNameController.text,
              numberStudents: int.parse(displayNumberController.text));
        }
        _professorProvider.updateTeam(team).then(
          (response) {
            if (response == 0)
              logger.d("Project added succesfully");
            else if (response == -1)
              logger.d("Error adding project");
            else if (response == -2) logger.d("Unexpected return code");
          },
        );
        Navigator.pop(context);
        form.save();
      }
    }

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
                            children: <Widget>[
                              buildDisplayNameField(),
                              buildDisplayNumberField(),
                            ],
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
                                Navigator.pop(context);
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
