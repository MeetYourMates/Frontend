import "package:flutter/material.dart";
import "package:flutter/widgets.dart";
import 'package:logger/logger.dart';
import 'package:flutter/services.dart';

import 'package:meet_your_mates/api/models/project.dart';
import 'package:meet_your_mates/api/services/professor_service.dart';

import 'package:provider/provider.dart';

import 'package:meet_your_mates/api/models/courseProjects.dart';

import 'package:meet_your_mates/screens/ProjectsProfessor/components/background.dart';
import 'package:meet_your_mates/screens/ProjectsProfessor/components/dropDown.dart';

class AddProject extends StatefulWidget {
  final List<CourseProjects> courseProjects;

  const AddProject({
    this.courseProjects,
  });

  @override
  _AddProjectState createState() => _AddProjectState();
}

class _AddProjectState extends State<AddProject> {
  var logger = Logger();

  String _selectedSubject;
  String _selectedSubjectResult;

  final _formKey = GlobalKey<FormState>();

  TextEditingController displayNameController = TextEditingController();
  TextEditingController displayNumberController = TextEditingController();

  bool _displayNameValid = true;

  void initState() {
    super.initState();
    _selectedSubject = '';
    _selectedSubjectResult = '';
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

  /// ================================================================================================
  ///!                DisplayNumber not used anymore
  ///             keeping definition of the widget just i case
  ///            implementation of the widget inside build() commented
  ///================================================================================================**/
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
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
          value: _selectedSubject,
          onSaved: (value) {
            setState(() {
              _selectedSubject = value;
            });
          },
          onChanged: (value) {
            setState(() {
              _selectedSubject = value;
            });
          },
          dataSource: [
            for (CourseProjects course in widget.courseProjects)
              {
                "display": course.subjectName,
                "value": course.id,
              }
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
    ProfessorProvider _professorProvider =
        Provider.of<ProfessorProvider>(context);

    _saveForm() {
      final form = _formKey.currentState;
      if (form.validate()) {
        Project project;
        setState(() {
          _selectedSubjectResult = _selectedSubject;
        });
        if (displayNameController.text.length !=
                0 /*&&
            int.parse(displayNumberController.text) > 0*/
            ) {
          project = new Project(
              name: displayNameController
                  .text /*,
              numberStudents: int.parse(displayNumberController.text)*/
              );
        }
        _professorProvider.addProject(project, _selectedSubjectResult).then(
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
                        /*
                        *   Form inputs
                        */
                        Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            children: <Widget>[
                              buildDisplaySubjectField(),
                              buildDisplayNameField(),
                              //buildDisplayNumberField(),
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
                                  color: Colors.cyan[400],
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              color: Colors.white,
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
                                  color: Colors.cyan[400],
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              color: Colors.white,
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
