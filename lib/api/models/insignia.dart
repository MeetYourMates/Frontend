class Insignia {
  String hashtag;
  int requirement;
  String dateTime;
  String logo;
  Insignia({this.hashtag, this.requirement, this.dateTime, this.logo});
  factory Insignia.fromJson(Map<String, dynamic> responseData) {
    return Insignia(
        hashtag: responseData['hashtag'],
        requirement: responseData['requirement'],
        dateTime: responseData['dateTime'],
        logo: responseData['logo']);
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['hashtag'] = this.hashtag;
    data['requirement'] = this.requirement;
    data['dateTime'] = this.dateTime;
    data['logo'] = this.logo;
    return data;
  }
}