import 'package:flutter/material.dart';
import 'package:meet_your_mates/screens/Chat/chatDetail.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class ChatSummaryView extends StatelessWidget {
  static const Color textUnreadGreenColor = Color.fromARGB(255, 8, 211, 111);
  final String avatar;
  final String name;
  final int viewIndex;
  final String messageDate;
  final String mostRecentMessage;
  final int unreadMessagesCount;
  const ChatSummaryView({
    Key key,
    @required this.name,
    @required this.messageDate,
    @required this.mostRecentMessage,
    @required this.avatar,
    @required this.unreadMessagesCount,
    @required this.viewIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var chatSummaryClicked = () {
      print("User Pressed: " + name);
      pushNewScreen(
        context,
        screen: ChatDetailPage(
          selectedIndex: viewIndex,
        ),
        withNavBar: false, // OPTIONAL VALUE. True by default.
        pageTransitionAnimation: PageTransitionAnimation.cupertino,
      );
    };
    return GestureDetector(
      onTap: chatSummaryClicked,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ListTile(
          leading: avatar != null
              ? CircleAvatar(radius: 30.0, backgroundImage: NetworkImage(avatar))
              : Icon(
                  Icons.account_circle,
                  size: 64.0,
                ),
          title: Text(
            name != null ? name : "No Name",
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.black,
            ),
          ),
          subtitle: Text(
            (mostRecentMessage != null && mostRecentMessage.isNotEmpty) ? mostRecentMessage : "No message",
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.grey,
            ),
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              buildTextTime(),
              buildUnreadMessages(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildUnreadMessages() {
    if (unreadMessagesCount == 0) {
      return Container(height: 25, width: 25);
    }
    return Container(
      alignment: Alignment.center,
      height: 25,
      width: 25,
      decoration: BoxDecoration(
        color: textUnreadGreenColor,
        shape: BoxShape.circle,
      ),
      child: Text(
        unreadMessagesCount.toString(),
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  //! If messageDate contains ":" means its recent, else it means it is read "recent,yesterday,friday,..ago"
  Widget buildTextTime() {
    return Text(
      messageDate,
      style: TextStyle(
        color: messageDate.contains(":") ? textUnreadGreenColor : Colors.grey[500],
      ),
    );
  }
}
