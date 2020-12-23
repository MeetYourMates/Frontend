class User {
  String id;
  String email;
  String password;
  String picture;
  String name;
  String token;
  User(
      {this.id,
      this.email,
      this.password,
      this.token,
      this.picture,
      this.name});
  factory User.fromJson(Map<String, dynamic> responseData) {
    return User(
        id: responseData['_id'],
        email: responseData['email'],
        picture: responseData['picture'],
        name: responseData['name'],
        password: responseData['password'],
        token: responseData['token']);
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.id;
    data['email'] = this.email;
    data['picture'] = this.picture;
    data['name'] = this.name;
    data['password'] = this.password;
    data['token'] = this.token;
    return data;
  }

  @override
  String toString() {
    return "id: " +
        (id == null ? "NULL" : id) +
        "email:" +
        (email == null ? "NULL" : email) +
        "picture:" +
        (picture == null ? "NULL" : picture) +
        "name:" +
        (name == null ? "NULL" : name) +
        " password: " +
        (password == null ? "NULL" : password) +
        " token:" +
        (token == null ? "NULL" : token);
  }
}
