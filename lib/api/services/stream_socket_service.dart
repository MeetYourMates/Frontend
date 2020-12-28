import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:meet_your_mates/api/models/message.dart';
import 'package:meet_your_mates/api/models/users.dart';
import 'package:meet_your_mates/api/util/app_url.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class StreamSocketProvider with ChangeNotifier {
  /// ================================================================================================
  /// *                                  Variables
  ///================================================================================================**/
  IO.Socket socket;
  //StreamSocket streamUsers = StreamSocket();
  //StreamSocket streamMessages = StreamSocket();
  Users users = new Users();
  Logger logger = Logger(level: Level.error);
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
  bool createSocketConnection(String token) {
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
      socket.on('authenticated', (data) => {logger.d(data)});
      socket.on(
          'online_users',
          (data) => {
                logger.d(data),
                //handleOnlineusersen(data.toString()),
                handleOnlineusersen(data),
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

  // Listen to OnlineUsers updates of connected usersfrom server
  handleOnlineusersen(List<dynamic> data) async {
    //streamUsers.addResponse(data);
    logger.d("online_users: " + data.toString());
    //streamUsers.sink.add(data);
    users.usersList = Users.fromDynamicList(data).usersList;
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
        timestamp: DateTime.now().millisecondsSinceEpoch);
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
