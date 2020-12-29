import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:meet_your_mates/api/models/user.dart';
import 'package:meet_your_mates/api/models/users.dart';
import 'package:meet_your_mates/api/services/socket_service.dart';
//Services
import 'package:meet_your_mates/api/services/student_service.dart';
import 'package:meet_your_mates/screens/Chat/chatSummaryView.dart';
//Screens
import 'package:meet_your_mates/screens/Login/background.dart';
import 'package:provider/provider.dart';

//Models
//Components

class ChatSummaryList extends StatefulWidget {
  @override
  _ChatSummaryListState createState() => _ChatSummaryListState();
}

class _ChatSummaryListState extends State<ChatSummaryList> {
  var logger = Logger();

  @override
  Widget build(BuildContext context) {
    Users usersList = Provider.of<SocketProvider>(context, listen: true).users;
    // ignore: unused_local_variable
    StudentProvider _studentProvider = Provider.of<StudentProvider>(context);
    // ignore: unused_local_variable
    var loading = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[CircularProgressIndicator(), Text(" Getting Users Online... Please wait")],
    );

    // ignore: unused_local_variable
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Background(
          child: Container(
            child: ListView.builder(
              itemCount: usersList.usersList != null ? usersList.usersList.length : 0,
              itemBuilder: (context, index) {
                User currUsr = usersList.usersList[index];
                return ChatSummaryView(
                  messageDate: '18:13',
                  mostRecentMessage:
                      currUsr.messagesList.isNotEmpty ? currUsr.messagesList.last.text : "",
                  name: currUsr.name != null ? currUsr.name : "No Name",
                  unreadMessagesCount: 1,
                  viewIndex: index,
                  avatar: currUsr.picture != null ? currUsr.picture : "No picture",
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
