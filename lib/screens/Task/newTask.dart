import 'package:async/async.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:meet_your_mates/api/models/task.dart';
import 'package:meet_your_mates/api/services/task_service.dart';
import 'package:provider/provider.dart';
import 'taskPage.dart';

class NewTask extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'avenir'),
      home: newTask(),
    );
  }
}

class newTask extends StatefulWidget {
  @override
  _newTaskState createState() => _newTaskState();
}

class _newTaskState extends State<newTask> {
  var logger = Logger(level: Level.debug);
  final AsyncMemoizer _memoizerTasks = AsyncMemoizer();
  String dateTimeVal;
  @override
  Widget build(BuildContext context) {
    TaskProvider _taskProvider = Provider.of<TaskProvider>(context);
    _createTask(Task task) async {
      return _memoizerTasks.runOnce(() async {
        logger.d("_memoizerTeams Executed");
        bool result = await _taskProvider.createTask(task);
        return result;
      });
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        elevation: 0,
        title: Text(
          "New Task",
          style: TextStyle(fontSize: 25),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => TaskPage()));
          },
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Container(
              height: 30,
              color: Colors.cyan,
            ),
            Positioned(
              bottom: 0,
              child: Container(
                height: 70,
                width: MediaQuery.of(context).size.width,
                color: Colors.black.withOpacity(0.8),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 30),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(7)),
                  color: Colors.white),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.85,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      color: Colors.grey.withOpacity(0.2),
                      child: TextField(
                        decoration: InputDecoration(
                            hintText: "Title", border: InputBorder.none),
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      padding: EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Description",
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: 150,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                    color: Colors.grey.withOpacity(0.2))),
                            child: TextField(
                              maxLines: 6,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: " Add description here",
                              ),
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
                              onChanged: (val) =>
                                  {logger.i(val), dateTimeVal = val},
                              validator: (val) {
                                dateTimeVal = val;
                                return null;
                              },
                              onSaved: (val) =>
                                  {logger.i(val), dateTimeVal = val},
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
                                _createtask();
                              },
                              shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(20.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
