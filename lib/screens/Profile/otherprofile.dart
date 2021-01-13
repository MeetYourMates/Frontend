import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:meet_your_mates/api/models/user.dart';
import 'package:meet_your_mates/api/services/mate_provider.dart';
import 'package:meet_your_mates/api/services/socket_service.dart';
import 'package:meet_your_mates/screens/Chat/chatDetail.dart';
import 'package:meet_your_mates/screens/Chat/chatDetail2.dart';
import 'package:meet_your_mates/screens/Insignias/background.dart';
import 'package:meet_your_mates/screens/Insignias/insignias.dart';
import 'package:meet_your_mates/screens/Trophies/trophies.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

import '../../api/services/auth_service.dart';

class OtherProfile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<OtherProfile> {
  final formKey = new GlobalKey<FormState>();
  var logger = Logger();

  _ProfileState();

  @override
  Widget build(BuildContext context) {
    MateProvider _studentProvider = Provider.of<MateProvider>(context);
    AuthProvider _authProvider = Provider.of<AuthProvider>(context, listen: false);
    double meanRating = 0;
    /*for (int i = 0; i < _studentProvider.student.ratings.length; i++) {
      meanRating = (meanRating + _studentProvider.student.ratings[i].stars);
    }

    meanRating = meanRating / (_studentProvider.student.ratings.length + 1);
    */
    return SafeArea(
      child: Scaffold(
        body: Background(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Header(
                  icon: _studentProvider.student.user.picture,
                ),
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
                  itemBuilder: (context, index) => SendMessage(
                    authProvider: _authProvider,
                    usr: _studentProvider.student.user,
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

class SendMessage extends StatelessWidget {
  final AuthProvider authProvider;
  final User usr;
  const SendMessage({Key key, this.authProvider, this.usr}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SocketProvider socketProvider = Provider.of<SocketProvider>(context, listen: false);
    // ignore: unused_element
    void openChat(User user) {
      //Search if This user is already a mate
      int index = socketProvider.mates.usersList.indexOf(user);
      //If yes --> Open ChatDetail with Chathistory
      if (index != -1) {
        /* Navigator.push(
          context,
          new MaterialPageRoute(
            builder: (context) => new ChatDetailPage(
              selectedIndex: index,
            ),
          ),
        ); */
        pushNewScreen(
          context,
          screen: ChatDetailPage(
            selectedIndex: index,
          ),
          withNavBar: false, // OPTIONAL VALUE. True by default.
          pageTransitionAnimation: PageTransitionAnimation.cupertino,
        );
      } else {
        //Else --> New Mate maybe --> Temporary ChatDetail or ChatDetail2!
        socketProvider.tempMate = user;
        socketProvider.askTempMateStatus(user.id);
        Navigator.push(
          context,
          new MaterialPageRoute(
            builder: (context) => new ChatDetailPage2(),
          ),
        );
      }
    }

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
                  openChat(usr);
                },
                icon: Icon(
                  Icons.chat_bubble,
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
                    "Send Message",
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
