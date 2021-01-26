import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:meet_your_mates/api/models/team.dart';
import 'package:meet_your_mates/api/services/appbar_service.dart';
import 'package:meet_your_mates/api/services/student_service.dart';
import 'package:meet_your_mates/components/error.dart';
import 'package:meet_your_mates/components/loading.dart';
import 'package:meet_your_mates/constants.dart';
import 'package:meet_your_mates/screens/TeamProfessor/background.dart';
//Constants
import 'package:provider/provider.dart';
//Components

class TeamsStudent extends StatefulWidget {
  final String projectId;

  const TeamsStudent({Key key, @required this.projectId}) : super(key: key);
  @override
  _TeamsStudentState createState() => _TeamsStudentState();
}

class _TeamsStudentState extends State<TeamsStudent> {
  /// [logger] to logg all of the logs in console prettily!
  var logger = Logger(level: Level.debug);

  /// [_memoizerReunions] to recieve all of the reunions from server just once
  /// all of the other runs it just gets data from local ram.
  final AsyncMemoizer<List<Team>> _memoizerReunions = AsyncMemoizer();
  final formKey = new GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    new Future.delayed(Duration.zero, () {
      Provider.of<AppBarProvider>(context, listen: false).setTitle("Teams");
    });
  }

  @override
  Widget build(BuildContext context) {
    /// Accessing the same Student Provider from the MultiProvider
    StudentProvider _studentProvider = Provider.of<StudentProvider>(context, listen: true);
    //AppBarProvider _appBarProvider = Provider.of<AppBarProvider>(context, listen: false);
    List<Team> teams = [];

    /// [_fetchReunions] We fetch the reunions from the server and notify in future
    Future<List<Team>> _fetchReunions() async {
      return _memoizerReunions.runOnce(() async {
        logger.d("_memoizer Reunions Executed");
        List<Team> result = await _studentProvider.getTeams(widget.projectId);
        return result;
      });
    }

    //Reunion is a list of Reunions obtained from the server
    Widget _reunionsgetFutureBuildWidget = FutureBuilder<List<Team>>(
        future: _fetchReunions(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return LoadingPage();
            default:
              if (snapshot.hasError)
                return ErrorShow(
                  errorText: snapshot.error,
                );
              else if (snapshot.data == null) {
                return ErrorShow(
                  errorText: "Couldn't Load Data from the server!",
                );
              } else {
                teams = snapshot.data;
                //No Error --> Show The list of Reunions and a "+" to add a new reunion in the current team with "teamId"
                return ListView.builder(
                  itemCount: teams.length,
                  itemBuilder: (context, index) {
                    //Return a new ListTile with ReunionView and a click button to see Reunions details
                    Team tempTeam = teams[index];
                    return Card(
                      child: ListTile(
                          title: Text(tempTeam.name),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.edit,
                                color: Colors.blue,
                                size: 24.0,
                                semanticLabel: 'Edit Team',
                              ),
                              SizedBox(width: 20,),
                              GestureDetector(
                                child: Icon(
                                  Icons.accessible_forward,
                                  color: Colors.blue,
                                  size: 24.0,
                                  semanticLabel: 'Join Team',
                                ),
                                onTap: () {
                                  _studentProvider.JoinTeam(tempTeam.id).then((value) =>
                                  {
                                    if (value == "joined") {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context){
                                            return AlertDialog(
                                              title: Text("Joined Team"),
                                              content: Text("You joined the team! now you can start inviting mates"),
                                            );
                                          }
                                      )
                                  }
                                  });
                                },
                              ),
                            ],
                          ),
                          onTap: () {
                            //TODO: On Team Tap
                          }),
                    );
                  },
                );
              }
          }
        });

    return SafeArea(
      child: Scaffold(
        body: Background(
          child: _reunionsgetFutureBuildWidget,
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: "teams",
          onPressed: () {
            // Add your onPressed code here!
            logger.i("Adding a new Reunion Button Pressed!");
            //TODO: Add your onPressed code here!
          },
          child: Icon(Icons.add),
          backgroundColor: kPrimaryColor,
        ),
      ),
    );
  }
}
