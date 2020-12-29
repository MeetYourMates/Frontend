import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:meet_your_mates/api/models/send_menu_items.dart';
import 'package:meet_your_mates/api/models/user.dart';
import 'package:meet_your_mates/api/services/socket_service.dart';
import 'package:meet_your_mates/api/services/student_service.dart';
import 'package:meet_your_mates/screens/Chat/ChatInput/chatInput.dart';
import 'package:meet_your_mates/screens/Chat/chat_bubble.dart';
import 'package:meet_your_mates/screens/Chat/chat_detail_appbar.dart';
import 'package:provider/provider.dart';

class ChatDetailPage extends StatefulWidget {
  final int selectedIndex;

  const ChatDetailPage({Key key, @required this.selectedIndex}) : super(key: key);
  @override
  _ChatDetailPageState createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  TextStyle inputTextStyle;
  ScrollController _scrollController = ScrollController();
  List<SendMenuItems> menuItems = [
    SendMenuItems(text: "Photos & Videos", icons: Icons.image, color: Colors.amber),
    SendMenuItems(text: "Document", icons: Icons.insert_drive_file, color: Colors.blue),
    SendMenuItems(text: "Audio", icons: Icons.music_note, color: Colors.orange),
    SendMenuItems(text: "Location", icons: Icons.location_on, color: Colors.green),
    SendMenuItems(text: "Contact", icons: Icons.person, color: Colors.purple),
  ];
  @override
  void initState() {
    //WidgetsBinding.instance.addPostFrameCallback(widgetBuilt);
    inputTextStyle = inputTextStyle ?? TextStyle(fontSize: 16.0, color: Colors.black87);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Logger logger = new Logger(level: Level.error);
//
  void showModal() {
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
                borderRadius:
                    BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
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
                      itemCount: menuItems.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Container(
                          //padding: EdgeInsets.only(top: 10, bottom: 10),
                          child: ListTile(
                            leading: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: menuItems[index].color.shade50,
                              ),
                              child: Icon(
                                menuItems[index].icons,
                                color: menuItems[index].color.shade400,
                              ),
                            ),
                            title: Text(menuItems[index].text),
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

  @override
  Widget build(BuildContext context) {
    var msgController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => {_scrollController.jumpTo(_scrollController.position.maxScrollExtent)});
    //var textValue = "";
    SocketProvider socketProvider = Provider.of<SocketProvider>(context, listen: true);
    User chatUser = socketProvider.users.usersList[widget.selectedIndex];

    /// [_studentProvider] StudentProvider Instance of a singleton
    StudentProvider _studentProvider = Provider.of<StudentProvider>(context);

    ///[sendMessage] Function to send message to server and also save the message into local List of Messages(No LocalStorage!)
    Future<void> sendMessage(String value) async {
      print("Message Sent: " + value);
      socketProvider.sendMessage(
          _studentProvider.student.user.id, chatUser.id, value, widget.selectedIndex);
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }

    /**========================================================================
     *                CHAT VIEW FOR A CERTAIN USER!
     *========================================================================**/
    return Scaffold(
      /// [AppBar] which shows the user avatar, current status (online/offline) and name
      appBar: ChatDetailPageAppBar(
        name: chatUser.name,
        avatar: chatUser.picture,
      ),

      /// [Stack] STACK AS WE REQUIRE CHATINPUT AND MESSAGES TO ALWAYS BE SHOWN,
      /// and thus never be hidden
      body: Stack(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              /**============================================
           *               Message List
           *=============================================**/
              //* EXPANDED LIST OF MESSAGES OCCYPUYING THE REMAINING SPACE!
              Expanded(
                child: ListView.builder(
                  itemCount: chatUser.messagesList.length,
                  shrinkWrap: true,
                  controller: _scrollController,
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  physics: ClampingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return ChatBubble(
                        chatMessage: chatUser.messagesList[index],
                        myId: _studentProvider.student.user.id);
                  },
                ),
              ),
              /**============================================
           *               ChatInput Toolbar
           *=============================================**/
              //* FIXED SIZE CHAT INPUT TOOLBAR
              Align(
                alignment: Alignment.bottomLeft,
                child: SafeArea(
                  child: ChatInputToolbar(
                      onExtra: showModal,
                      onSend: (textMessage) => {
                            logger.d(textMessage),
                            sendMessage(textMessage),
                          },
                      textEditingController: msgController,
                      inputTextStyle: inputTextStyle),
                ),
                /* ), */
              ),
            ],
          ),
        ],
      ),
    );
  }
}
