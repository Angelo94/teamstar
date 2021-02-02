import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:team_superstar/global_variables.dart';
import 'package:team_superstar/models/Team.dart';
import 'package:team_superstar/utils.dart';

class TeamController extends ControllerMVC {
  bool isLoading = false;
  List teamMembers = [];
  LocalStorage storage_team = new LocalStorage("team");
  List<Team> teams = [];

  getTeams() async {
    var jsonData = null;
    setState(() {
          isLoading = true;
    });
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String user_id = sharedPreferences.getString('user_id');
    if (user_id == null || user_id == '') {
        Navigator.of(context).pushReplacementNamed('/LogIn');
    } else {
       var response = await authenticatedGet(team_api + "?user=" + user_id);
    print(response.statusCode);
    if (response.statusCode == 200) {
        jsonData = json.decode(response.body);
        print(jsonData);
        List<Team> teams_list = [];
        for (var team in jsonData) {
          teams_list.add(Team.fromJSON(team));
        }
        setState(() {
          teams = teams_list;
         });
       
    }
     setState(() {
          isLoading = false;
         });
  
    }
   }

  getTeamMembers(teamId) async {
    print(user_api + '?team=' + teamId);
    setState(() {
      isLoading = true;
    });
    var response = await authenticatedGet(team_api + teamId);
    print(response.statusCode);
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      print(jsonData);
      setState(() {
        teamMembers = jsonData['members'];
      });
      setState(() {
        isLoading = false;
      });
    }
  }

  addStar(data) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String teamId = sharedPreferences.getString("team_chose");
    String userId = data['user']['id'].toString();
    var response = await apiPutAuthenticated('${user_api}${userId}/add_star/?team=${teamId}', {});
    print(response.statusCode);
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      print(jsonData);
    }
  }

  removeStar(data) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String teamId = sharedPreferences.getString("team_chose");
    String userId = data['user']['id'].toString();
    var response = await apiPutAuthenticated('${user_api}${userId}/remove_star/?team=${teamId}', {});
    print(response.statusCode);
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      print(jsonData);
    }
  }

  createTeam(data) async {
    var response = await apiPutAuthenticated('${team_api}', data);
    print(response.statusCode);
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      print(jsonData);
    }
  }
}
