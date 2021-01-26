import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:meet_your_mates/api/models/team.dart';
import 'package:meet_your_mates/api/services/appbar_service.dart';
import 'package:meet_your_mates/api/services/professor_service.dart';
import 'package:meet_your_mates/components/error.dart';
import 'package:meet_your_mates/components/loading.dart';
import 'package:meet_your_mates/constants.dart';
import 'package:meet_your_mates/screens/TeamProfessor/background.dart';
import 'package:meet_your_mates/screens/TeamProfessor/create_team.dart';
import 'package:meet_your_mates/screens/TeamProfessor/editTeam.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
//Constants
import 'package:provider/provider.dart';
//Components

class TeamsProfessor extends StatefulWidget {
  final String projectId;

  const TeamsProfessor({Key key, @required this.projectId}) : super(key: key);
  @override
  _TeamsProfessorState createState() => _TeamsProfessorState();
}

class _TeamsProfessorState extends State<TeamsProfessor> {
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
    ProfessorProvider _professorProvider =
        Provider.of<ProfessorProvider>(context, listen: true);
    AppBarProvider _appBarProvider =
        Provider.of<AppBarProvider>(context, listen: false);
    List<Team> teams = [];

    /// [_fetchReunions] We fetch the reunions from the server and notify in future
    Future<List<Team>> _fetchReunions() async {
      return _memoizerReunions.runOnce(() async {
        logger.d("_memoizer Reunions Executed");
        List<Team> result = await _professorProvider.getTeams(widget.projectId);
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
                          trailing: IconButton(
                            icon: Icon(
                              Icons.edit,
                              color: Colors.blue,
                              size: 24.0,
                              semanticLabel: 'Edit Team',
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                new MaterialPageRoute(
                                  builder: (context) =>
                                      new EditTeam(team: teams[index]),
                                ),
                              );
                            },
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
            pushNewScreen(
              context,
              screen: CreateTeamProfessor(
                initialGroupValue: teams.length + 1,
                projectId: widget.projectId,
                onCreated: (newTeams) {
                  logger.i("Added New Team succesfull");
                  setState(() {
                    teams.addAll(newTeams);
                  });
                },
              ),
              withNavBar: true, // OPTIONAL VALUE. True by default.
              pageTransitionAnimation: PageTransitionAnimation.cupertino,
            ).then((value) => {
                  //? To set the original Launching Screen appBarTitle, in this case we are coming back to teams
                  _appBarProvider.setTitle("Teams")
                });
          },
          child: Icon(Icons.add),
          backgroundColor: kPrimaryColor,
        ),
      ),
    );
  }
}
