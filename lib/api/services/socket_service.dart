import 'dart:convert';

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
  Users users = new Users(usersList: []);
  Logger logger = Logger(level: Level.error);
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
      socket.on(
          'connect',
          (_) => {
                socket.emit('authentication', {"token": token})
              });
      socket.on(
          'authenticated',
          (data) => {
                logger.d(data),
                //Get Chat Historial
                socket.emit('private_chat_history', '{"message":"give my chat history"]'),
              });
      socket.on(
          'online_users',
          (data) => {
                logger.d(data),
                //handleOnlineUsers(data.toString()),
                handleOnlineUsers(data),
              });
      socket.on(
          'private_chat_history',
          (data) => {
                handlePrivateChatHistory(data),
              });
      socket.on(
          'chat_message',
          (data) => {
                handleMessage(data),
              });
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
// Authenticate myself on to the Server
  sendAuthenticate(String token) {
    logger.d('connected: ${socket.id}');
    socket.emit('authentication', {"token": token});
  }

  // Send OnlineUsers to Server
  sendOnlineUsers(Map<String, dynamic> data) {
    socket.emit("online_users", json.encode(data));
  }

  // Listen to Authentication updates for myself
  handleAuthenticationListen(Map<String, dynamic> data) async {
    logger.d("Authentication Listener: " + data.toString());
    logger.d('Authenticated: ${socket.id}');
  }

  //! Listen to OnlineUsers updates of connected usersfrom server
  handleOnlineUsers(List<dynamic> data) async {
    //streamUsers.addResponse(data);
    logger.d("online_users: " + data.toString());
    //streamUsers.sink.add(data);
    List<User> usersListTemp = Users.fromDynamicList(data).usersList;
    //From this usersList and chatHistorial Users List with messages
    //Merge them together and wherever a user is in online_usersList set his status isOnline = true
    usersListTemp.forEach((element) {
      //Check if user in our usersList
      //If it does set the status online = true else leave it false

      int found = users.usersList.isNotEmpty ? users.usersList.indexOf(element) : -1;
      if (found == -1) {
        //If it doesn't exist, add the user and put status online true
        element.isOnline = true;
        users.usersList.add(element);
      } else {
        users.usersList[found].isOnline = true;
      }
    });
    logger.d("Decoded Json: " + users.usersList.toString());
    notifyListeners();
  }

  //! HANDLES PRIVATE CHAT HISTORY!
  handlePrivateChatHistory(List<dynamic> data) async {
    //streamUsers.addResponse(data);
    logger.d("private_chat_history: " + data.toString());
    List<PrivateChatHistory> privateChatHistoryList = [];
    data.forEach((element) {
      privateChatHistoryList.add(PrivateChatHistory.fromJson(element));
    });
    //From Chat history where each element is users + messages
    //we merge it into users where each user contains messages and a state isOnline
    privateChatHistoryList.forEach((privChat) {
      //? Need to check if the user is online and not myself!
      int indx = privChat.users[0].id == myId ? 1 : 0;
      int found = users.usersList.indexOf(privChat.users[indx]);
      if (found == -1) {
        //Doesnt Contain
        users.usersList.add(privChat.users[indx]);
        users.usersList.last.messagesList = privChat.messages;
      } else {
        //User Already Online
        users.usersList[found].messagesList = privChat.messages;
      }
    });

    logger.d("Decoded Json: " + users.usersList.toString());
    notifyListeners();
  }

  // Send update of user's typing status
  sendTyping(bool typing) {
    socket.emit("typing", {
      "id": socket.id,
      "typing": typing,
    });
  }

  // Listen to update of typing status from connected users
  void handleTyping(Map<String, dynamic> data) {
    logger.d(data);
  }

  // Send a Message to the server
  Future<void> sendMessage(
      String senderId, String recipientId, String message, int recipientIndex) async {
    Message tmp = new Message(
        senderId: senderId,
        recipientId: recipientId,
        text: message,
        createdAt: DateTime.now().toIso8601String());
    emitChatMessage(tmp);
    users.usersList[recipientIndex].messagesList.add(tmp);
    notifyListeners();
  }

  //Asyncronhous Emit!
  Future<void> emitChatMessage(Message tmp) async {
    socket.emit("chat_message", tmp.toJson());
  }

  // Listen to all message events from connected users
  void handleMessage(Map<String, dynamic> data) {
    //streamMessages.addResponse(data);
    logger.d("Messages: " + data.toString());
    //streamMessages.sink.add(data);
    //If Message New Added to User, Notify Listeners
    users.addMessage(data).then((wasAdded) => {if (wasAdded) notifyListeners()});
  }
}
