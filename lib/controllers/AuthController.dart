import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:team_superstar/utils.dart';
import 'package:localstorage/localstorage.dart';
import 'package:team_superstar/models/User.dart';
import 'package:team_superstar/global_variables.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends ControllerMVC {
  bool isLoading = false;
  LocalStorage storage_user = new LocalStorage("user");
  List teamMembers = [];
  List availableUsers = [];


  logIn(String username, password) async {
    Map data = {'username': username, 'password': password};

    var jsonData = null;
    var jsonData2 = null;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var response = await http.post(login_api, body: data);
    print(response.statusCode);
    if (response.statusCode == 200) {
      jsonData = json.decode(response.body);
      setState(() {
        isLoading = false;
        print(
            "____________________________TOKEN______________________________");
        print(jsonData['token']);
        sharedPreferences.setString("token", jsonData['token']);
      });
      var response2 =
          await authenticatedGet(user_api + jsonData['id'].toString() + '/');
      if (response2.statusCode == 200) {
        jsonData2 = json.decode(response2.body);
        OneSignal.shared.setExternalUserId(jsonData2['id'].toString());
        setState(() {
          isLoading = false;
          sharedPreferences.setString("user_id", jsonData2['id'].toString());
          storage_user.setItem("username", username);
          Navigator.of(context).pushReplacementNamed('/ChooseTeamPage');
        });
      }
    } else {
      print(response.body);
      setState(() {
        isLoading = false;
      });
      var error = json.decode(response.body);
      var field = '';
      if (error['password'] == null || error['username'] == null) {
        error = error['non_field_errors'];
        field = 'Credentials';
      }
      print(error);
      if (error[0] != null) {
        showDialog(
            context: context,
            builder: (_) => new AlertDialog(
                  title: new Text(field),
                  content: new Text(error[0]),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Ok'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ));
      }
    }
  }

  signIn(String username, String email, String password) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var jsonData = null;
    // var jsonDataAuth = null;

    Map signData = {"username": username, "password": password, "email": email};

    var response = await apiPost(register_api, signData);
//Se registrato correttamente salva il token (key) in local storage
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      jsonData = json.decode(response.body);
      setState(() {
        isLoading = false;
      });
      showDialog(
        context: context,
        builder: (_) => new AlertDialog(
            title: new Text(
              "REGISTRATO CON SUCCESSO",
              style: TextStyle(
                letterSpacing: 2,
              ),
            ),
            content: new Text(
              "Effettua il login!",
              style: TextStyle(letterSpacing: 4, fontSize: 12),
            ),
            actions: <Widget>[
              new FlatButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed('/LogIn');
                  },
                  child: new Text("LogIn")),
            ]),
      );
    } else {
      setState(() {
        isLoading = false;
      });
      var error = json.decode(response.body);
      var field = '';
      print(
          "--------------------------------------------------------------------------------------");
      print(error);
      if (error['username'] == null) {
        error = error['non_field_errors'][0];
        field = 'Credentials';
      }
      if (error['username'] != null) {
        error = error['username'][0];
        field = 'Account non disponibile';
      }

      showDialog(
          context: context,
          builder: (_) => new AlertDialog(
                title: new Text(field),
                content: new Text(error),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Ok'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              ));
    }
// var responseAuth = authenticatedGet(USERINFO_API + jsonData['key']);
// //verifico info dello user e mi mantengo loggato
// if(responseAuth.statusCode == 200){
//   jsonDataAuth = jsonDecode(responseAuth.body);
//    setState(() {
//         isLoading = false;
//         sharedPreferences.setString("user_id", jsonDataAuth['id'].toString());
//         Navigator.of(context).pushReplacementNamed('/HomePage');
//       });
// }
  }
  getUsers() async {
    var response = await authenticatedGet('${user_api}');
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      print(jsonData);
      List<User> users_list = [];
        for (var team in jsonData) {
          users_list.add(User.fromJSON(team));
        }
        setState(() {
          availableUsers = users_list;
        });
    } else {
      var error = json.decode(response.body);
      showDialog(
          context: context,
          builder: (_) => new AlertDialog(
                title: new Text("Users Error"),
                content: new Text(error),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Ok'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              ));
    }
  }

  addInTeam(member) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String teamId = sharedPreferences.getString("team_chose");
    List<String> members = [];
    members.add(member);
    Map<String, dynamic> data = {
      "members": members
    };
    var response = await apiPutAuthenticated('${team_api}${teamId}/add_member/', jsonEncode(data), contentType: 'application/json');
    print(response.statusCode);
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      print(jsonData);
      showDialog(
          context: context,
          builder: (_) => new AlertDialog(
                title: new Text("User added"),
                content: new Text("User added successfully"),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Ok'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              ));
    } else {
      var error = json.decode(response.body);
      showDialog(
          context: context,
          builder: (_) => new AlertDialog(
                title: new Text("Team Error"),
                content: new Text(error),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Ok'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              ));
    }
  }
}
