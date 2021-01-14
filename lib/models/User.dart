class User {
  String username;
  String email;
  String password;

  User();

  User.fromJSON(Map<String, dynamic> jsonMap) {
    username = jsonMap["username"].toString();
    email = jsonMap["email"].toString();
    password = jsonMap["password"].toString();
  }

  // String get email => email;
  // String get password => password;

Map toMap() {
    var map = new Map<String, dynamic>();
    map["username"] = username;
    map["email"] = email;
    map["password"] = password;
    return map;
  }
}