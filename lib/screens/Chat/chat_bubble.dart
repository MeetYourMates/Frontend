import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meet_your_mates/api/models/message.dart';

class ChatBubble extends StatefulWidget {
  final Message chatMessage;
  final String myId;
  ChatBubble({@required this.chatMessage, @required this.myId});
  @override
  _ChatBubbleState createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
      child: Align(
        alignment: (widget.myId == widget.chatMessage.senderId
            ? Alignment.topRight
            : Alignment.topLeft),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: (widget.myId == widget.chatMessage.senderId
                ? Colors.grey.shade200
                : Colors.white),
          ),
          padding: EdgeInsets.all(16),
          child: Text(widget.chatMessage.text),
        ),
      ),
    );
  }
}
