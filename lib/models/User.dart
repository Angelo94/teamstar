class User {
  String id;
  String username;
  String first_name;
  String last_name;
  String email;
  String password;

  User();

  User.fromJSON(Map<String, dynamic> jsonMap) {
    id = jsonMap["id"].toString();
    username = jsonMap["first_name"].toString();
    username = jsonMap["last_name"].toString();
    username = jsonMap["username"].toString();
    email = jsonMap["email"].toString();
    password = jsonMap["password"].toString();
  }

  // String get email => email;
  // String get password => password;

Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["first_name"] = first_name;
    map["last_name"] = last_name;
    map["username"] = username;
    map["email"] = email;
    map["password"] = password;
    return map;
  }
}