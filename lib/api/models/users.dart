import 'package:meet_your_mates/api/models/chat_user.dart';
import 'package:meet_your_mates/api/models/message.dart';

class Users {
  List<ChatUser> usersList = <ChatUser>[];
  String myId = "";
  Users({this.usersList});
  Future<bool> addMessage(Map<String, dynamic> responseData) async {
    //messageServer HashedMap to Object Message
    Message messageData = new Message();
    messageData = Message.fromJson(responseData);
    //Message from Server to UI Message
    for (int i = 0; i < usersList.length; i++) {
      if (usersList[i].id == messageData.senderId) {
        //Add MESSAGE TO THIS USER
        usersList[i].messagesList.add(messageData);
        return true;
      }
    }
    return false;
  }

  factory Users.fromDynamicList(List<dynamic> dynamicList) =>
      Users(usersList: dynamicList.map((i) => ChatUser.fromJson(i)).toList());
}
