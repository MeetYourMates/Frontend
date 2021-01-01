import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meet_your_mates/constants.dart';

class ChatDetailPageAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String avatar;
  final String name;
  final bool isOnline;
  const ChatDetailPageAppBar({
    Key key,
    this.avatar,
    @required this.name,
    this.isOnline = false,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(kAppBarHeight), // here the desired height
      child: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.grey[300],
        flexibleSpace: SafeArea(
          child: Container(
            padding: EdgeInsets.only(right: 4),
            child: Row(
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                ),
                avatar != null
                    ? CircleAvatar(radius: 40.0, backgroundImage: NetworkImage(avatar))
                    : Icon(
                        Icons.account_circle,
                        size: 40.0,
                      ),
                SizedBox(
                  width: 1,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        name,
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                        isOnline ? "Online" : "Offline",
                        style: TextStyle(
                            color: isOnline ? Colors.green : Colors.red[900], fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.more_vert,
                  color: Colors.grey.shade800,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kAppBarHeight);
}
