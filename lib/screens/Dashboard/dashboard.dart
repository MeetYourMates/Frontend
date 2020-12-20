import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:meet_your_mates/api/services/stream_socket_service.dart';
import 'package:meet_your_mates/api/util/shared_preference.dart';
import 'package:meet_your_mates/components/rounded_button.dart';
import 'package:meet_your_mates/components/statefulwrapper.dart';
import 'package:provider/provider.dart';

//Models

class DashBoard extends StatefulWidget {
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  int _currentIndex = 0;
  List usersList = [];
  Stream<String> streamUsers;
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

  /// =======================
  ///        DashBoard
  ///
  ///
  ///========================
  @override
  Widget build(BuildContext context) {
    StreamSocketProvider _streamSocketProvider =
        Provider.of<StreamSocketProvider>(context, listen: true);

    //StudentProvider _studentProvider = Provider.of<StudentProvider>(context);
    //SocketService socketService = new SocketService();
    return StatefulWrapper(
      onInit: () => {
        //(_studentProvider.student.user.token),
        streamUsers =
            _streamSocketProvider.streamUsers.stream.asBroadcastStream(),
        _streamSocketProvider.sendOnlineUsers(null),
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Meet Your Mates"),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  //showSearch(context: context, delegate: DataSearch(listWords));
                })
          ],
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
                child: StreamBuilder(
                  stream: streamUsers,
                  builder:
                      (BuildContext context, AsyncSnapshot<String> snapshot) {
                    return Container(
                        child: RichText(
                      text: TextSpan(
                          text: snapshot.hasData
                              ? snapshot.data
                              : "Waiting for Data...",
                          style: DefaultTextStyle.of(context).style),
                    ));
                  },
                ),
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
            if (_currentIndex == 2) {
              _streamSocketProvider.sendOnlineUsers(null);
            }
          },
          items: <BottomNavyBarItem>[
            BottomNavyBarItem(title: Text('Home'), icon: Icon(Icons.home)),
            BottomNavyBarItem(title: Text('Search'), icon: Icon(Icons.search)),
            BottomNavyBarItem(
                title: Text('Chat'), icon: Icon(Icons.chat_bubble)),
            BottomNavyBarItem(title: Text('Profile'), icon: Icon(Icons.person)),
          ],
        ),
      ),
    );
  }
}
