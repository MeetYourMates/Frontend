import 'package:meet_your_mates/api/models/message.dart';
import 'package:meet_your_mates/api/models/user.dart';

class Users {
  //List<User> usersList =new  List<User>[];
  List<User> usersList = [];
  String myId = "";
  Users({this.usersList});
  Future<bool> addMessage(Message messageData) async {
    //messageServer HashedMap to Object Message

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

  factory Users.fromDynamicList(List<dynamic> dynamicList) => new Users(usersList: dynamicList.map((i) => User.fromJson(i)).toList());
}
