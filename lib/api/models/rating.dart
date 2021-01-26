import 'package:meet_your_mates/api/models/user.dart';
class Rating {
  int stars;
  User ratedBy = new User();
  DateTime date;
  Rating({this.stars, this.ratedBy, this.date});
  factory Rating.fromJson(Map<String, dynamic> responseData) {
    return Rating(
      stars: responseData['stars'],
      ratedBy: User.fromJson(responseData['ratedBy']),
      date: responseData['date'],
    );
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['stars'] = this.stars;
    data['ratedBy'] = this.ratedBy;
    data['date'] = this.date;
    return data;
  }
}
