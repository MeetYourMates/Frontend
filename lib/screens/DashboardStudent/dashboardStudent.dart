import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:meet_your_mates/api/models/invitation.dart';
import 'package:meet_your_mates/api/services/appbar_service.dart';
import 'package:meet_your_mates/api/services/socket_service.dart';
import 'package:meet_your_mates/api/services/student_service.dart';
import 'package:meet_your_mates/api/util/route_uri.dart';
import 'package:meet_your_mates/components/statefull_wrapper.dart';
import 'package:meet_your_mates/constants.dart';
import 'package:meet_your_mates/screens/Chat/chatSummaryList.dart';
import 'package:meet_your_mates/screens/Home/home.dart';
import 'package:meet_your_mates/screens/ProfileStudent/profile_student.dart';
import 'package:meet_your_mates/screens/ProjectsSudent/projectsStudent.dart';
import 'package:meet_your_mates/screens/SearchMates/searchMates.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
//Services

//Utilities

//Screens

//Models

class DashBoardStudent extends StatefulWidget {
  @override
  _DashBoardStudentState createState() => _DashBoardStudentState();
}


class _DashBoardStudentState extends State<DashBoardStudent> {
  List usersList = [];
  Logger logger = Logger(level: Level.debug);
  PageController _pageController;
  //SocketService socketService;
  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  ValueNotifier<String> listentabletTitle = ValueNotifier<String>("Meets Your Mates");
  AppBarProvider _appBarProvider;
  StudentProvider _studentProvider;
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
    _studentProvider = Provider.of<StudentProvider>(context);
    _appBarProvider = Provider.of<AppBarProvider>(context, listen: true);
    PersistentTabController _controller;
    _controller = PersistentTabController(initialIndex: 2);
    bool _hideNavBar = false;

    /// Opens Socket Connection for User Chat
    Future<void> openSocketConnection() async {
      Provider.of<SocketProvider>(context, listen: false)
          .createSocketConnection(_studentProvider.student.user.token, _studentProvider.student.user.id);
    }

    void showInv() async{
      List<Invitation> invitations = await _studentProvider.getInvitations(_studentProvider.student.id);
      showModalBottomSheet(
          context: context,
          builder: (context) {
            Size size = MediaQuery.of(context).size;
            return Container(
              //constraints:
              //BoxConstraints.tightForFinite(width: size.width, height: size.height * 0.5),
              color: Color(0xff737373),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: SizedBox(
                        height: 4,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Center(
                        child: Container(
                          width: size.width * 0.30,
                          color: Colors.grey.shade200,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: SizedBox(
                        height: 1,
                      ),
                    ),
                    Flexible(
                      flex: 96,
                      child: ListView.builder(
                        itemCount: invitations.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Container(
                            //padding: EdgeInsets.only(top: 10, bottom: 10),
                            child: Column(
                              children: [
                                ListTile(
                                  leading: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Icon(
                                      Icons.add_alarm
                                    ),
                                  ),
                                  title: Text(invitations[index].sender + " te ha invitado a " + invitations[index].group),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    FlatButton(onPressed: () => {_studentProvider.AcceptOrRejectInv(invitations[index], "accept")}, child: Text("Accept")),
                                    FlatButton(onPressed: () => {_studentProvider.AcceptOrRejectInv(invitations[index], "reject")}, child: Text("Reject")),
                                  ],
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
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
        ProfileStudent(onTapLogOut: () {
          logger.d("LogOut Pressed");
          Navigator.popAndPushNamed(context, RouteUri.login);
        }),
        ChatSummaryList(),
        Home(),
        ProjectsStudent(),
        SearchMates()
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
          title: ("Mates"),
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
                      onPressed: showInv,
                  )],
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
