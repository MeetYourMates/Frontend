class Trophy {
  String title;
  int difficulty;
  String professorId;
  String date;
  String logo;
  Trophy({this.title, this.difficulty, this.professorId, this.date, this.logo});
  factory Trophy.fromJson(Map<String, dynamic> responseData) {
    return Trophy(
        title: responseData['title'],
        difficulty: responseData['difficulty'],
        professorId: responseData["professor"],
        date: responseData['date'],
        logo: responseData['logo']);
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['difficulty'] = this.difficulty;
    data['professor'] = this.professorId;
    data['date'] = this.date;
    data['logo'] = this.logo;
    return data;
  }
}
