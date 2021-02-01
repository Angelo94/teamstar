import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:team_superstar/controllers/TeamController.dart';
import 'package:team_superstar/models/planets.dart';
import 'package:team_superstar/widgets/planet_row.dart';

class ChooseTeam extends StatefulWidget {
  @override
  _ChooseTeamState createState() => new _ChooseTeamState();
}

class _ChooseTeamState extends StateMVC<ChooseTeam> {
  TeamController _con;

  int _pageIndex = 0;
  String username;
  LocalStorage storage_user = new LocalStorage("user");
  LocalStorage storage = new LocalStorage("device_info");
  PageController _pageController;
  SharedPreferences sharedPreferences;
  bool isLogged = false;

  _ChooseTeamState() : super(TeamController()) {
    _con = controller;
  }

  void initState() {
    super.initState();
    print('get teams');
    _con.getTeams();
    print(_con.teams);
  }

  // List<ChildItem> _buildTeamList() {
  //   print(_con.teams.length);
  //   return _con.teams.map((team) => new ChildItem(team['id'],team['name'],team['target_name'],team['target_max'])).toList();
  // }
  @override
  Widget build(BuildContext context) {
    FullScreenDialog _myDialog = new FullScreenDialog();
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.purple,
          title: Text("Crazy Star"),
          actions: <Widget>[
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
        body: new Container(
          child: Column(mainAxisAlignment: MainAxisAlignment.center,
          children: [
            new CustomScrollView(
            scrollDirection: Axis.vertical,
            shrinkWrap: false,
            slivers: <Widget>[
              new SliverPadding(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                sliver: new SliverList(
                  delegate: new SliverChildBuilderDelegate(
                    (context, index) => new InkWell(
                      child: new PlanetRow(_con.teams[index]),
                      onTap: () async {
                        print('tapping');
                        SharedPreferences sharedPreferences =
                            await SharedPreferences.getInstance();
                        sharedPreferences.setString(
                            "team_chose", _con.teams[index].id.toString());
                        sharedPreferences.setString(
                            "team_name", _con.teams[index].name);
                        sharedPreferences.setString(
                            "target_name", _con.teams[index].target_name);
                        sharedPreferences.setString("target_max",
                            _con.teams[index].target_max.toString());
                        Navigator.of(context).pushReplacementNamed('/MainPage');
                      },
                    ),
                    childCount: _con.teams.length,
                  ),
                ),
              ),
            ],
          ),
          ],
        ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                new MaterialPageRoute(
                  builder: (BuildContext context) => _myDialog,
                  fullscreenDialog: true,
                ));
          },
          child: Icon(Icons.person_add_alt),
        ));
    // return Scaffold(
    //   appBar: AppBar(
    //       backgroundColor: Colors.purple,
    //       title: Text("Crazy Star"),
    //       actions: <Widget>[
    //         IconButton(
    //           iconSize: 30,
    //           icon: Icon(
    //             Icons.exit_to_app_rounded,
    //             color: Colors.white,
    //           ),
    //           onPressed: () async {
    //             // do something
    //             sharedPreferences = await SharedPreferences.getInstance();
    //             sharedPreferences.clear();
    //             Navigator.of(context).pushReplacementNamed('/LogIn');
    //           },
    //         )
    //       ],
    //     ),
    //   body: new Expanded(
    //   child: new Container(
    //     color: new Color(0xFF736AB7),
    //     child: new CustomScrollView(
    //         scrollDirection: Axis.vertical,
    //         shrinkWrap: false,
    //         slivers: <Widget>[
    //           new SliverPadding(
    //             padding: const EdgeInsets.symmetric(vertical: 24.0),
    //             sliver: new SliverList(
    //               delegate: new SliverChildBuilderDelegate(
    //                   (context, index) => new PlanetRow(planets[index]),
    //                 childCount: planets.length,
    //               ),
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    //   // _con.teams.length != 0 ?  new ListView(
    //   //                     children: _buildTeamList(),
    //   //                   ) : ("Your teams will be prompted here!"),
    //   floatingActionButton: FloatingActionButton(onPressed: (){
    //     Navigator.push(context, new MaterialPageRoute(
    //               builder: (BuildContext context) => _myDialog,
    //               fullscreenDialog: true,
    //             ));
    //   },  child: Icon(Icons.person_add_alt), )
    // );
  }
}

class FullScreenDialog extends StatefulWidget {
  String _skillOne = "You have";
  String _skillTwo = "not Added";
  String _skillThree = "any skills yet";

  @override
  FullScreenDialogState createState() => new FullScreenDialogState();
}

class FullScreenDialogState extends State<FullScreenDialog> {
  TextEditingController _skillOneController = new TextEditingController();
  TextEditingController _skillTwoController = new TextEditingController();

  TextEditingController _skillThreeController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Create a new"),
        ),
        body: new Padding(
          child: new ListView(
            children: <Widget>[
              new TextField(
                controller: _skillOneController,
              ),
              new TextField(
                controller: _skillTwoController,
              ),
              new TextField(
                controller: _skillThreeController,
              ),
              new Row(
                children: <Widget>[
                  new Expanded(
                      child: new RaisedButton(
                    onPressed: () {
                      widget._skillThree = _skillThreeController.text;
                      widget._skillTwo = _skillTwoController.text;
                      widget._skillOne = _skillOneController.text;
                      Navigator.pop(context);
                    },
                    child: new Text("Save"),
                  ))
                ],
              )
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
        ));
  }
}
