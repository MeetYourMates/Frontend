import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:meet_your_mates/api/services/student_service.dart';
import 'package:meet_your_mates/api/util/shared_preference.dart';
import 'package:meet_your_mates/components/rounded_button.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
//Services

//Utilities

//Models

class DashBoard extends StatefulWidget {
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  int _currentIndex = 0;
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Meet Your Mates")),
      body: SizedBox.expand(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => _currentIndex = index);
          },
          children: <Widget>[
            Container(
              color: Colors.blueGrey,
            ),
            Container(
              color: Colors.red,
            ),
            Container(
              color: Colors.green,
            ),
            Container(
                color: Colors.blue,
                child: RoundedButton(
                  text: "LOGOUT",
                  press: () => {
                    UserPreferences().removeUser(),
                    Navigator.pushReplacementNamed(context, '/login')
                  },
                )),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _currentIndex,
        onItemSelected: (index) {
          setState(() => _currentIndex = index);
          _pageController.jumpToPage(index);
        },
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(title: Text('Home'), icon: Icon(Icons.home)),
          BottomNavyBarItem(title: Text('Search'), icon: Icon(Icons.search)),
          BottomNavyBarItem(title: Text('Chat'), icon: Icon(Icons.chat_bubble)),
          BottomNavyBarItem(title: Text('Profile'), icon: Icon(Icons.person)),
        ],
      ),
    );
  }
}
