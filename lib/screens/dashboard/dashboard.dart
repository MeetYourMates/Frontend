import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:flutter/material.dart';
import 'package:meet_your_mates/api/services/socket_service.dart';
import 'package:meet_your_mates/api/services/student_service.dart';
import 'package:meet_your_mates/components/statefull_wrapper.dart';
import 'package:meet_your_mates/constants.dart';
import 'package:meet_your_mates/screens/Chat/chatSummaryList.dart';
import 'package:meet_your_mates/screens/Profile/profile.dart';
import 'package:meet_your_mates/screens/Projects/projects.dart';
import 'package:meet_your_mates/screens/SearchMates/searchMates.dart';
import 'package:provider/provider.dart';
//Services

//Utilities

//Screens

//Models

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
    StudentProvider _studentProvider = Provider.of<StudentProvider>(context);
    //StudentProvider _studentProvider = Provider.of<StudentProvider>(context);
    //SocketService socketService = new SocketService();
    Future<void> openSocketConnection() async {
      Provider.of<SocketProvider>(context, listen: true).createSocketConnection(
          _studentProvider.student.user.token,
          _studentProvider.student.user.id);
    }

    PersistentTabController _controller;
    _controller = PersistentTabController(initialIndex: 0);
    bool _hideNavBar = false;

    List<Widget> _buildScreens() {
      return [
        Profile(),
        ChatSummaryList(),
        SearchMates(),
        Projects(),
        SearchMates()
      ];
    }

    List<PersistentBottomNavBarItem> _navBarsItems() {
      return [
        PersistentBottomNavBarItem(
          icon: Icon(Icons.person),
          title: ("Profile"),
          activeColor: Colors.cyan,
          inactiveColor: Colors.grey,
        ),
        PersistentBottomNavBarItem(
          icon: Icon(Icons.chat_bubble),
          title: ("Chat"),
          activeColor: Colors.cyan,
          inactiveColor: Colors.grey,
        ),
        PersistentBottomNavBarItem(
          icon: Icon(Icons.home, color: Colors.white),
          title: ("Home"),
          activeColor: Colors.cyan,
          inactiveColor: Colors.grey,
        ),
        PersistentBottomNavBarItem(
          icon: Icon(Icons.assignment_rounded),
          title: ("Projects"),
          activeColor: Colors.cyan,
          inactiveColor: Colors.grey,
        ),
        PersistentBottomNavBarItem(
          icon: Icon(Icons.search),
          title: ("Mates"),
          activeColor: Colors.cyan,
          inactiveColor: Colors.grey,
        ),
      ];
    }

    return StatefulWrapper(
        onInit: () {
          //Connect to Socket
          openSocketConnection();
        },
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize:
                Size.fromHeight(kAppBarHeight), // here the desired height
            child: AppBar(
              title: Text("Meet Your Mates"),
              backgroundColor: Colors.cyan,
              actions: <Widget>[
                IconButton(
                    icon: Icon(Icons.notifications_none_rounded),
                    onPressed: () {
                      //showSearch(context: context, delegate: DataSearch(listWords));
                    })
              ],
            ),
          ),
          body: SizedBox.expand(
              child: PersistentTabView(
            context,
            controller: _controller,
            screens: _buildScreens(),
            items: _navBarsItems(),
            confineInSafeArea: true,
            backgroundColor: Colors.cyan[100],
            handleAndroidBackButtonPress: true,
            resizeToAvoidBottomInset:
                true, // This needs to be true if you want to move up the screen when keyboard appears.
            stateManagement: true,
            hideNavigationBarWhenKeyboardShows:
                true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument.
            hideNavigationBar: _hideNavBar,
            decoration: NavBarDecoration(
              borderRadius: BorderRadius.circular(30.0),
              colorBehindNavBar: Colors.white,
            ),
            popAllScreensOnTapOfSelectedTab: true,
            popActionScreens: PopActionScreensType.all,
            itemAnimationProperties: ItemAnimationProperties(
              // Navigation Bar's items animation properties.
              duration: Duration(milliseconds: 200),
              curve: Curves.ease,
            ),
            screenTransitionAnimation: ScreenTransitionAnimation(
              // Screen transition animation on change of selected tab.
              animateTabTransition: true,
              curve: Curves.ease,
              duration: Duration(milliseconds: 200),
            ),
            navBarStyle: NavBarStyle
                .style15, // Choose the nav bar style with this property.
          )),
        ));
  }
}
