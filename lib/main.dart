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
      title: 'Crazy Star',
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
  String team_name = "Crazy Star";
  SharedPreferences sharedPreferences;
  List<String> _list = [];
  

  callback(newAbc) {
    setState(() {
      page_index = newAbc;
    });
  }
  getTeamInfo() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String team_id = sharedPreferences.getString("team_chose");
    team_name = sharedPreferences.getString("team_name");
    print("team chose");
    print(team_id);
  }

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    getTeamInfo();
    

    return Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: AppBar(
          backgroundColor: PURPLE,
          title: Text(team_name),
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
        bottomNavigationBar: FancyTabBar(page_index, callback),
        body: page_index == 0
            ? Search()
            : page_index == 1
                ? Home()
                : Settings());
  }
}
