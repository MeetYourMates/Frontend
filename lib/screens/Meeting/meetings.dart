import 'package:async/async.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:logger/logger.dart';
import 'package:meet_your_mates/api/models/meeting.dart';
import 'package:meet_your_mates/api/services/appbar_service.dart';
//Models
import 'package:meet_your_mates/api/services/student_service.dart';
import 'package:meet_your_mates/components/error.dart';
import 'package:meet_your_mates/components/loading.dart';
import 'package:meet_your_mates/constants.dart';
import 'package:meet_your_mates/screens/Meeting/background.dart';
import 'package:meet_your_mates/screens/Meeting/create_meeting.dart';
import 'package:meet_your_mates/screens/Meeting/show_map_leaflet.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
//Constants
import 'package:provider/provider.dart';
//Components

class Meetings extends StatefulWidget {
  final String teamId;

  const Meetings({Key key, @required this.teamId}) : super(key: key);
  @override
  _MeetingsState createState() => _MeetingsState();
}

class _MeetingsState extends State<Meetings> {
  /// [logger] to logg all of the logs in console prettily!
  var logger = Logger(level: Level.debug);
  @override
  void initState() {
    super.initState();
    new Future.delayed(Duration.zero, () {
      Provider.of<AppBarProvider>(context, listen: false).setTitle("Meetings");
    });
  }

  /// [_memoizerReunions] to recieve all of the reunions from server just once
  /// all of the other runs it just gets data from local ram.
  final AsyncMemoizer<List<Meeting>> _memoizerReunions = AsyncMemoizer();
  final formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    /// Accessing the same Student Provider from the MultiProvider
    StudentProvider _studentProvider = Provider.of<StudentProvider>(context, listen: true);
    AppBarProvider _appBarProvider = Provider.of<AppBarProvider>(context, listen: false);
    List<Meeting> meetings = [];

    /// [_fetchReunions] We fetch the reunions from the server and notify in future
    Future<List<Meeting>> _fetchReunions() async {
      return _memoizerReunions.runOnce(() async {
        logger.d("_memoizer Reunions Executed");
        List<Meeting> result = await _studentProvider.getMeetings(widget.teamId);
        return result;
      });
    }

    //Reunion is a list of Reunions obtained from the server
    Widget _reunionsgetFutureBuildWidget = FutureBuilder<List<Meeting>>(
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
                meetings = snapshot.data;
                //No Error --> Show The list of Reunions and a "+" to add a new reunion in the current team with "teamId"
                return ListView.builder(
                  itemCount: meetings.length,
                  itemBuilder: (context, index) {
                    //Return a new ListTile with ReunionView and a click button to see Reunions details
                    return Card(
                      child: ListTile(
                          title: Text(meetings[index].name),
                          isThreeLine: true,
                          subtitle: Text(meetings[index].description),
                          trailing: Text(new DateFormat('hh:mm dd-MM-y').format(DateTime.fromMillisecondsSinceEpoch(meetings[index].date))),
                          onTap: () {
                            //on Tap of this
                            logger.d("Pressed Meeting");
                            //Check if the current meeting has location, if it does than show map else don't show a toast!
                            if (meetings[index].location.isNotEmpty) {
                              //As location available, show the map with marker as location of the current meeting
                              pushNewScreen(
                                context,
                                screen: ShowMapLeaflet(
                                  //BDD always store location as latitude, longitude!
                                  location: new LatLng(meetings[index].location[0], meetings[index].location[1]),
                                ),
                                withNavBar: true, // OPTIONAL VALUE. True by default.
                                pageTransitionAnimation: PageTransitionAnimation.cupertino,
                              ).then(
                                (value) => {
                                  //? To set the original Launching Screen appBarTitle, in this case we are coming back to meetings
                                  _appBarProvider.setTitle("Meetings"),
                                },
                              );
                            } else {
                              toast("No location available for this meeting...", duration: new Duration(milliseconds: 800));
                            }
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
          onPressed: () {
            // Add your onPressed code here!
            logger.i("Adding a new Reunion Button Pressed!");
            pushNewScreen(
              context,
              screen: CreateMeeting(
                teamId: widget.teamId,
                onCreated: (meeting) {
                  logger.i("Added New Meeting succesfull");
                  setState(() {
                    meetings.add(meeting);
                  });
                },
              ),
              withNavBar: true, // OPTIONAL VALUE. True by default.
              pageTransitionAnimation: PageTransitionAnimation.cupertino,
            ).then((value) => {
                  //? To set the original Launching Screen appBarTitle, in this case we are coming back to meetings
                  _appBarProvider.setTitle("Meetings")
                });
          },
          child: Icon(Icons.add),
          backgroundColor: kPrimaryColor,
        ),
      ),
    );
  }
}
