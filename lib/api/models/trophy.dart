import 'package:meet_your_mates/api/models/professor.dart';

class Trophy {
  String title;
  int difficulty;
  String professor;
  String date;
  String logo;
  Trophy(
      {this.title, this.difficulty, this.professor, this.date, this.logo});
  factory Trophy.fromJson(Map<String, dynamic> responseData) {
    return Trophy(
        title: responseData['title'],
        difficulty: responseData['difficulty'],
        professor: responseData["professor"],
        date: responseData['date'],
        logo: responseData['logo']);
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['difficulty'] = this.difficulty;
    data['professor'] = this.professor;
    data['date'] = this.date;
    data['logo'] = this.logo;
    return data;
  }
}
