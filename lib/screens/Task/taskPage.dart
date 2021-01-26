import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:logger/logger.dart';
import 'package:meet_your_mates/api/models/takslist.dart';
import 'package:meet_your_mates/api/services/appbar_service.dart';
import 'package:meet_your_mates/api/services/task_service.dart';
import 'package:meet_your_mates/components/error.dart';
import 'package:meet_your_mates/components/loading.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import 'newTask.dart';

class TaskPage extends StatelessWidget {
  final String teamId;
  const TaskPage({Key key, @required this.teamId}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'avenir'),
      home: taskPage(
        teamId: teamId,
      ),
    );
  }
}

class taskPage extends StatefulWidget {
  final String teamId;
  const taskPage({Key key, @required this.teamId}) : super(key: key);
  @override
  _taskPageState createState() => _taskPageState();
}

class _taskPageState extends State<taskPage> {
  @override
  void initState() {
    super.initState();
    new Future.delayed(Duration.zero, () {
      Provider.of<AppBarProvider>(context, listen: false).setTitle("Tasks");
    });
  }

  var logger = Logger();
  final AsyncMemoizer _memoizerTasks = AsyncMemoizer();
  TaskList taskList = new TaskList(tasks: []);
  List<String> taskNames = [];
  List<String> taskDates = [];
  /* String teamId = "Something"; */
  String filterType = "today";
  DateTime today = new DateTime.now();
  String taskPop = "close";
  var monthNames = ["JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEPT", "OCT", "NOV", "DEC"];
  CalendarController ctrlr = new CalendarController();
  @override
  Widget build(BuildContext context) {
    TaskProvider _taskProvider = Provider.of<TaskProvider>(context);
    AppBarProvider _appBarProvider = Provider.of<AppBarProvider>(context, listen: false);
    Future _fetchTasks() async {
      return _memoizerTasks.runOnce(() async {
        logger.d("_memoizerTeams Executed");
        TaskList result = await _taskProvider.getTasks(widget.teamId);
        return result;
      });
    }

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppBar(
            backgroundColor: Colors.cyan,
            elevation: 0,
            title: Text(
              "Task",
              style: TextStyle(fontSize: 30),
            ),
            actions: <Widget>[
              // ignore: missing_required_param
              IconButton(
                  icon: Icon(Icons.add_circle),
                  onPressed: () {
                    pushNewScreen(
                      context,
                      screen: NewTask(teamId: widget.teamId
                          //BDD always store location as latitude, longitude!
                          ),
                      withNavBar: true, // OPTIONAL VALUE. True by default.
                      pageTransitionAnimation: PageTransitionAnimation.cupertino,
                    ).then(
                      (value) => {
                        //? To set the original Launching Screen appBarTitle, in this case we are coming back to meetings
                        _appBarProvider.setTitle("Tasks"),
                      },
                    );
                  }),
            ],
          ),
          Container(
            height: 70,
            color: Colors.cyan,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        changeFilter("today");
                      },
                      child: Text(
                        "Today",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 4,
                      width: 120,
                      color: (filterType == "today") ? Colors.white : Colors.transparent,
                    )
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        changeFilter("monthly");
                      },
                      child: Text(
                        "Monthly",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 4,
                      width: 120,
                      color: (filterType == "monthly") ? Colors.white : Colors.transparent,
                    )
                  ],
                )
              ],
            ),
          ),
          (filterType == "monthly")
              ? TableCalendar(
                  calendarController: ctrlr,
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  initialCalendarFormat: CalendarFormat.week,
                )
              : Container(),
          Container(
            padding: EdgeInsets.all(20),
            child: Text(
              "Today ${monthNames[today.month - 1]}, ${today.day}/${today.year}",
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ),
          Expanded(
            flex: 8,
            child: FutureBuilder<dynamic>(
              future: _fetchTasks(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return LoadingPage();
                  default:
                    if (snapshot.hasError)
                      return ErrorShow(errorText: 'Error: ${snapshot.error}');
                    else if ((snapshot.hasData)) {
                      taskList = snapshot.data;
                      taskNames.clear();
                      taskDates.clear();
                      taskNames.addAll(taskList.getTaskNames());
                      taskDates.addAll(taskList.getTaskDates());
                      logger.d("Load Tasks: " + taskList.toString());
                      return ListView.builder(
                        physics: ClampingScrollPhysics(),
                        itemBuilder: (context, index) => TaskCard(name: taskNames[index], date: taskDates[index]),
                        shrinkWrap: true,
                        itemCount: taskList.tasks.length,
                      );
                    } else {
                      return ErrorShow(errorText: "Unexpected error. Unable to Retrieve Tasks");
                    }
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  openTaskPop() {
    taskPop = "open";
    setState(() {});
  }

  closeTaskPop() {
    taskPop = "close";
    setState(() {});
  }

  changeFilter(String filter) {
    filterType = filter;
    setState(() {});
  }
}

class TaskCard extends StatelessWidget {
  final String name;
  final String date;

  const TaskCard({Key key, @required this.name, @required this.date}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Slidable(
          actionPane: SlidableDrawerActionPane(),
          actionExtentRatio: 0.3,
          child: Container(
              height: 80,
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), offset: Offset(0, 9), blurRadius: 20, spreadRadius: 1)]),
              child: CheckboxListTile(title: Text(name), subtitle: Text(date), value: timeDilation != 1.0, onChanged: (bool value) {})),
          secondaryActions: [
            IconSlideAction(
              caption: "Edit",
              color: Colors.green,
              icon: Icons.edit,
              onTap: () {},
            ),
            IconSlideAction(
              caption: "Delete",
              color: Colors.red,
              icon: Icons.delete,
              onTap: () {},
            )
          ],
        ));
  }
}
