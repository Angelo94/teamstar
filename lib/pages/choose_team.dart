import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:team_superstar/controllers/TeamController.dart';
import 'package:team_superstar/models/planets.dart';
import 'package:team_superstar/widgets/planet_row.dart';
import 'package:team_superstar/widgets/skeleton_loader_widget.dart';

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
        body: _con.isLoading
            ? Center(child: buildLoader())
            : new CustomScrollView(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                slivers: <Widget>[
                  new SliverPadding(
                    padding: const EdgeInsets.symmetric(vertical: 18.0),
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
                            Navigator.of(context)
                                .pushReplacementNamed('/MainPage');
                          },
                        ),
                        childCount: _con.teams.length,
                      ),
                    ),
                  ),
                ],
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

class FullScreenDialogState extends StateMVC<FullScreenDialog> {
  TextEditingController _skillOneController = new TextEditingController();
  TextEditingController _skillTwoController = new TextEditingController();
  TextEditingController _skillThreeController = new TextEditingController();
  TeamController _con;
  final _formKey = GlobalKey<FormState>();

  FullScreenDialogState() : super(TeamController()) {
    _con = controller;
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Create a new Team"),
        ),
        body: Form(
          key: _formKey,
          child: Container(
            padding: EdgeInsets.only(right: 20, left: 20),
            child: _con.isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView(
                    children: <Widget>[
                      SizedBox(
                        height: 50,
                      ),
                      TextFormField(
                        controller: _skillOneController,
                        autofocus: true,
                        validator: (value) => value.length < 3
                            ? "Please, insert team name"
                            : null,
                        style: TextStyle(color: Colors.black),
                        onTap: () {},
                        onChanged: (text) {
                          print("First text field: $text");
                        },
                        decoration: InputDecoration(
                          hintText: "ex. SpiceGirls",
                          hintStyle: TextStyle(color: Colors.black),
                          icon: Icon(
                            Icons.badge,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      TextFormField(
                        controller: _skillTwoController,
                        autofocus: true,
                        validator: (value) => value.length < 3
                            ? "Please, insert target name"
                            : null,
                        style: TextStyle(color: Colors.black),
                        onTap: () {},
                        onChanged: (text) {
                          print("First text field: $text");
                        },
                        decoration: InputDecoration(
                          hintText: "ex. Coffee",
                          hintStyle: TextStyle(color: Colors.black),
                          icon: Icon(
                            Icons.track_changes_outlined,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      TextFormField(
                        controller: _skillThreeController,
                        autofocus: true,
                        validator: (value) => value.length < 1
                            ? "Please, insert target limit max"
                            : null,
                        style: TextStyle(color: Colors.black),
                        onTap: () {},
                        onChanged: (text) {
                          print("First text field: $text");
                        },
                        decoration: InputDecoration(
                          hintText: "ex. 5",
                          hintStyle: TextStyle(color: Colors.black),
                          icon: Icon(
                            Icons.calculate,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      new Row(
                        children: <Widget>[
                          new Expanded(
                              child: AnimatedButton(
                            isFixedHeight: false,
                            pressEvent: () {
                              widget._skillThree = _skillThreeController.text;
                              widget._skillTwo = _skillTwoController.text;
                              widget._skillOne = _skillOneController.text;
                              if (_formKey.currentState.validate()) {
                                _con.createTeam({
                                  'name': widget._skillOne,
                                  'target_name': widget._skillTwo,
                                  'target_max': widget._skillThree
                                });
                                Navigator.of(context).pop();
                                _con.getTeams();
                              }
                            },
                            text: 'Salva',
                            color: Color(0xFF00CA71),
                          ))
                        ],
                      )
                    ],
                  ),
          ),
        ));

    //       new Padding(
    //         child: new ListView(
    //           children: <Widget>[
    //             SizedBox(
    //               height: 25,
    //             ),
    //             Text("Team name"),
    //             TextFormField(
    //               controller: _skillOneController,
    //               autofocus: true,
    //               validator: (value) => value.length < 3
    //                   ? "Attenzione, inserire lo username"
    //                   : null,
    //               style: TextStyle(color: Colors.white),
    //               onTap: () {},
    //               onChanged: (text) {
    //                 print("First text field: $text");
    //               },
    //               decoration: InputDecoration(
    //                 hintText: "ex. SpiceGirls",
    //                 hintStyle: TextStyle(color: Colors.white),
    //                 icon: Icon(
    //                   Icons.description,
    //                 ),
    //               ),
    //             ),
    //             new TextField(
    //               decoration: InputDecoration(
    //                 hintText: "ex. SpiceGirls",
    //               ),
    //               controller: _skillOneController,
    //               scrollPadding: EdgeInsets.all(20.0),
    //               keyboardType: TextInputType.multiline,
    //               autofocus: true,
    //             ),
    //             SizedBox(
    //               height: 50,
    //             ),
    //             Text("Team target name"),
    //             new TextField(
    //               decoration: InputDecoration(
    //                 hintText: "ex. Coffee",
    //               ),
    //               controller: _skillTwoController,
    //               scrollPadding: EdgeInsets.all(20.0),
    //               keyboardType: TextInputType.multiline,
    //               autofocus: true,
    //             ),
    //             SizedBox(
    //               height: 50,
    //             ),
    //             Text("Team target max limit"),
    //             new TextField(
    //               decoration: InputDecoration(
    //                 hintText: "ex. 5",
    //               ),
    //               controller: _skillThreeController,
    //               scrollPadding: EdgeInsets.all(20.0),
    //               keyboardType: TextInputType.multiline,
    //               autofocus: true,
    //             ),
    //             SizedBox(
    //               height: 50,
    //             ),
    //             new Row(
    //               children: <Widget>[
    //                 new Expanded(
    //                     child: AnimatedButton(
    //                   isFixedHeight: false,
    //                   pressEvent: () {
    //                     widget._skillThree = _skillThreeController.text;
    //                     widget._skillTwo = _skillTwoController.text;
    //                     widget._skillOne = _skillOneController.text;
    //                     if (_formKey.currentState.validate()) {
    //                       _con.createTeam({
    //                         'name': widget._skillOne,
    //                         'target_name': widget._skillTwo,
    //                         'target_max': widget._skillThree
    //                       });
    //                       Navigator.of(context).pop();
    //                     }
    //                   },
    //                   text: 'Salva',
    //                   color: Color(0xFF00CA71),
    //                 ))
    //               ],
    //             )
    //           ],
    //         ),
    //         padding: const EdgeInsets.symmetric(horizontal: 20.0),
    //       ));
  }
}
