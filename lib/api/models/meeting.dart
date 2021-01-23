class Meeting {
  String id;
  String name;
  String description;
  int date;
  List<double> location;
  String teamId;
  Meeting({this.id, this.name, this.description, this.date, this.location, this.teamId});
  factory Meeting.fromJson(Map<String, dynamic> responseData) {
    return Meeting(
      id: responseData['_id'],
      name: responseData['name'] ?? "No Name for meeting...",
      description: responseData['description'] ?? "No description for meeting...",
      date: responseData['date'] ?? 1611413893453,
      //location: List<num>.from(responseData["location"].map((x) => Helper.tryCast<num>(x, fallback: 0))));
      location: responseData["location"] != null ? new List<double>.from(responseData["location"]) : [],
    );
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['date'] = this.date;
    if (this.teamId != null) {
      data['teamId'] = this.teamId;
    }
    if (this.location != null) {
      data['location'] = this.location;
    }
    return data;
  }
}
