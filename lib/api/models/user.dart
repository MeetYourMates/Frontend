class User {
  String id;
  String email;
  String password;
  String token;
  User({this.id, this.email, this.password, this.token});
  factory User.fromJson(Map<String, dynamic> responseData) {
    return User(
        id: responseData['_id'],
        email: responseData['email'],
        password: responseData['password'],
        token: responseData['token']);
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.id;
    data['email'] = this.email;
    data['password'] = this.password;
    data['token'] = this.token;
    return data;
  }
}
