class Trophy {
  String title;
  double difficulty;
  String professor;
  String dateTime;
  String logo;
  Trophy(
      {this.title, this.difficulty, this.professor, this.dateTime, this.logo});
  factory Trophy.fromJson(Map<String, dynamic> responseData) {
    return Trophy(
        title: responseData['title'],
        difficulty: responseData['difficulty'],
        professor: responseData['professor'],
        dateTime: responseData['dateTime'],
        logo: responseData['logo']);
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['difficulty'] = this.difficulty;
    data['professor'] = this.professor;
    data['dateTime'] = this.dateTime;
    data['logo'] = this.logo;
    return data;
  }
}
