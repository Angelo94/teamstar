import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:team_superstar/pages/home.dart';
import 'package:team_superstar/pages/search.dart';
import 'package:team_superstar/pages/settings.dart';
import 'package:team_superstar/routes.dart';
import 'fancy_tab_bar.dart';
import 'tab_item.dart';

Future main() async {
  await DotEnv().load('.env');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: MainPage(),
      initialRoute: '/MainPage',
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}

class MainPage extends StatefulWidget {
  MainPage({Key key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  int page_index = 1;
  SharedPreferences sharedPreferences;
  List<String> _list = [];
  

  callback(newAbc) {
    setState(() {
      page_index = newAbc;
    });
  }
  void init() {
    _list = List();
    _list.add("Team Google");
    _list.add("Team IOS");
    _list.add("Team Andorid");
    _list.add("Team Dart");
    _list.add("Team Flutter");
    _list.add("Team Python");
    _list.add("Team React");
    _list.add("Team Xamarin");
    _list.add("Team Kotlin");
    _list.add("Team Java");
    _list.add("Team RxAndroid");
  }
  List<ChildItem> _buildList() {
    init();
    return _list.map((contact) => new ChildItem(contact)).toList();
  }
  _showMaterialDialog() {
    showDialog(
        context: context,
        builder: (_) => new Dialog(
  backgroundColor: Colors.transparent,
  insetPadding: EdgeInsets.all(10),
  child: Stack(
    overflow: Overflow.visible,
    alignment: Alignment.center,
    children: <Widget>[
      Container(
        width: double.infinity,
        height: 600,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white
        ),
        padding: EdgeInsets.fromLTRB(20, 50, 20, 20),
        child: new ListView(
        padding: new EdgeInsets.symmetric(vertical: 8.0),
        children: _buildList(),
      ),
      ),
      Positioned(
        top: -100,
        child: Image.network("https://i.imgur.com/BnqYPv5.png", width: 150, height: 150)
      )
    ],
  )));
}
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: AppBar(
          backgroundColor: PURPLE,
          title: Text("Team SuperStar"),
          actions: <Widget>[
            IconButton(
              iconSize: 30,
              icon: Icon(
                Icons.people_outline_outlined,
                color: Colors.white,
              ),
              onPressed: () async {
               // Navigator.of(context).pushReplacementNamed('/ChooseTeamPage');
                _showMaterialDialog();
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
        bottomNavigationBar: FancyTabBar(page_index, callback),
        body: page_index == 0
            ? Search()
            : page_index == 1
                ? Home()
                : Settings());
  }
}
