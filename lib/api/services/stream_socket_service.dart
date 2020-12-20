import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:meet_your_mates/api/util/app_url.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class StreamSocketProvider with ChangeNotifier {
  /// ================================================================================================
  /// *                                  Variables
  ///================================================================================================**/
  IO.Socket socket;
  //StreamSocket streamUsers = StreamSocket();
  //StreamSocket streamMessages = StreamSocket();

  StreamController<String> streamUsers = StreamController<String>.broadcast();
  StreamController<String> streamMessages =
      StreamController<String>.broadcast();
  void disposeStreamUsers() {
    streamUsers.close();
  }

  void disposeStreamMessage() {
    streamMessages.close();
  }

  /// ================================================================================================
  /// *                         Socket IO Server Connection
  ///================================================================================================**/
  get getStreamUsers => {streamUsers.stream};
  get getStreammessages => {streamMessages.stream};
  void createSocketConnection(String token) {
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
      socket.on('authenticated', (data) => {print(data)});
      socket.on(
          'online_users',
          (data) => {
                print(data),
                handleOnlineUsersListen(data.toString()),
              });
      socket.on(
          'chat_message',
          (data) => {
                print(data),
                handleMessage(data.toString()),
              });
      socket.on('disconnect', (_) => print('disconnect'));
    } catch (e) {
      print(e.toString());
    }
  }

  /// ================================================================================================
  /// *                                  EVENTS FUNCTIONS
  ///================================================================================================**/
// Authenticate myself on to the Server
  sendAuthenticate(String token) {
    print('connected: ${socket.id}');
    socket.emit('authentication', {"token": token});
  }

  // Send OnlineUsers to Server
  sendOnlineUsers(Map<String, dynamic> data) {
    socket.emit("online_users", json.encode(data));
  }

  // Listen to Authentication updates for myself
  handleAuthenticationListen(Map<String, dynamic> data) async {
    print('---------------------------------------');
    print("Authentication Listener: " + data.toString());
    print('Authenticated: ${socket.id}');
    print('---------------------------------------');
  }

  // Listen to OnlineUsers updates of connected usersfrom server
  handleOnlineUsersListen(String data) async {
    //streamUsers.addResponse(data);
    print("online_users: " + data);
    streamUsers.sink.add(data);
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
    print(data);
  }

  // Send a Message to the server
  sendMessage(String senderId, String recipientId, String message) {
    socket.emit(
      "chat_message",
      {
        "senderId": senderId,
        "recipientId": recipientId,
        "text": message, // Message to be sent
        "timestamp": DateTime.now().millisecondsSinceEpoch,
      },
    );
  }

  // Listen to all message events from connected users
  void handleMessage(String data) {
    //streamMessages.addResponse(data);
    print("Messages: " + data);
    streamMessages.sink.add(data);
  }
}
