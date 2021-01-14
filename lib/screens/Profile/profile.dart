import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:meet_your_mates/api/services/socket_service.dart';
import 'package:meet_your_mates/api/services/student_service.dart';
import 'package:meet_your_mates/api/util/shared_preference.dart';
import 'package:meet_your_mates/screens/Insignias/background.dart';
import 'package:meet_your_mates/screens/Insignias/insignias.dart';
import 'package:meet_your_mates/screens/Profile/edit_profile.dart';
import 'package:meet_your_mates/screens/Trophies/trophies.dart';
import 'package:provider/provider.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

import '../../api/services/auth_service.dart';

class Profile extends StatefulWidget {
  final Function onTapLogOut;
  Profile({Key key, @required this.onTapLogOut}) : super(key: key);
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final formKey = new GlobalKey<FormState>();
  var logger = Logger();

  _ProfileState();

  @override
  Widget build(BuildContext context) {
    StudentProvider _studentProvider = Provider.of<StudentProvider>(context);
    AuthProvider _authProvider = Provider.of<AuthProvider>(context, listen: false);
    double meanRating = 0;
    for (int i = 0; i < _studentProvider.student.ratings.length; i++) {
      meanRating = (meanRating + _studentProvider.student.ratings[i].stars);
    }

    meanRating = meanRating / (_studentProvider.student.ratings.length + 1);

    return SafeArea(
      child: Scaffold(
        body: Background(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Header(
                  icon: _studentProvider.student.user.picture,
                ),
                editButton(context: context),
                StackContainer(
                  username: _studentProvider.student.user.name,
                  email: _studentProvider.student.user.email,
                ),
                RatingStars(rating: meanRating),
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
                  itemBuilder: (context, index) => LogOutCard(
                    authProvider: _authProvider,
                    onTap: widget.onTapLogOut,
                  ),
                  shrinkWrap: true,
                  itemCount: 1,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class StackContainer extends StatelessWidget {
  final String username;
  final String email;

  const StackContainer({Key key, @required this.username, @required this.email}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          UserPhoto(
            imageProfile: icon,
          ),
        ],
      ),
    );
  }
}

class UserPhoto extends StatelessWidget {
  final String imageProfile;

  const UserPhoto({
    Key key,
    @required this.imageProfile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(this.imageProfile),
          fit: BoxFit.fill,
        ),
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.grey,
          width: 3,
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
                  Navigator.push(context, new MaterialPageRoute(builder: (context) => new Insignias()));
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
                  Navigator.push(context, new MaterialPageRoute(builder: (context) => new Trophies()));
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
  final AuthProvider authProvider;
  final Function onTap;
  const LogOutCard({
    Key key,
    this.authProvider,
    @required this.onTap,
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
                  UserPreferences().removeUser();
                  authProvider.signOutGoogle();
                  Provider.of<SocketProvider>(context, listen: false).disconnectSocket();
                  onTap();
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

class RatingStars extends StatelessWidget {
  final double rating;
  const RatingStars({
    Key key,
    @required this.rating,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
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

Container editButton({BuildContext context}) {
  return Container(
    padding: EdgeInsets.only(top: 2.0),
    child: FlatButton(
      onPressed: () {
        Navigator.push(context, new MaterialPageRoute(builder: (context) => new EditProfile()));
      },
      child: Container(
        width: 250.0,
        height: 27.0,
        child: Text(
          "Edit Profile",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.blue,
          border: Border.all(
            color: Colors.blue,
          ),
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
    ),
  );
}
