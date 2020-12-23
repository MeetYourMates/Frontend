import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:meet_your_mates/api/util/shared_preference.dart';
import 'package:meet_your_mates/components/rounded_button.dart';
import 'package:meet_your_mates/constants.dart';
import 'package:meet_your_mates/screens/Chat/chatSummaryList.dart';

class DashBoard extends StatefulWidget {
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  int _currentIndex = 0;
  List usersList = [];
  PageController _pageController;
  //SocketService socketService;
  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    //Socket Start
    //socketService.createSocketConnection();
    //socketService = Injector.instance.get<SocketService>();
  }

  @override
  void dispose() {
    _pageController.dispose();

    super.dispose();
  }

  /// =======================================================================================================================
  ///                                                    DASHBOARD
  ///=======================================================================================================================**/
  @override
  Widget build(BuildContext context) {
    //StudentProvider _studentProvider = Provider.of<StudentProvider>(context);
    //SocketService socketService = new SocketService();
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(kAppBarHeight), // here the desired height
        child: AppBar(
          title: Text("Meet Your Mates"),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  //showSearch(context: context, delegate: DataSearch(listWords));
                })
          ],
        ),
      ),
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
              child: ChatSummaryList(),
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
