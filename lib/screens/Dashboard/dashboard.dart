import 'package:flutter/material.dart';
import 'package:meet_your_mates/api/services/socket_service.dart';
import 'package:meet_your_mates/api/services/student_service.dart';
import 'package:meet_your_mates/components/statefull_wrapper.dart';
import 'package:meet_your_mates/screens/Projects/projects.dart';
import 'package:meet_your_mates/screens/SearchMates/searchMates.dart';
import 'package:provider/provider.dart';
import 'package:meet_your_mates/screens/Chat/chatSummaryList.dart';
import 'package:meet_your_mates/screens/Profile/profile.dart';

import 'bottom_bar.dart';
//Services

//Utilities

//Screens

//Models
//ignore: must_be_immutable
/*class DashBoard extends StatefulWidget {
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  List usersList = [];
  //SocketService socketService;

  @override
  void initState() {
    super.initState();
    //Socket Start
    //socketService.createSocketConnection();
    //socketService = Injector.instance.get<SocketService>();
  }

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

    return StatefulWrapper(
        onInit: () {
          //Connect to Socket
          openSocketConnection();
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.cyan,
            elevation: 0.0,
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {},
            ),
            title: Text('Meet Your Mates',
                style: TextStyle(
                    fontFamily: 'Varela', fontSize: 30.0, color: Colors.white)),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.notifications_none, color: Colors.white),
                onPressed: () {},
              ),
            ],
          ),
          body: ListView(
            padding: EdgeInsets.only(left: 20.0),
            children: <Widget>[
              SizedBox(height: 15.0),
              Text('Team Up!',
                  style: TextStyle(
                      fontFamily: 'Varela',
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold)),
              SizedBox(height: 15.0),
              /*DefaultTabController(
                length: 2,
                child: TabBar(
                    indicatorColor: Colors.transparent,
                    labelColor: Colors.cyan,
                    labelPadding: EdgeInsets.only(right: 45.0),
                    unselectedLabelColor: Color(0xFFCDCDCD),
                    tabs: [
                      (Text('My Mates',
                          style: TextStyle(
                            fontFamily: 'Varela',
                            fontSize: 21.0,
                          ))),
                      Tab(
                        child: Text('Projects',
                            style: TextStyle(
                              fontFamily: 'Varela',
                              fontSize: 21.0,
                            )),
                      )
                    ]),
              ),
              TabBarView(children: [
                SearchMates(),
                Projects(),
              ])*/
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {},
            backgroundColor: Colors.cyan,
            child: IconButton(
                icon: Icon(Icons.home),
                onPressed: () {
                  SearchMates();
                }),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: BottomBar(),
        ));
  }
}*/
class DashBoard extends StatefulWidget {
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        elevation: 0.0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {},
        ),
        title: Text('Meet Your Mates',
            style: TextStyle(
                fontFamily: 'Varela', fontSize: 30.0, color: Colors.white)),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.notifications_none, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.only(left: 20.0),
        children: <Widget>[
          SizedBox(height: 15.0),
          Text('Team Up!',
              style: TextStyle(
                  fontFamily: 'Varela',
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold)),
          SizedBox(height: 15.0),
          TabBar(
              controller: _tabController,
              indicatorColor: Colors.transparent,
              labelColor: Colors.cyan,
              isScrollable: true,
              labelPadding: EdgeInsets.only(right: 45.0),
              unselectedLabelColor: Color(0xFFCDCDCD),
              tabs: [
                Tab(
                  child: Text('My Mates',
                      style: TextStyle(
                        fontFamily: 'Varela',
                        fontSize: 21.0,
                      )),
                ),
                Tab(
                  child: Text('Projects',
                      style: TextStyle(
                        fontFamily: 'Varela',
                        fontSize: 21.0,
                      )),
                )
              ]),
          Container(
              height: MediaQuery.of(context).size.height - 50.0,
              width: double.infinity,
              child: TabBarView(controller: _tabController, children: [
                SearchMates(),
                Projects(),
              ]))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Projects();
        },
        backgroundColor: Colors.cyan,
        child: Icon(Icons.home),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          notchMargin: 6.0,
          color: Colors.transparent,
          elevation: 9.0,
          clipBehavior: Clip.antiAlias,
          child: Container(
              height: 50.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25.0),
                      topRight: Radius.circular(25.0)),
                  color: Colors.white),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        height: 50.0,
                        width: MediaQuery.of(context).size.width / 2 - 40.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            IconButton(
                                icon: Icon(Icons.chat_bubble),
                                color: Colors.cyan,
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ChatSummaryList()));
                                }),
                            IconButton(
                                icon: Icon(Icons.person_outline),
                                color: Colors.cyan,
                                onPressed: () {
                                  Profile();
                                })
                          ],
                        )),
                    Container(
                        height: 50.0,
                        width: MediaQuery.of(context).size.width / 2 - 40.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            IconButton(
                                icon: Icon(Icons.search),
                                color: Colors.cyan,
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SearchMates()));
                                }),
                            IconButton(
                                icon: Icon(Icons.assignment_rounded),
                                color: Colors.cyan,
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Projects()));
                                })
                          ],
                        )),
                  ]))),
    );
  }
}
