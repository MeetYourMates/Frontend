class Message {
  String senderId;
  String recipientId;
  String text;
  String picture;
  int timestamp;
  Message(
      {this.senderId,
      this.recipientId,
      this.text,
      this.picture,
      this.timestamp});

  factory Message.fromJson(Map<String, dynamic> responseData) {
    return Message(
        senderId: responseData['senderId'],
        recipientId: responseData['recipientId'],
        text: responseData['text'],
        timestamp: responseData['timestamp'],
        picture: responseData['picture']);
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['senderId'] = this.senderId;
    data['recipientId'] = this.recipientId;
    data['text'] = this.text;
    data['timestamp'] = this.timestamp;
    data['picture'] = this.picture;
    return data;
  }

  @override
  String toString() {
    return "id: " +
        (senderId == null ? "NULL" : senderId) +
        "email:" +
        (recipientId == null ? "NULL" : recipientId) +
        " password: " +
        (text == null ? "NULL" : text) +
        " timestamp: " +
        (timestamp == null ? "NULL" : timestamp) +
        " token:" +
        (picture == null ? "NULL" : picture);
  }
}
