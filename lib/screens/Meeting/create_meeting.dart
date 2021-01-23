import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:latlong/latlong.dart';
import 'package:logger/logger.dart';
import 'package:meet_your_mates/api/models/meeting.dart';
import 'package:meet_your_mates/api/services/appbar_service.dart';
//Models
import 'package:meet_your_mates/api/services/student_service.dart';
import 'package:meet_your_mates/components/rounded_button.dart';
import 'package:meet_your_mates/components/text_field_container.dart';
import 'package:meet_your_mates/constants.dart';
import 'package:meet_your_mates/screens/Meeting/background.dart';
import 'package:meet_your_mates/screens/Meeting/map_leaflet.dart';
//import 'package:meet_your_mates/screens/Meeting/map_google.saved';
import 'package:overlay_support/overlay_support.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
//Constants
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
//Components

class CreateMeeting extends StatefulWidget {
  final String teamId;
  final onCreated;
  const CreateMeeting({Key key, @required this.teamId, @required this.onCreated}) : super(key: key);
  @override
  _CreateMeetingState createState() => _CreateMeetingState();
}

class _CreateMeetingState extends State<CreateMeeting> {
  /// [logger] to logg all of the logs in console prettily!
  var logger = Logger(level: Level.debug);
  String dateTimeVal;
  LatLng location;
  @override
  void initState() {
    super.initState();
    new Future.delayed(Duration.zero, () {
      Provider.of<AppBarProvider>(context, listen: false).setTitle("New Meeting");
    });
  }

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
    StudentProvider _studentProvider = Provider.of<StudentProvider>(context, listen: true);
    Meeting meeting = new Meeting();

    /// [_fetchReunions] We fetch the reunions from the server and notify in future
    // ignore: unused_element
    Future<Meeting> _addMeeting() async {
      logger.d("Creating a new Meeting");
      //meeting.date = dateTimeVal;
      DateTime now = DateTime.parse(dateTimeVal);
      meeting.date = now.millisecondsSinceEpoch;
      meeting.teamId = widget.teamId;
      meeting.name = this.form.control('name').value;
      meeting.description = this.form.control('description').value;
      Meeting result = await _studentProvider.createMeeting(meeting);
      return result;
    }

    void createMeeting() {
      //Check Form
      if (form.valid) {
        //Create Meeting --> Future
        if (dateTimeVal != null) {
          if (this.location != null) {
            //All checked
            //"2021-01-23 09:03"

            //this._latitude, this._longitude
            //-90.0,90.0,_latitude && -180.0,180.0,_longitude Limits
            meeting.location = [this.location.latitude, this.location.longitude];
            EasyLoading.show(
              status: 'loading...',
              maskType: EasyLoadingMaskType.black,
            ).then((value) {
              _addMeeting().then((resultMeeting) {
                //If succesfull run onCreated
                EasyLoading.dismiss().then((value) {
                  if (resultMeeting.id != null) {
                    meeting = resultMeeting;
                    widget.onCreated(resultMeeting);
                    //Exit
                    Navigator.of(context).pop();
                  } else {
                    toast("Please try creating meeting again...");
                  }
                });
                //Else show user error, unable to create-->Try again!
              });
            });
          } else {
            showOkCancelAlertDialog(
              context: context,
              title: 'Create Meeting',
              message: 'Do wish to create a meeting without location?',
              okLabel: 'Yes',
              cancelLabel: 'No',
              defaultType: OkCancelAlertDefaultType.cancel,
            ).then((result) {
              logger.i(result);
              if (OkCancelResult.ok == result) {
                // User wants to use Create the Meeting without location
                EasyLoading.show(
                  status: 'loading...',
                  maskType: EasyLoadingMaskType.black,
                ).then((value) {
                  _addMeeting().then((resultMeeting) {
                    //If succesfull run onCreated
                    EasyLoading.dismiss().then((value) {
                      if (resultMeeting.id != null) {
                        meeting = resultMeeting;
                        widget.onCreated(resultMeeting);
                        //Exit
                        Navigator.of(context).pop();
                      } else {
                        toast("Please try creating meeting again...");
                      }
                    });
                    //Else show user error, unable to create-->Try again!
                  });
                });
              } else {
                // Let User pick a location
              }
            });
          }
        } else {
          toast("Please Pick a date and time...");
        }
      } else {
        toast("Please form completly...");
      }
    }

    Size size = MediaQuery.of(context).size;
    size = new Size(size.width <= 400 ? size.width : 400, size.height);

    Widget _createReunionWidget = Center(
      child: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Container(
          alignment: Alignment.center,
          /* constraints: BoxConstraints.loose(new), */
          child: ReactiveForm(
            formGroup: this.form,
            child: Column(
              /* crossAxisAlignment: CrossAxisAlignment.center, */
              children: <Widget>[
                SizedBox(
                  width: size.width,
                  height: size.height * 0.12,
                  child: TextFieldContainer(
                    child: ReactiveTextField(
                      formControlName: 'name',
                      autofocus: false,
                      cursorColor: kPrimaryColor,
                      decoration: InputDecoration(
                        icon: Icon(
                          Icons.code_sharp,
                          color: kPrimaryColor,
                        ),
                        hintText: "name",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: size.width,
                  height: size.height * 0.12,
                  child: TextFieldContainer(
                    child: ReactiveTextField(
                        formControlName: 'description',
                        autofocus: false,
                        cursorColor: kPrimaryColor,
                        decoration: InputDecoration(
                          icon: Icon(
                            Icons.code_sharp,
                            color: kPrimaryColor,
                          ),
                          hintText: "description",
                          border: InputBorder.none,
                        )),
                  ),
                ),
                SizedBox(
                  width: size.width,
                  height: size.height * 0.12,
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
                    onChanged: (val) => {logger.i(val), dateTimeVal = val},
                    validator: (val) {
                      dateTimeVal = val;
                      return null;
                    },
                    onSaved: (val) => {logger.i(val), dateTimeVal = val},
                  ),
                ),
                SizedBox(
                  width: size.width,
                  height: size.height * 0.09,
                  child: Card(
                    child: ListTile(
                      leading: Icon(
                        Icons.map,
                        color: kPrimaryColor,
                      ),
                      title: Text("Pick a location..."),
                      trailing: Icon(
                        Icons.add_location_alt_sharp,
                        color: kPrimaryColor,
                      ),
                      onTap: () {
                        //on Tap of this
                        logger.d("Pick a location pressed...");
                        pushNewScreen(
                          context,
                          screen: MapLeaflet(
                            onLocationPicked: (location) {
                              // Only called if the user selected a location
                              logger.i("Location Picked: " + location.toString());
                              this.location = location;
                            },
                          ),
                          withNavBar: false, // OPTIONAL VALUE. True by default.
                          pageTransitionAnimation: PageTransitionAnimation.cupertino,
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(
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
                            press: createMeeting,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: size.width,
                  height: size.height * 0.01,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: SizedBox(height: 6, width: size.width),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    return SafeArea(
      child: Scaffold(
        body: Background(
          child: _createReunionWidget,
        ),
      ),
    );
  }
}
