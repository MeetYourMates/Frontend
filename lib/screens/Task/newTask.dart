import 'package:another_flushbar/flushbar.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:logger/logger.dart';
import 'package:meet_your_mates/api/services/appbar_service.dart';
import 'package:meet_your_mates/api/services/task_service.dart';
import 'package:meet_your_mates/api/util/route_uri.dart';
import 'package:provider/provider.dart';

class NewTask extends StatelessWidget {
  final String teamId;
  const NewTask({Key key, @required this.teamId}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'avenir'),
      home: newTask(
        teamId: teamId,
      ),
    );
  }
}

class newTask extends StatefulWidget {
  final String teamId;
  const newTask({Key key, @required this.teamId}) : super(key: key);
  @override
  _newTaskState createState() => _newTaskState();
}

class _newTaskState extends State<newTask> {
  var logger = Logger(level: Level.debug);
  @override
  void initState() {
    super.initState();
    new Future.delayed(Duration.zero, () {
      Provider.of<AppBarProvider>(context, listen: false).setTitle("New Task");
    });
  }

  String _name = "", _description = "", _date = "";
  @override
  Widget build(BuildContext context) {
    TaskProvider _taskProvider = Provider.of<TaskProvider>(context);

    Future<bool> addTask(String name, String descr, String date, String teamId) async {
      bool status = false;
      Map<String, dynamic> response = await _taskProvider.createTask(name, descr, date, teamId);
      status = status || response['status'];
      return status;
    }

    validateAll() {
      if (_name != "Title" &&
          _description != "Add a description" &&
          _name != null &&
          _description != null &&
          _name.isNotEmpty &&
          _description.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    }

    Null Function(String message) doFlushbar = (String message) {
      Flushbar(
        title: "Oops!",
        message: message,
        duration: Duration(seconds: 3),
      ).show(context);
    };

    void createTask(String name, String descr, String date, String teamId) async {
      logger.d('name: $_name');
      logger.d('description: $_description');
      if (validateAll()) {
        EasyLoading.show(
          status: 'loading...',
          maskType: EasyLoadingMaskType.black,
        ).then((value) {
          //Execute Enrollment
          //final bool enrollStatus = await enrollStudents();
          addTask(name, descr, date, widget.teamId).then((status) {
            //Enroll
            logger.d("Status: " + status.toString());
            if (status) {
              EasyLoading.dismiss().then((value) {
                logger.d("Succesfully added and launched taskPage");
                Navigator.pushReplacementNamed(context, RouteUri.taskPage);
              });
            } else {
              //Failed
              EasyLoading.dismiss().then((value) {
                logger.d("Failed to add task!");
                doFlushbar("Failed to add task!");
              });
            }
          });
        });
      } else {
        doFlushbar("The task must have a title and a description.");
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: MediaQuery.of(context).size.height,
        margin: new EdgeInsets.symmetric(horizontal: 40.0),
        alignment: Alignment.topCenter,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 40,
                  ),
                  Text(
                    "Title",
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.grey.withOpacity(0.2))),
                    child: TextField(
                      decoration: InputDecoration(hintText: "  Title", border: InputBorder.none),
                      style: TextStyle(fontSize: 18),
                      onChanged: (val) => {_name = val},
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    "Description",
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.grey.withOpacity(0.2))),
                    child: TextField(
                      maxLines: 6,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: " Add description here",
                      ),
                      onChanged: (val) => {_description = val},
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Due date",
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    color: Colors.grey.withOpacity(0.2),
                    child: DateTimePicker(
                      type: DateTimePickerType.dateTimeSeparate,
                      dateMask: 'd MMM, yyyy',
                      //"2021-01-23 09:03"
                      initialValue: DateTime.now().toString(),
                      firstDate: DateTime(2021),
                      lastDate: DateTime(2100),
                      icon: Icon(Icons.event),
                      dateLabelText: 'Date',
                      timeLabelText: "Time",
                      onChanged: (val) => {logger.i(val), _date = val},
                      validator: (val) {
                        _date = val;
                        return null;
                      },
                      onSaved: (val) => {logger.i(val), _date = val},
                    ),
                  ),
                  SizedBox(
                    height: 100.0,
                  ),
                  SizedBox(
                    width: 500.0,
                    height: 50.0,
                    child: RaisedButton(
                      textColor: Colors.white,
                      color: Colors.cyan,
                      child: Text("Add Task"),
                      onPressed: () {
                        createTask(_name, _description, _date, widget.teamId);
                      },
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
