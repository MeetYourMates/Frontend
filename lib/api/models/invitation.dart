class Invitation {
  String sender;
  String senderId;
  String group;
  String invId;

  Invitation({this.invId, this.sender, this.group, this.senderId});

  factory Invitation.fromJson(Map<String, dynamic> responseData) {
    return Invitation(invId: responseData["_id"],
    sender: responseData["sender"]["user"]["name"],
    group: responseData["team"]["name"],
    senderId: responseData["sender"]["user"]["_id"]);
  }
}