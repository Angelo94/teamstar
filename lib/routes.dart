
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:team_superstar/main.dart';
import 'package:team_superstar/pages/choose_team.dart';
import 'package:team_superstar/pages/home.dart';
import 'package:team_superstar/widgets/login_widget.dart';
import 'package:team_superstar/widgets/register_widget.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;
    switch (settings.name) {
      case '/MainPage':
        return MaterialPageRoute(builder: (_) => MainPage());
      case '/ChooseTeamPage':
        return MaterialPageRoute(builder: (_) => ChooseTeam());
      case '/HomePage':
        return MaterialPageRoute(builder: (_) => Home());
      case '/HomePageLogged':
        return MaterialPageRoute(builder: (_) => Home());
      case '/LogIn':
        return MaterialPageRoute(builder: (_)=> LoginPage());
      case '/SignIn':
        return MaterialPageRoute(builder: (_) => SigninPage());
      
    }
  }
    static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}