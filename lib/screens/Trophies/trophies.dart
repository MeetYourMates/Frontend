import 'package:meet_your_mates/api/models/trophy.dart';
import 'package:flutter/material.dart';
//Services

//Utilities

//Constants

//Screens
import 'package:meet_your_mates/screens/Trophies/background.dart';

//Models

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
  List<Trophy> trophies;

  void initState() {
    trophies = [
      new Trophy(
          title: "Non-sleeper",
          difficulty: 4,
          professor: "Toni",
          dateTime: "02/12/2020",
          logo: 'assets/icons/trophy.png'),
      new Trophy(
          title: "Blog writter",
          difficulty: 2,
          professor: "Antonia",
          dateTime: "15/11/2020",
          logo: 'assets/icons/trophy.png'),
      new Trophy(
          title: "Scrum Master",
          difficulty: 5,
          professor: "Toni",
          dateTime: "25/06/2020",
          logo: 'assets/icons/trophy.png'),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) => TrophyCard(
        title: trophies[index].title,
        date: trophies[index].dateTime,
        difficulty: trophies[index].difficulty,
        logo: trophies[index].logo,
        professor: trophies[index].professor,
      ),
      shrinkWrap: true,
      itemCount: trophies.length,
    );
  }
}

class TrophyCard extends StatelessWidget {
  final String title;
  final String date;
  final double difficulty;
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
                        this.date +
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
