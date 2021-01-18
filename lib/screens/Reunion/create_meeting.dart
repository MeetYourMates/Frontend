import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:logger/logger.dart';
import 'package:meet_your_mates/api/models/meeting.dart';
//Models
import 'package:meet_your_mates/api/services/student_service.dart';
import 'package:meet_your_mates/components/rounded_button.dart';
import 'package:meet_your_mates/components/text_field_container.dart';
import 'package:meet_your_mates/constants.dart';
import 'package:meet_your_mates/screens/Reunion/background.dart';
import 'package:overlay_support/overlay_support.dart';
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
      logger.d("_memoizer Reunions Executed");
      Meeting result = await _studentProvider.createMeeting(widget.teamId, meeting);
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
          _addMeeting().then((resultMeeting) {
            //If succesfull run onCreated
            EasyLoading.dismiss().then((value) {
              if (resultMeeting.id != null) {
                meeting = resultMeeting;
                widget.onCreated(resultMeeting);
              } else {
                toast("Please try creating meeting again...");
              }
            });
            //Else show user error, unable to create-->Try again!
          });
        });
      } else {
        toast("Please form completly...");
      }
    }

    Size size = MediaQuery.of(context).size * 0.95;
    Widget _createReunionWidget = Center(
      child: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Container(
          alignment: Alignment.center,
          constraints: BoxConstraints.tightForFinite(width: 400, height: size.height * 0.95),
          child: ReactiveForm(
            formGroup: this.form,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: size.width,
                  height: size.height * 0.20,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Text(
                      "Create a Reunion",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: kPrimaryColor),
                    ),
                  ),
                ),
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
                    initialValue: DateTime.now().toString(),
                    firstDate: DateTime(2021),
                    lastDate: DateTime(2100),
                    icon: Icon(Icons.event),
                    dateLabelText: 'Date',
                    timeLabelText: "Hour",
                    onChanged: (val) => {dateTimeVal = val},
                    validator: (val) {
                      dateTimeVal = val;
                      return null;
                    },
                    onSaved: (val) => {dateTimeVal = val},
                  ),
                ),
                SizedBox(
                  width: size.width,
                  height: size.height * 0.08,
                  child: RoundedButton(
                    text: "Create",
                    press: createMeeting,
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
