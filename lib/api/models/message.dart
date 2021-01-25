class Message {
  String senderId;
  String recipientId;
  String text;
  String image;
  String createdAt;
  Message({this.senderId, this.recipientId, this.text, this.image, this.createdAt});

  factory Message.fromJson(Map<String, dynamic> responseData) {
    return Message(
        senderId: responseData['senderId'],
        recipientId: responseData['recipientId'],
        text: responseData['text'],
        createdAt: responseData['createdAt'],
        image: responseData['image']);
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['senderId'] = this.senderId;
    data['recipientId'] = this.recipientId;
    data['text'] = this.text;
    data['createdAt'] = this.createdAt;
    data['image'] = this.image;
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
        " createdAt: " +
        (createdAt == null ? "NULL" : createdAt) +
        " token:" +
        (image == null ? "NULL" : image);
  }
}
