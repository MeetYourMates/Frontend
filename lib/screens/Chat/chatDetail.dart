import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meet_your_mates/api/models/chat_user.dart';
import 'package:meet_your_mates/api/models/send_menu_items.dart';
import 'package:meet_your_mates/api/services/stream_socket_service.dart';
import 'package:meet_your_mates/api/services/student_service.dart';
import 'package:meet_your_mates/constants.dart';
import 'package:meet_your_mates/screens/Chat/chat_bubble.dart';
import 'package:meet_your_mates/screens/Chat/chat_detail_appbar.dart';
import 'package:provider/provider.dart';

class ChatDetailPage extends StatefulWidget {
  final int selectedIndex;

  const ChatDetailPage({Key key, @required this.selectedIndex})
      : super(key: key);
  @override
  _ChatDetailPageState createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  ScrollController _scrollController = ScrollController();
  List<SendMenuItems> menuItems = [
    SendMenuItems(
        text: "Photos & Videos", icons: Icons.image, color: Colors.amber),
    SendMenuItems(
        text: "Document", icons: Icons.insert_drive_file, color: Colors.blue),
    SendMenuItems(text: "Audio", icons: Icons.music_note, color: Colors.orange),
    SendMenuItems(
        text: "Location", icons: Icons.location_on, color: Colors.green),
    SendMenuItems(text: "Contact", icons: Icons.person, color: Colors.purple),
  ];
//
  void showModal() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          double availableHeight = MediaQuery.of(context).size.height / 2;
          return Container(
            height: availableHeight,
            color: Color(0xff737373),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20)),
              ),
              child: Column(
                children: <Widget>[
                  Flexible(
                    flex: 4,
                    child: SizedBox(
                      height: 4,
                    ),
                  ),
                  Flexible(
                    flex: 4,
                    child: Center(
                      child: Container(
                        height: 4,
                        width: 50,
                        color: Colors.grey.shade200,
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 4,
                    child: SizedBox(
                      height: 10,
                    ),
                  ),
                  Flexible(
                    flex: 82,
                    child: ListView.builder(
                      itemCount: menuItems.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Container(
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          child: ListTile(
                            leading: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: menuItems[index].color.shade50,
                              ),
                              height: 50,
                              width: 50,
                              child: Icon(
                                menuItems[index].icons,
                                size: 20,
                                color: menuItems[index].color.shade400,
                              ),
                            ),
                            title: Text(menuItems[index].text),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) =>
        {_scrollController.jumpTo(_scrollController.position.maxScrollExtent)});
    var textValue = "";
    StreamSocketProvider socketProvider =
        Provider.of<StreamSocketProvider>(context, listen: true);
    ChatUser chatUser = socketProvider.users.usersList[widget.selectedIndex];
    // ignore: unused_local_variable
    StudentProvider _studentProvider = Provider.of<StudentProvider>(context);
    Future<void> sendMessage(String value) async {
      print("Message Sent: " + value);
      socketProvider.sendMessage(_studentProvider.student.user.id, chatUser.id,
          value, widget.selectedIndex);
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }

    ;
    return Scaffold(
      appBar: ChatDetailPageAppBar(
        name: chatUser.email,
      ),
      body: Stack(
        children: <Widget>[
          ListView.builder(
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
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: EdgeInsets.only(left: 16, bottom: 10),
              height: 80,
              width: double.infinity,
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      showModal();
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Colors.blueGrey,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 21,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        textValue = value != null ? value : textValue;
                      },
                      onSubmitted: (String value) {
                        sendMessage(value);
                      },
                      decoration: InputDecoration(
                          hintText: "Type message...",
                          hintStyle: TextStyle(color: Colors.grey.shade500),
                          border: InputBorder.none),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              padding: EdgeInsets.only(right: 30, bottom: 15),
              child: FloatingActionButton(
                onPressed: () {
                  if (textValue.isNotEmpty &&
                      textValue != null &&
                      textValue != "") {
                    sendMessage(textValue);
                  }
                },
                child: Icon(
                  Icons.send,
                  color: Colors.white,
                ),
                backgroundColor: kPrimaryColor,
                elevation: 0,
              ),
            ),
          )
        ],
      ),
    );
  }
}
