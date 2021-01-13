import 'package:flutter/material.dart';
import 'package:flutter_demo/pages/home.dart';
import 'package:flutter_demo/pages/search.dart';
import 'package:flutter_demo/pages/settings.dart';
import 'fancy_tab_bar.dart';
import 'tab_item.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  int page_index = 0;

  callback(newAbc) {
    setState(() {
      page_index = newAbc;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: AppBar(
          backgroundColor: PURPLE,
          title: Text("Team SuperStar"),
        ),
        bottomNavigationBar: FancyTabBar(page_index, callback),
        body: page_index == 0
            ? Home()
            : page_index == 1
                ? Search()
                : Settings());
  }
}
