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

  @override
  void initState(){
    super.initState();
    getUsername();
    checkToken();
    _pageController = PageController(initialPage: _pageIndex);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navigate back to first route when tapped.
          },
          child: Text('Home!'),
        ),
      ),
    );
  }
}
