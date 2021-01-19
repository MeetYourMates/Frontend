import 'dart:io';

import "package:flutter/material.dart";
import "package:flutter/widgets.dart";
import 'package:logger/logger.dart';

import 'package:meet_your_mates/api/services/professor_service.dart';
import 'package:provider/provider.dart';

import 'package:meet_your_mates/api/models/courseProjects.dart';

class AddProject extends StatefulWidget {
  const AddProject();

  @override
  _AddProjectState createState() => _AddProjectState();
}

class _AddProjectState extends State<AddProject> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text("OK"),
    );
  }
}
