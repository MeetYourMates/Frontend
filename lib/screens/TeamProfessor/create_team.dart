import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:logger/logger.dart';
import 'package:meet_your_mates/api/models/team.dart';
import 'package:meet_your_mates/api/services/appbar_service.dart';
import 'package:meet_your_mates/api/services/professor_service.dart';
import 'package:meet_your_mates/components/counter.dart';
import 'package:meet_your_mates/components/rounded_button.dart';
import 'package:meet_your_mates/constants.dart';
import 'package:meet_your_mates/screens/TeamProfessor/background.dart';
//import 'package:meet_your_mates/screens/Meeting/map_google.saved';
import 'package:overlay_support/overlay_support.dart';
//Constants
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
//Components

class CreateTeamProfessor extends StatefulWidget {
  final String projectId;
  final num initialGroupValue;
  final onCreated;
  const CreateTeamProfessor({Key key, @required this.projectId, @required this.onCreated, this.initialGroupValue = 1}) : super(key: key);
  @override
  _CreateTeamProfessorState createState() => _CreateTeamProfessorState();
}

class _CreateTeamProfessorState extends State<CreateTeamProfessor> {
  /// [logger] to logg all of the logs in console prettily!
  var logger = Logger(level: Level.debug);
  @override
  void initState() {
    super.initState();
    new Future.delayed(Duration.zero, () {
      Provider.of<AppBarProvider>(context, listen: false).setTitle("New Team");
    });
  }

  //new List of Teams
  List<Team> newTeams = [];
  num _defaultValue = 1;

  /// [Reactive Form]
  final form = FormGroup({
    'name': FormControl(validators: [
      Validators.required,
      Validators.minLength(3),
    ]),
    'description': FormControl(validators: [
      Validators.required,
      Validators.minLength(3),
    ]),
  });

  @override
  Widget build(BuildContext context) {
    /// Accessing the same Student Provider from the MultiProvider
    ProfessorProvider _professorProvider = Provider.of<ProfessorProvider>(context, listen: true);

    /// [_fetchReunions] We fetch the reunions from the server and notify in future
    // ignore: unused_element
    Future<List<Team>> _addTeams() async {
      logger.d("Creating a new Team");
      //meeting.date = dateTimeVal;
      List<Team> result = await _professorProvider.createTeams(newTeams, widget.projectId);
      return result;
    }

    void createTeam() {
      //Check Form
      if (newTeams.isNotEmpty) {
        //Create Meeting --> Future
        EasyLoading.show(
          status: 'loading...',
          maskType: EasyLoadingMaskType.black,
        ).then((value) {
          _addTeams().then((resultTeams) {
            //If succesfull run onCreated
            EasyLoading.dismiss().then((value) {
              if (resultTeams.isNotEmpty) {
                newTeams = resultTeams;
                widget.onCreated(resultTeams);
                //Exit
                Navigator.of(context).pop();
              } else {
                toast("Please try creating team again...");
              }
            });
            //Else show user error, unable to create-->Try again!
          });
        });
      } else {
        toast("Please add atleast one team...");
      }
    }

    Size size = MediaQuery.of(context).size;
    size = new Size(size.width <= 400 ? size.width : 400, size.height);

    Widget _createReunionWidget = Center(
      child: Container(
        alignment: Alignment.center,
        // ListViewBuilder --> Card--> Form(Group Name already Prefilled)--> Increase Group Size Start at 1

        /* constraints: BoxConstraints.loose(new), */
        child: Column(
          children: [
            SizedBox(
              height: size.height * 0.7,
              child: ListView.builder(
                itemCount: newTeams.length,
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemBuilder: (context, index) {
                  Team team = newTeams[index];

                  return Card(
                    child: ListTile(
                      title: Text(team.name) //Edit Form Text Field
                      ,
                      trailing: Counter(
                        initialValue: _defaultValue,
                        minValue: 1,
                        maxValue: 999,
                        step: 1,
                        decimalPlaces: 1,
                        onChanged: (value) {
                          setState(() {
                            newTeams[index].numberStudents = value;
                            logger.i("${team.name} has new value: $value");
                          });
                        },
                      ), // + - counter for incrementing or decreasing number of students
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: size.height * 0.1,
              width: size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: SizedBox(
                      height: size.height * 0.08,
                      child: RoundedButton(
                        text: "Cancel",
                        press: () {
                          //Exit
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: SizedBox(
                      //width: size.width * 0.46,
                      height: size.height * 0.08,
                      child: RoundedButton(
                        text: "Create",
                        press: createTeam,
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
    return SafeArea(
      child: Scaffold(
        body: Background(
          child: _createReunionWidget,
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: "createTeam",
          onPressed: () {
            // Add your onPressed code here!
            logger.i("Adding a new Team");
            Team temp = new Team(name: "Group ${widget.initialGroupValue + newTeams.length}", numberStudents: 1);
            setState(() {
              newTeams.add(temp);
            });
          },
          child: Icon(Icons.add),
          backgroundColor: kPrimaryColor,
        ),
      ),
    );
  }
}
