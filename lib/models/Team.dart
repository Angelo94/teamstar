class Team {
  String id;
  String name;
  String avatar;
  String target_name;
  String target_max;

  Team();

  Team.fromJSON(Map<String, dynamic> jsonMap) {
    id = jsonMap["id"].toString();
    name = jsonMap["name"].toString();
    avatar = "assets/img/neptune.png";
    target_name = jsonMap["target_name"].toString();
    target_max = jsonMap["target_max"].toString();
  }

  // String get email => email;
  // String get password => password;

Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["name"] = name;
    map["avatar"] = "assets/img/neptune.png";
    map["target_name"] = target_name;
    map["target_max"] = target_max;
    return map;
  }
}