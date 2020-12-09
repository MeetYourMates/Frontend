import 'package:flutter/material.dart';
import 'package:meet_your_mates/screens/Insignias/background.dart';
import 'package:meet_your_mates/screens/Insignias/insignias.dart';
import 'package:meet_your_mates/screens/Trophies/trophies.dart';
import 'package:meet_your_mates/screens/Login/login.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:meet_your_mates/api/services/student_service.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final formKey = new GlobalKey<FormState>();

  _ProfileState();

  @override
  Widget build(BuildContext context) {
    StudentProvider _studentProvider = Provider.of<StudentProvider>(context);

    return Scaffold(
      body: Background(
        child: Column(
          children: <Widget>[
            Header(
              icon: 'assets/images/profileExample.jpg',
            ),
            StackContainer(
              username: _studentProvider.student.user.email + ".name",
              email: _studentProvider.student.user.email,
            ),
            Rating(rating: 3),
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) => InsigniaCard(),
              shrinkWrap: true,
              itemCount: 1,
            ),
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) => TrophiesCard(),
              shrinkWrap: true,
              itemCount: 1,
            ),
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) => LogOutCard(),
              shrinkWrap: true,
              itemCount: 1,
            ),
          ],
        ),
      ),
    );
  }
}

class StackContainer extends StatelessWidget {
  final String username;
  final String email;

  const StackContainer({Key key, @required this.username, @required this.email})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 43.0,
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment(0, 1),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(height: 4.0),
                Text(
                  this.username != null ? this.username : "Error",
                  style: TextStyle(
                    fontSize: 21.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  this.email,
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
          TopBar(),
        ],
      ),
    );
  }
}

class Header extends StatelessWidget {
  final String icon;

  const Header({Key key, @required this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      padding: EdgeInsets.only(bottom: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          UserPhoto(
            assetImage: this.icon,
          ),
        ],
      ),
    );
  }
}

class UserPhoto extends StatelessWidget {
  final String assetImage;

  const UserPhoto({
    Key key,
    @required this.assetImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(this.assetImage),
          fit: BoxFit.cover,
        ),
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white,
          width: 5,
        ),
      ),
      margin: EdgeInsets.only(bottom: 10),
    );
  }
}

class TopBar extends StatelessWidget {
  const TopBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.menu, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class InsigniaCard extends StatelessWidget {
  const InsigniaCard({
    Key key,
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
                onPressed: () {
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => new Insignias()));
                },
                icon: Icon(
                  Icons.album_sharp,
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
                    "Insignias",
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    "Click to see all insignias",
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

class TrophiesCard extends StatelessWidget {
  const TrophiesCard({
    Key key,
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
                onPressed: () {
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => new Trophies()));
                },
                icon: Icon(
                  Icons.amp_stories_rounded,
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
                    "Trophies",
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    "Click to see all trophies",
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

class LogOutCard extends StatelessWidget {
  const LogOutCard({
    Key key,
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
                onPressed: () {
                  Navigator.push(context,
                      new MaterialPageRoute(builder: (context) => new Login()));
                },
                icon: Icon(
                  Icons.logout,
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
                    "LogOut",
                    style: TextStyle(
                      fontSize: 18.0,
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

class Rating extends StatelessWidget {
  final double rating;
  const Rating({
    Key key,
    @required this.rating,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                width: 150,
                height: 20,
                child: SmoothStarRating(
                  size: 30,
                  color: Colors.yellow,
                  rating: rating,
                  isReadOnly: true,
                  defaultIconData: Icons.star_border,
                  halfFilledIconData: Icons.star_half,
                  borderColor: Colors.black,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
