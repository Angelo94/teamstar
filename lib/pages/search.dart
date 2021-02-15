import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:team_superstar/controllers/AuthController.dart';
import 'package:team_superstar/models/User.dart';

class Search extends StatefulWidget {
  Search({Key key}) : super(key: key);
  @override
  _SearchListState createState() => new _SearchListState();
}

class _SearchListState extends StateMVC<Search> {
  Widget appBarTitle = new Text(
    "Invite People",
    style: new TextStyle(color: Colors.white),
  );
  AuthController _con_user;

  Icon actionIcon = new Icon(
    Icons.search,
    color: Colors.white,
  );
  final key = new GlobalKey<ScaffoldState>();
  final TextEditingController _searchQuery = new TextEditingController();
  List<String> _list;
  bool _IsSearching;
  String _searchText = "";

  _SearchListState() : super(AuthController()) {
    _con_user = controller;
    _searchQuery.addListener(() {
      if (_searchQuery.text.isEmpty) {
        setState(() {
          _IsSearching = false;
          _searchText = "";
        });
      } else {
        setState(() {
          _IsSearching = true;
          _searchText = _searchQuery.text;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _IsSearching = false;
    _con_user.getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: key,
      appBar: buildBar(context),
      body: new ListView(
        padding: new EdgeInsets.symmetric(vertical: 8.0),
        children: _IsSearching ? _buildSearchList() : _buildList(),
      ),
    );
  }

  List<ChildItem> _buildList() {
    return _con_user.availableUsers
        .map((user) => new ChildItem(_con_user, user.id.toString(),
            user.first_name, user.last_name, user.username))
        .toList();
  }

  List<ChildItem> _buildSearchList() {
    if (_searchText.isEmpty) {
      return _con_user.availableUsers
          .map((user) => new ChildItem(_con_user, user.id.toString(),
              user.first_name, user.last_name, user.username))
          .toList();
    } else {
      List<User> _searchList = List();
      for (int i = 0; i < _con_user.availableUsers.length; i++) {
        Map user = _con_user.availableUsers.elementAt(i).toMap();
        String username = user['username'];
        if (username.toLowerCase().contains(_searchText.toLowerCase())) {
          _searchList.add(_con_user.availableUsers.elementAt(i));
        }
      }
      return _searchList
          .map((user) => new ChildItem(_con_user, user.id.toString(),
              user.first_name, user.last_name, user.username))
          .toList();
    }
  }

  Widget buildBar(BuildContext context) {
    return new AppBar(
        centerTitle: true,
        title: appBarTitle,
        backgroundColor: Colors.deepPurpleAccent,
        actions: <Widget>[
          new IconButton(
            icon: actionIcon,
            onPressed: () {
              setState(() {
                if (this.actionIcon.icon == Icons.search) {
                  this.actionIcon = new Icon(
                    Icons.close,
                    color: Colors.white,
                  );
                  this.appBarTitle = new TextField(
                    controller: _searchQuery,
                    style: new TextStyle(
                      color: Colors.white,
                    ),
                    autofocus: true,
                    decoration: new InputDecoration(
                        prefixIcon: new Icon(Icons.search, color: Colors.white),
                        hintText: "Search...",
                        hintStyle: new TextStyle(color: Colors.white)),
                  );
                  _handleSearchStart();
                } else {
                  _handleSearchEnd();
                }
              });
            },
          ),
        ]);
  }

  void _handleSearchStart() {
    setState(() {
      _IsSearching = true;
    });
  }

  void _handleSearchEnd() {
    _IsSearching = false;
    this.actionIcon = new Icon(
      Icons.search,
      color: Colors.white,
    );
    this.appBarTitle = new Text(
      "Search Teams",
      style: new TextStyle(color: Colors.white),
    );
    _searchQuery.clear();
  }
}

class ChildItem extends StatelessWidget {
  final AuthController _con;
  final String id;
  final String first_name;
  final String last_name;
  final String username;
  ChildItem(this._con, this.id, this.first_name, this.last_name, this.username);
  @override
  Widget build(BuildContext context) {
    return new ListTile(
        onTap: () {
          print('tapping member');
          AwesomeDialog(
            context: context,
            dialogType: DialogType.QUESTION,
            animType: AnimType.BOTTOMSLIDE,
            body: Center(
                child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Would you like add",
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    (this.first_name != '' && this.first_name != null)
                        ? new Text(this.first_name + ' ' + this.last_name,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold))
                        : new Text(this.username,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold))
                  ],
                ),
                SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("to your team?", style: TextStyle(fontSize: 20)),
                  ],
                ),
                SizedBox(
                  height: 50,
                ),
              ],
            )),
            title: 'Info Utente',
            desc: 'Dialog description here.............',
            btnOkOnPress: () {
              _con.addInTeam(this.id);
            },
            btnCancelOnPress: () {},
            btnCancelIcon: Icons.delete,
            btnOkIcon: Icons.save,
          )..show();
        },
        title: (this.first_name != '' && this.first_name != null)
            ? new Text(this.first_name + ' ' + this.last_name)
            : new Text(this.username));
  }
}
