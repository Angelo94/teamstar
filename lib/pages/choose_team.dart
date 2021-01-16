import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChooseTeam extends StatefulWidget {
  @override
  _ChooseTeamState createState() => new _ChooseTeamState();
}
class _ChooseTeamState extends State<ChooseTeam> {
  int _pageIndex = 0;
  String username;
  LocalStorage storage_user = new LocalStorage("user");
  LocalStorage storage = new LocalStorage("device_info");
  PageController _pageController;
  SharedPreferences sharedPreferences;
  bool isLogged = false;

  String getUsername(){
    if (storage_user.getItem("username") != null){
      setState(() {
      username = storage_user.getItem("username");
      });
    } else username = "user";
  }

  checkToken() async {
    sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences.getString("token");
    print('TOKEN');
    print(token);
    bool check = false;
    token != null ? check = true : check = false;
    setState(() {
      isLogged=check; 
    });
    if(isLogged == true){
      }
      else Navigator.of(context).pushReplacementNamed('/LogIn');
  }
  _showMaterialDialog() {
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              title: new Text("Seleziona un Team"),
              content: Container(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text('Team 1'),
                      ],
                    ),
                     Row(
                      children: [
                        Text('Team 1'),
                      ],
                    ),
                     Row(
                      children: [
                        Text('Team 1'),
                      ],
                    ),
                     Row(
                      children: [
                        Text('Team 1'),
                      ],
                    )
                  ]
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('Close me!'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            ));
  }
  
  
  _showCupertinoDialog() {
    showDialog(
        context: context,
        builder: (_) => new CupertinoAlertDialog(
              title: new Text("Cupertino Dialog"),
              content: new Text("Hey! I'm Coflutter!"),
              actions: <Widget>[
                FlatButton(
                  child: Text('Close me!'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            ));
  }
  @override
  void initState(){
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.purple,
          title: Text("Team SuperStar"),
          actions: <Widget>[
            IconButton(
              iconSize: 30,
              icon: Icon(
                Icons.people_outline_outlined,
                color: Colors.white,
              ),
              onPressed: () async {
                Navigator.of(context).pushReplacementNamed('/ChooseTeamPage');
              },
            ),
            IconButton(
              iconSize: 30,
              icon: Icon(
                Icons.exit_to_app_rounded,
                color: Colors.white,
              ),
              onPressed: () async {
                // do something
                sharedPreferences = await SharedPreferences.getInstance();
                sharedPreferences.clear();
                Navigator.of(context).pushReplacementNamed('/LogIn');
              },
            )
          ],
        ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: Text('Show Material Dialog'),
              onPressed: _showMaterialDialog,
            ),
            RaisedButton(
              child: Text('Show Cupertino Dialog'),
              onPressed: _showCupertinoDialog,
            ),
          ],
        ),
      )
    );
  }
}
