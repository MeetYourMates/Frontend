import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:meet_your_mates/api/services/appbar_service.dart';
import 'package:meet_your_mates/api/services/professor_service.dart';
import 'package:meet_your_mates/api/services/socket_service.dart';
import 'package:meet_your_mates/api/util/route_uri.dart';
import 'package:meet_your_mates/components/statefull_wrapper.dart';
import 'package:meet_your_mates/constants.dart';
import 'package:meet_your_mates/screens/Chat/chatSummaryList.dart';
import 'package:meet_your_mates/screens/Home/home.dart';
import 'package:meet_your_mates/screens/ProfileProfessor/profile_professor.dart';
import 'package:meet_your_mates/screens/ProjectsProfessor/projectsProfessor.dart';
import 'package:meet_your_mates/screens/SearchStudents/searchStudents.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
//Services

//Utilities

//Screens

//Models

class DashBoardProfessor extends StatefulWidget {
  @override
  _DashBoardProfessorState createState() => _DashBoardProfessorState();
}

class _DashBoardProfessorState extends State<DashBoardProfessor> {
  var logger = Logger(level: Level.debug);
  List usersList = [];
  PageController _pageController;
  ProfessorProvider _professorProvider;
  AppBarProvider _appBarProvider;
  ValueNotifier<String> listentabletTitle = ValueNotifier<String>("Meets Your Mates");
  //SocketService socketService;
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

  /// =======================================================================================================================
  ///                                                    DASHBOARD
  ///=======================================================================================================================**/
  @override
  Widget build(BuildContext context) {
    _professorProvider = Provider.of<ProfessorProvider>(context);
    _appBarProvider = Provider.of<AppBarProvider>(context);
    PersistentTabController _controller;
    _controller = PersistentTabController(initialIndex: 2);
    bool _hideNavBar = false;

    /// Opens Socket Connection for User Chat
    Future<void> openSocketConnection() async {
      Provider.of<SocketProvider>(context, listen: true)
          .createSocketConnection(_professorProvider.professor.user.token, _professorProvider.professor.user.id);
    }

    /// Listens to external events from other screens, when the title changes
    /// in AppBarService, executes this function.
    _appBarProvider.addListener(() {
      listentabletTitle.value = _appBarProvider.title;
      logger.i("Changing appBar Title!");
    });

    ///Listens to Navigation Bottom Bar, when user taps. AppBar Title Changes.
    _controller.addListener(() {
      List<String> _list = ["Profile", "Chat", "Home", "Projects", "Mates"];
      listentabletTitle.value = _list[_controller.index];
    });

    /// Build Screens for the Bottom Navigation Bar, remember this screens are only built once
    /// After than, they are reused. Thus if the screen is a statefull widget, anything
    /// that is outside the build will only be executed once.
    List<Widget> _buildScreens() {
      return [
        ProfileProfessor(onTapLogOut: () {
          logger.d("LogOut Pressed");
          Navigator.popAndPushNamed(context, RouteUri.login);
        }),
        ChatSummaryList(),
        Home(),
        ProjectsProfessor(),
        SearchStudents()
      ];
    }

    /// Bottom Navigation Bar Items, such as the icon and the text.
    List<PersistentBottomNavBarItem> _navBarsItems() {
      return [
        PersistentBottomNavBarItem(
          icon: Icon(Icons.person),
          title: ("Profile"),
          activeColor: Colors.cyan,
          inactiveColor: Colors.black87,
          activeColorAlternate: Colors.cyan[400],
        ),
        PersistentBottomNavBarItem(
          icon: Icon(Icons.chat_bubble),
          title: ("Chat"),
          activeColor: Colors.cyan,
          inactiveColor: Colors.black87,
          activeColorAlternate: Colors.cyan[400],
        ),
        PersistentBottomNavBarItem(
          icon: Icon(Icons.home),
          title: ("Home"),
          activeColor: Colors.cyan,
          inactiveColor: Colors.black87,
          activeColorAlternate: Colors.cyan[400],
        ),
        PersistentBottomNavBarItem(
          icon: Icon(Icons.assignment_rounded),
          title: ("Projects"),
          activeColor: Colors.cyan,
          inactiveColor: Colors.black87,
          activeColorAlternate: Colors.cyan[400],
        ),
        PersistentBottomNavBarItem(
          icon: Icon(Icons.search),
          title: ("Students"),
          activeColor: Colors.cyan,
          inactiveColor: Colors.black87,
          activeColorAlternate: Colors.cyan[400],
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
          preferredSize: Size.fromHeight(kAppBarHeight), // here the desired height
          child: ValueListenableBuilder(
            builder: (BuildContext context, String value, Widget child) {
              // This builder will only get called when the _counter
              // is updated.
              return AppBar(
                title: Text(value),
                backgroundColor: Colors.cyan,
                actions: <Widget>[
                  IconButton(
                      icon: Icon(Icons.notifications_none_rounded),
                      onPressed: () {
                        //showSearch(context: context, delegate: DataSearch(listWords));
                      })
                ],
              );
            },
            valueListenable: listentabletTitle,
            // The child parameter is most helpful if the child is
            // expensive to build and does not depend on the value from
            // the notifier.
            child: Container(),
          ),
        ),
        body: PersistentTabView(
          context,
          controller: _controller,
          screens: _buildScreens(),
          items: _navBarsItems(),
          confineInSafeArea: true,
          backgroundColor: Colors.grey[100],
          handleAndroidBackButtonPress: true,
          resizeToAvoidBottomInset: true, // This needs to be true if you want to move up the screen when keyboard appears.
          stateManagement: true,
          hideNavigationBarWhenKeyboardShows: true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument.
          hideNavigationBar: _hideNavBar,
          margin: EdgeInsets.all(0.0),
          bottomScreenMargin: kBottomNavigationBarHeight,
          decoration: NavBarDecoration(
            borderRadius: BorderRadius.circular(0.0),
            //colorBehindNavBar: Colors.cyan[100],
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
          navBarStyle: NavBarStyle.style3, // Choose the nav bar style with this property.
        ),
      ),
    );
  }
}
