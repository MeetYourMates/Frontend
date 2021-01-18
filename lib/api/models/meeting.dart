class Meeting {
  String id;
  String name;
  String description;
  String date;
  List<num> location;
  Meeting({this.id, this.name, this.description, this.date, this.location});
  factory Meeting.fromJson(Map<String, dynamic> responseData) {
    return Meeting(
        id: responseData['_id'],
        name: responseData['name'],
        description: responseData['description'],
        date: responseData['date'],
        //location: List<num>.from(responseData["location"].map((x) => Helper.tryCast<num>(x, fallback: 0))));
        location: new List<num>.from(responseData["location"]));
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['date'] = this.date;
    data['location'] = this.location;
    return data;
  }
}
