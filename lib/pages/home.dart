import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:team_superstar/controllers/AuthController.dart';
import 'package:team_superstar/controllers/TeamController.dart';
import 'package:animated_icon_button/animated_icon_button.dart';
import 'package:team_superstar/widgets/skeleton_loader_widget.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => new _HomeState();
}

class _HomeState extends StateMVC<Home> {
  int _pageIndex = 0;
  String username;
  TeamController _con;
  LocalStorage storage_user = new LocalStorage("user");
  LocalStorage storage = new LocalStorage("device_info");
  SharedPreferences sharedPreferences;
  bool addButtonSelected = false;
  bool removeButtonSelected = false;
  bool isLogged = false;
  String targetName = "";
  String teamName = "";
  String targetMax = "";

  final dataKey = new GlobalKey();
  _HomeState() : super(TeamController()) {
    _con = controller;
  }

  void getTeamInfo() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String teamId = sharedPreferences.getString("team_chose");
    String team_name = sharedPreferences.getString("team_name");
    String target_name = sharedPreferences.getString("target_name");
    String target_max = sharedPreferences.getString("target_max");
    if (teamId != null) {
      _con.getTeamMembers(teamId);
      setState(()=>{
        teamName = team_name,
        targetName = target_name,
        targetMax = target_max,
      });
       setState(() {
        _con.isLoading = true;
      });
    }
  }

  String getUsername() {
    if (storage_user.getItem("username") != null) {
      setState(() {
        username = storage_user.getItem("username");
      });
    } else
      username = "user";
  }

  checkToken() async {
    sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences.getString("token");
    print('TOKEN');
    print(token);
    bool check = false;
    token != null ? check = true : check = false;
    setState(() {
      isLogged = check;
    });
    if (isLogged == true) {
    } else
      Navigator.of(context).pushReplacementNamed('/LogIn');
  }

  @override
  void initState() {
    super.initState();
    getUsername();
    checkToken();
    print('IS LOADING');
    print(_con.isLoading);
    getTeamInfo();
  }

  Widget build(BuildContext context) {
    //List<String> teamMembers = _con.teamMembers.length > 0 ? _con.teamMembers : [];

    return new Scaffold(
      primary: true,
      body: _con.isLoading ? Center(child: buildLoader()) : new SingleChildScrollView(
        child: new Column(
          children: <Widget>[
            for (var i in _con.teamMembers)
              new SizedBox(
                  height: 130.0,
                  width: double.infinity,
                  child: new Card(
                    child: InkWell(
                      onTap: () {
                          print('tapping');
                          AwesomeDialog(
                              context: context,
                              dialogType: DialogType.INFO,
                              animType: AnimType.BOTTOMSLIDE,
                              body: Center(
                                child:  Column(children: [
                                Row(mainAxisAlignment: MainAxisAlignment.center,children: [
                                  Text("Add or remove star", style: TextStyle(fontSize: 20),),
                                ],),
                                Row(mainAxisAlignment: MainAxisAlignment.center,children: [
                                  Text("to", style: TextStyle(fontSize: 20),),
                                ],),
                                Row(mainAxisAlignment: MainAxisAlignment.center,children: [
                                  Text("${i['user']['first_name']} ${i['user']['last_name']}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                ],),
                                SizedBox(height: 50,),
                                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                  Text("+", style: TextStyle(fontSize:50, fontWeight: FontWeight.w500, color: Colors.grey)),
                                   AnimatedIconButton(
                                        size: 70,
                                        onPressed: () {
                                          print("star assigned");
                                          if (addButtonSelected) {
                                            setState(() {
                                              addButtonSelected = false;
                                            });
                                          } else {
                                            setState(() {
                                              addButtonSelected = true;
                                            });
                                             _con.addStar(i);
                                            getTeamInfo();
                                          }
                                         
                                        },
                                        duration: Duration(milliseconds: 200),
                                        endIcon: Icon(
                                            Icons.star,
                                                color: Colors.orangeAccent,
                                            ),
                                        startIcon: Icon(
                                            Icons.star,
                                            color: Colors.grey,
                                        ),
                                    ),
                                    SizedBox(
                                      width: 40,
                                    ),
                                     AnimatedIconButton(
                                        size: 70,
                                        onPressed: () {
                                          print("button with color pressed");
                                           if (removeButtonSelected) {
                                            setState(() {
                                              removeButtonSelected = false;
                                            });
                                          } else {
                                            setState(() {
                                              removeButtonSelected = true;
                                            });
                                             _con.removeStar(i);
                                            getTeamInfo();
                                          }
                                        },
                                        duration: Duration(milliseconds: 200),
                                        endIcon: Icon(
                                            Icons.star_outline,
                                                color: Colors.red,
                                            ),
                                        startIcon: Icon(
                                            Icons.star_outline,
                                            color: Colors.grey,
                                        ),
                                    ),
                                  Text("-", style: TextStyle(fontSize:50, fontWeight: FontWeight.w500, color: Colors.grey)),
                                ],),
                                SizedBox(height: 50,),
                              ],)),
                              title: 'Info Utente',
                              desc: 'Dialog description here.............',
                              // btnCancelOnPress: () {},
                              // btnOkOnPress: () {},
                              // btnCancelIcon: Icons.delete,
                              // btnOkIcon: Icons.save,
                              // btnCancelText: "Annulla",
                              // btnOkText: "Salva",
                            )..show();
                      },
                      child: Row(
                      children: <Widget>[
                        // Column 1
                        Expanded(
                          flex: 7,
                          child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(i['user']['first_name'] + ' ' + i['user']['last_name'],
                                          style: TextStyle(
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.bold)),
                                    ]),
                                SizedBox(height: 2),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: List.generate(i['star_counter'],(index){
                                          return  Icon(Icons.star_border,
                                            color: Colors.amber, size: 30.0);
                                      })),
                                SizedBox(height: 2),
                              ],
                            ),
                          ),
                        ),
                        // Column 2
                        // The Place where I am Stuck//
                        Expanded(
                          flex: 3,
                          child: Container(
                            color: Colors.white,
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Container(
                                  alignment: Alignment.center,
                                  width: 120,
                                  height: 120,
                                  child: Stack(
                                    children: <Widget>[
                                      Container(
                                          width: 80,
                                          height: 80,
                                          child: CircleAvatar(
                                            backgroundImage: NetworkImage(
                                                'https://i.pinimg.com/originals/51/f6/fb/51f6fb256629fc755b8870c801092942.png'),
                                            backgroundColor: Colors.transparent,
                                          )),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
              )))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        AwesomeDialog(
            context: context,
            dialogType: DialogType.QUESTION,
            animType: AnimType.SCALE,
            btnOkOnPress: () {},
            body: Center(
              child: Column(children: [
                Row(children: [
                  Text("Team name: ${teamName}", style: TextStyle(fontSize: 20))
                ],),
                Row(children: [
                  Text("Target name: ${targetName}", style: TextStyle(fontSize: 20))
                ],),
                Row(children: [
                  Text("Target max: ${targetMax}", style: TextStyle(fontSize: 20))
                ],)
              ],)
            )
            )..show();
      },  child: Icon(Icons.info_sharp, size: 50))
    );
  }
}
