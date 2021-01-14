
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:team_superstar/utils.dart';
import 'package:localstorage/localstorage.dart';
import 'package:team_superstar/models/User.dart';
import 'package:team_superstar/global_variables.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthController {
  bool isLoading = false;
  LocalStorage storage_user = new LocalStorage("user");



  logIn(String username, password) async {
Map data = {
  'username': username,
  'password': password
};

var jsonData = null;
var jsonData2 = null;
SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  var response = await http.post(login_api, body: data);
  print(response.statusCode);
  if(response.statusCode == 200){
    jsonData = json.decode(response.body);
    setState(() {
      isLoading = false;
      print("____________________________TOKEN______________________________");
      print(jsonData['key']);
      sharedPreferences.setString("token", jsonData['key']);
    });
    var response2 = await authenticatedGet(user_api + jsonData['key']);
    if (response2.statusCode == 200) {
      jsonData2 = json.decode(response2.body);
        setState(() {
        isLoading = false;
        sharedPreferences.setString("user_id", jsonData2['id'].toString());
        storage_user.setItem("username", username);
        Navigator.of(context).pushReplacementNamed('/HomePage');
      });
    }
  }
  else{
    print(response.body);
    setState(() {
      isLoading = false;
    });
    var error = json.decode(response.body);
    var field = '';
    if(error['password'] == null || error['username']==null) {
      error = error['non_field_errors'];
      field = 'Credentials';
    }
    print(error);
    if (error[0]!=null){
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

  Map signData = {
    "username": username,
    "password": password,
    "email": email
};

var response = await apiPost(register_api, signData);
//Se registrato correttamente salva il token (key) in local storage
print(response.statusCode);
print(response.body);
if(response.statusCode == 201){
    jsonData = json.decode(response.body);
    setState(() {
      isLoading = false;
      print(jsonData['key']);
      sharedPreferences.setString("token", jsonData['key']);
      storage_user.setItem("username", username);
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
              "Effettua il login per accedere alle funzionalità di Gryfon!",
            style: TextStyle(
              letterSpacing: 4,
              fontSize: 12
            ),
            ),
            actions: <Widget>[
              new FlatButton(
                  onPressed: (){
                    Navigator.of(context).pushReplacementNamed('/LogIn');
                  },
                  child: new Text("LogIn") 
                  ),
            new FlatButton(
                  onPressed: (){
                    Navigator.of(context).pushReplacementNamed('/HomePage');
                  },
                  child: new Text("HomePage") 
                  ),
            ]
        ),
  );
   
}
else{
    setState(() {
      isLoading = false;
    });
    var error = json.decode(response.body);
    var field ='';
    print("--------------------------------------------------------------------------------------");
    print(error);
    if(error['username'] == null) {
      error = error['non_field_errors'][0];
      field = 'Credentials';
    }
    if(error['username'] != null){
      error=error['username'][0];
      field='Account non disponibile';
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
            )
          );
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
}