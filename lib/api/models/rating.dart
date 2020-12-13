class Rating {
  int stars;
  String ratedBy;
  String date;
  Rating({this.stars, this.ratedBy, this.date});
  factory Rating.fromJson(Map<String, dynamic> responseData) {
    return Rating(
      stars: responseData['stars'],
      ratedBy: responseData['ratedBy'],
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
