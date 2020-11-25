class User {
  String id;
  String email;
  String password;

  User({this.id, this.email, this.password});
  factory User.fromJson(Map<String, dynamic> responseData) {
    return User(
        id: responseData['_id'],
        email: responseData['email'],
        password: responseData['password']);
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.id;
    data['email'] = this.email;
    data['password'] = this.password;
    return data;
  }
}
