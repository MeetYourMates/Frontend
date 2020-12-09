import 'package:meet_your_mates/api/models/insignia.dart';
import 'package:flutter/material.dart';
//Services

//Utilities

//Constants

//Screens
import 'package:meet_your_mates/screens/Login/background.dart';

//Models

//Components

class Insignias extends StatefulWidget {
  @override
  _InsigniasState createState() => _InsigniasState();
}

class _InsigniasState extends State<Insignias> {
  final formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Insignias"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.info),
              color: Colors.white,
              onPressed: () {},
            )
          ],
        ),
        body: Background(
          child: InsigniaList(
          ),
        ),
      ),
    );
  }
}

class InsigniaList extends StatefulWidget {
  @override
  _InsigniaListState createState() => _InsigniaListState();
}

class _InsigniaListState extends State<InsigniaList> {
  List<Insignia> insignias;

  void initState() {
    insignias = [
      new Insignia(
          hashtag: "Javascript",
          requirement: 4,
          dateTime: "02/12/2020",
          logo: 'assets/icons/insignia.png'),
      new Insignia(
          hashtag: "Typescript",
          requirement: 5,
          dateTime: "12/09/2020",
          logo: 'assets/icons/insignia.png'),
      new Insignia(
          hashtag: "C#",
          requirement: 1,
          dateTime: "17/02/2019",
          logo: 'assets/icons/insignia.png'),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) => InsigniaCard(hashtag: insignias[index].hashtag, date: insignias[index].dateTime, requirement: insignias[index].requirement, logo: insignias[index].logo,),
              shrinkWrap: true,
              itemCount: insignias.length,
      );
  }
}

class InsigniaCard extends StatelessWidget {
  final String hashtag;
  final String date;
  final double requirement;
  final String logo;

  const InsigniaCard({
    Key key,
    @required this.hashtag,
    @required this.date,
    @required this.logo,
    @required this.requirement
  }) : super(key: key);

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
                  Icons.badge,
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
                    this.hashtag,
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    "Date: " + this.date + ", Requirement: " + this.requirement.toString(),
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
