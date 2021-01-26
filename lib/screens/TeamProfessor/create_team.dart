import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:logger/logger.dart';
import 'package:meet_your_mates/api/models/team.dart';
import 'package:meet_your_mates/api/services/appbar_service.dart';
import 'package:meet_your_mates/api/services/professor_service.dart';
import 'package:meet_your_mates/components/counter.dart';
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
  final onCreated;
  const CreateTeamProfessor({Key key, @required this.projectId, @required this.onCreated}) : super(key: key);
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
    Team team = new Team();

    /// [_fetchReunions] We fetch the reunions from the server and notify in future
    // ignore: unused_element
    Future<Team> _addTeam() async {
      logger.d("Creating a new Team");
      //meeting.date = dateTimeVal;
      Team result = await _professorProvider.createTeam(team);
      return result;
    }

    void createMeeting() {
      //Check Form
      if (form.valid) {
        //Create Meeting --> Future
        EasyLoading.show(
          status: 'loading...',
          maskType: EasyLoadingMaskType.black,
        ).then((value) {
          _addTeam().then((resultTeam) {
            //If succesfull run onCreated
            EasyLoading.dismiss().then((value) {
              if (resultTeam.id != null) {
                team = resultTeam;
                widget.onCreated(resultTeam);
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
        toast("Please fill form completly...");
      }
    }

    Size size = MediaQuery.of(context).size;
    size = new Size(size.width <= 400 ? size.width : 400, size.height);

    Widget _createReunionWidget = Center(
      child: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Container(
          alignment: Alignment.center,
          // ListViewBuilder --> Card--> Form(Group Name already Prefilled)--> Increase Group Size Start at 1

          /* constraints: BoxConstraints.loose(new), */
          child: ListView.builder(
            itemCount: newTeams.length,
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemBuilder: (context, index) {
              Team team = newTeams[index];
              num _defaultValue = 1;
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
                        _defaultValue = value;
                        newTeams[index].numberStudents = value;
                      });
                    },
                  ), // + - counter for incrementing or decreasing number of students
                ),
              );
            },
          ),
        ),
      ),
    );
    return SafeArea(
      child: Scaffold(
        body: Background(
          child: _createReunionWidget,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Add your onPressed code here!
            logger.i("Adding a new Team");
            Team temp = new Team(name: "Group ${newTeams.length}");
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
