import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:meet_your_mates/api/models/message.dart';
import 'package:meet_your_mates/api/models/privateChatHistory.dart';
import 'package:meet_your_mates/api/models/user.dart';
import 'package:meet_your_mates/api/models/users.dart';
import 'package:meet_your_mates/api/util/app_url.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketProvider with ChangeNotifier {
  /// ================================================================================================
  /// *                                  Variables
  ///================================================================================================**/
  IO.Socket socket;
  //StreamSocket streamUsers = StreamSocket();
  //StreamSocket streamMessages = StreamSocket();
  Users mates = new Users(usersList: []);
  User tempMate = new User();
  List<String> usersOnline = <String>[];
  Logger logger = Logger(level: Level.debug);
  String myId;

  //! DON'T DELETE!
  /*StreamController<String> streamUsers = StreamController<String>.broadcast();
  void disposeStreamUsers() {
    streamUsers.close();
  }
  
  StreamController<String> streamMessages =
      StreamController<String>.broadcast();

  void disposeStreamMessage() {
    streamMessages.close();
  }
  */
  /// ================================================================================================
  /// *                         Socket IO Server Connection
  ///================================================================================================**/
  //get getStreamUsers => {streamUsers.stream};
  //get getStreammessages => {streamMessages.stream};
  bool createSocketConnection(String token, String myId) {
    this.myId = myId;
    logger.e("createSocketConnection" + token);
    try {
      // Configure socket transports must be sepecified
      socket = IO.io(AppUrl.baseURL, <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
      });

      // Connect to websocket
      socket.connect();

      // Handle socket events
      /**--------------------------------------------
       *           User On Connect Event
       *---------------------------------------------**/
      socket.on(
          'connect',
          (_) => {
                //We try to authenticate
                socket.emit('authentication', {"token": token})
              });
      /**--------------------------------------------
       *           When Authenticated from Server
       *---------------------------------------------**/
      socket.on(
          'authentication',
          (data) => {
                logger.d(data),
                //Get Chat Historial
                socket.emit('private_chat_history', '{"message":"give my chat history"]'),
              });
      /**--------------------------------------------
       *     ¿User Mates Status isOnline or isOffline?
       *---------------------------------------------**/
      socket.on(
          'mates_status',
          (data) => {
                logger.d(data),
                //handleMatesStatusEvent(data.toString()),
                handleMatesStatusEvent(data),
              });
      /**--------------------------------------------
       *     ¿User Mates Status isOnline or isOffline?
       *---------------------------------------------**/
      socket.on(
          'check_mate_status',
          (data) => {
                logger.d(data),
                //handleMatesStatusEvent(data.toString()),
                handleMatesOnlineResponseEvent(data),
              });
      /**--------------------------------------------
       *     Private Chat Hisotry of User
       *---------------------------------------------**/
      socket.on(
          'private_chat_history',
          (data) => {
                handlePrivateChatHistory(data),
              });
      /**--------------------------------------------
       *     Adds a new mate to list, recieved from server
       *---------------------------------------------**/
      socket.on(
          'new_mate',
          (data) => {
                handleNewMate(data),
              });
      /**--------------------------------------------
       *     on new Private Message from User
       *---------------------------------------------**/
      socket.on(
          'private_chat_message',
          (data) => {
                handlePrivateMessage(data),
              });
      /**--------------------------------------------
       *     Disconnect event Recieved from Server!
       *---------------------------------------------**/
      socket.on('disconnect', (_) => logger.d('disconnect'));
      return true;
    } catch (e) {
      logger.e(e.toString());
      return false;
    }
  }

  void disconnectSocket() {
    if (socket != null) {
      socket.disconnect();
      socket.dispose();
    }
  }

  /// ================================================================================================
  /// *                                  EVENTS FUNCTIONS
  ///================================================================================================**/

  // Send OnlineUsers to Server
  sendOnlineUsers() {
    socket.emit("online_users", "{'message':'I need my mates statuses if connected?'}");
  }

  // Handles the Authentication updates for myself
  handleAuthenticationListen(Map<String, dynamic> data) async {
    logger.d("Authentication Listener: " + data.toString());
    logger.d('Authenticated: ${socket.id}');
  }

  // Handles MatesOnlineResponseEvent for some User X asked earlier to server
  handleMatesOnlineResponseEvent(Map<String, dynamic> data) async {
    logger.d("Mate Online Response: " + data.toString());
    if (tempMate.id != null) {
      if (tempMate.id == data['_id']) {
        tempMate.isOnline = data['status'];
      }
    }
  }

  // Listen to Authentication updates for myself
  handleNewMate(Map<String, dynamic> data) async {
    Message message = Message.fromJson(data["message"]);
    User usr = User.fromJson(data["user"]);
    usr.messagesList = [message];
    usr.isOnline = true;
    mates.usersList.add(usr);
    notifyListeners();
    logger.d("Adding Mate to mate list, Listener: " + data.toString());
  }

  //* Listen to OnlineUsers updates of connected usersfrom server
  handleMatesStatusEvent(List<dynamic> data) async {
    //streamUsers.addResponse(data);
    logger.d("mates_statuses: " + data.toString());
    //streamUsers.sink.add(data);
    usersOnline = data.cast<String>();
    //From this usersOnline and chatHistorial Users List with messages
    //Wherever we find a chatHistorialUser with userOnline, set that user isOnline=true,else false!
    if (mates.usersList != null) {
      for (int i = 0; i < mates.usersList.length; i++) {
        mates.usersList[i].isOnline = false;
      }
    }
    for (int k = 0; k < usersOnline.length; k++) {
      //Search for user in usersList and set Online
      if (mates.usersList != null) {
        for (int i = 0; i < mates.usersList.length; i++) {
          if (mates.usersList[i].id == usersOnline[k]) {
            //Found User in List
            mates.usersList[i].isOnline = true;
            break;
          }
        }
      } else {
        break;
      }
    }
    notifyListeners();
  }

  //* HANDLES PRIVATE CHAT HISTORY!
  handlePrivateChatHistory(List<dynamic> data) async {
    //streamUsers.addResponse(data);
    logger.d("private_chat_history: " + data.toString());
    List<PrivateChatHistory> privateChatHistoryList = [];
    data.forEach((element) {
      privateChatHistoryList.add(PrivateChatHistory.fromJson(element));
    });
    mates.usersList = [];
    //From Chat history convert to usersList with messages
    for (int i = 0; i < privateChatHistoryList.length; i++) {
      int indx = privateChatHistoryList[i].users[0].id == myId ? 1 : 0;
      mates.usersList.add(privateChatHistoryList[i].users[indx]);
      mates.usersList.last.isOnline = false;
      mates.usersList.last.messagesList = privateChatHistoryList[i].messages;
    }
    //Now check if any of the privateChatHistory Users are online
    for (int k = 0; k < usersOnline.length; k++) {
      //Search for user in usersList and set Online
      if (mates.usersList != null) {
        for (int i = 0; i < mates.usersList.length; i++) {
          if (mates.usersList[i].id == usersOnline[k]) {
            //Found User in List
            mates.usersList[i].isOnline = true;
            break;
          }
        }
      } else {
        break;
      }
    }

    logger.d("Decoded Json: " + mates.usersList.toString());
    notifyListeners();
  }

  // Send a Message to the server
  Future<void> sendPrivateMessage(String senderId, String recipientId, String message, int recipientIndex, String image) async {
    Message tmp = new Message(senderId: senderId, recipientId: recipientId, text: message, createdAt: DateTime.now().toIso8601String(), picture: image);
    emitChatMessage(tmp);
    mates.usersList[recipientIndex].messagesList.add(tmp);
    notifyListeners();
  }

  // Send a Message to the server for a temperory mate or for recently opened chat, without previous history!
  Future<void> sendPrivateMessageTemp(String senderId, User usr, String messageText) async {
    Message tmp = new Message(senderId: senderId, recipientId: usr.id, text: messageText, createdAt: DateTime.now().toIso8601String());
    emitChatMessage(tmp);
    mates.usersList.last.messagesList.add(tmp);
    //As we have talked with the user --> We add him to the mates list and also the messagesList
    int k = -1;
    if (mates.usersList != null) {
      for (int i = 0; i < mates.usersList.length; i++) {
        if (mates.usersList[i].id == usr.id) {
          //Found User in List
          k = i;
          break;
        }
      }
    }
    //If the temp mate exist in mates list, it simply means that the user has kept talking with the temp mate
    //In this case we just add the message to the temp mate in mates list
    if (k != -1) {
      mates.usersList[k].messagesList.add(tmp);
    } else {
      //Else add the mate to the mate list and also add the message to the mate in mate list
      usr.messagesList.add(tmp);
      mates.usersList.add(usr);
    }
    notifyListeners();
  }

  //Emits chate message to the server
  Future<void> emitChatMessage(Message tmp) async {
    socket.emit("private_chat_message", tmp.toJson());
  }

  //Emits chate message to the server
  Future<void> askTempMateStatus(String idTmpUser) async {
    Map<String, String> tmp = {'_id': idTmpUser};
    socket.emit("check_mate_status", tmp);
  }

  // Listen to all message events from connected mates
  void handlePrivateMessage(Map<String, dynamic> data) {
    //streamMessages.addResponse(data);
    logger.d("Messages: " + data.toString());
    Message messageData = new Message();
    messageData = Message.fromJson(data);
    //streamMessages.sink.add(data);
    //If tempMate exists, also add as user on different screen
    if (tempMate.id != null && data['senderId'] != null) {
      if (tempMate.id.isNotEmpty && tempMate.id == data['senderId']) {
        tempMate.messagesList.add(messageData);
        notifyListeners();
      }
    }
    //If Message New Added to User, Notify Listeners
    mates.addMessage(messageData).then((wasAdded) => {if (wasAdded) notifyListeners()});
  }
}
