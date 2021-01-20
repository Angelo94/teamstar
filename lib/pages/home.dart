import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => new _HomeState();
}

class _HomeState extends State<Home> {
  int _pageIndex = 0;
  String username;
  LocalStorage storage_user = new LocalStorage("user");
  LocalStorage storage = new LocalStorage("device_info");
  PageController _pageController;
  SharedPreferences sharedPreferences;
  bool isLogged = false;
  final dataKey = new GlobalKey();

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
    _pageController = PageController(initialPage: _pageIndex);
  }

  Widget build(BuildContext context) {
    List<String> text = [
      "angelo",
      "tom",
      "ema",
      "paolo",
      "cds",
      "csdv",
      "fdsf"
    ];
    return new Scaffold(
      primary: true,
      body: new SingleChildScrollView(
        child: new Column(
          children: <Widget>[
            for (var i in text)
              new SizedBox(
                  height: 130.0,
                  width: double.infinity,
                  child: new Card(
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
                                      Text(i,
                                          style: TextStyle(
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.bold)),
                                    ]),
                                SizedBox(height: 2),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(Icons.star_border,
                                          color: Colors.amber, size: 30.0),
                                      Icon(Icons.star_border,
                                          color: Colors.amber, size: 30.0),
                                      Icon(Icons.star_border,
                                          color: Colors.amber, size: 30.0),
                                      Icon(Icons.star_border,
                                          color: Colors.amber, size: 30.0),
                                      Icon(Icons.star_border,
                                          color: Colors.amber, size: 30.0),
                                    ]),
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
                  ))
          ],
        ),
      ),
    );
  }
}
