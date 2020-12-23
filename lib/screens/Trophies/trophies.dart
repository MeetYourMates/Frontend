import 'package:meet_your_mates/api/models/trophy.dart';
import 'package:flutter/material.dart';
//Services

//Utilities

//Constants
import 'package:provider/provider.dart';
import 'package:logger/logger.dart';
//Screens
import 'package:meet_your_mates/screens/Trophies/background.dart';

//Models
import 'package:meet_your_mates/api/services/student_service.dart';
//Components

class Trophies extends StatefulWidget {
  @override
  _TrophiesState createState() => _TrophiesState();
}

class _TrophiesState extends State<Trophies> {
  final formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Trophies"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.info),
              color: Colors.white,
              onPressed: () {},
            )
          ],
        ),
        body: Background(
          child: TrophyList(),
        ),
      ),
    );
  }
}

class TrophyList extends StatefulWidget {
  @override
  _TrophyListState createState() => _TrophyListState();
}

class _TrophyListState extends State<TrophyList> {
  var logger = Logger();

  @override
  Widget build(BuildContext context) {
    StudentProvider _studentProvider = Provider.of<StudentProvider>(context);
    List<Trophy> trophies = _studentProvider.student.trophies;

    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) => TrophyCard(
        title: trophies[index].title,
        date: trophies[index].date,
        difficulty: trophies[index].difficulty,
        logo: trophies[index].logo,
        professor: trophies[index].professorId,
      ),
      shrinkWrap: true,
      itemCount: trophies.length,
    );
  }
}

class TrophyCard extends StatelessWidget {
  final String title;
  final String date;
  final int difficulty;
  final String logo;
  final String professor;

  const TrophyCard(
      {Key key,
      @required this.title,
      @required this.date,
      @required this.logo,
      @required this.difficulty,
      @required this.professor})
      : super(key: key);

  String timeAgo(DateTime d) {
    Duration diff = DateTime.now().difference(d);
    if (diff.inDays > 365)
      return "${(diff.inDays / 365).floor()} ${(diff.inDays / 365).floor() == 1 ? "year" : "years"} ago";
    if (diff.inDays > 30)
      return "${(diff.inDays / 30).floor()} ${(diff.inDays / 30).floor() == 1 ? "month" : "months"} ago";
    if (diff.inDays > 7)
      return "${(diff.inDays / 7).floor()} ${(diff.inDays / 7).floor() == 1 ? "week" : "weeks"} ago";
    if (diff.inDays > 0)
      return "${diff.inDays} ${diff.inDays == 1 ? "day" : "days"} ago";
    if (diff.inHours > 0)
      return "${diff.inHours} ${diff.inHours == 1 ? "hour" : "hours"} ago";
    if (diff.inMinutes > 0)
      return "${diff.inMinutes} ${diff.inMinutes == 1 ? "minute" : "minutes"} ago";
    return "just now";
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 21.0,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.celebration,
                  size: 40.0,
                  color: Colors.blue,
                ),
              ),
              SizedBox(width: 24.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    this.title,
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    "Assigned by: " + this.professor,
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 12.0,
                    ),
                  ),
                  Text(
                    "Date: " +
                        timeAgo(DateTime.parse(this.date)) +
                        ", difficulty: " +
                        this.difficulty.toString(),
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 12.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
