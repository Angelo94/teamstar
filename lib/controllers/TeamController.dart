import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:team_superstar/global_variables.dart';
import 'package:team_superstar/utils.dart';

class TeamController extends ControllerMVC {
  bool isLoading = false;
  List teamMembers = [];
  LocalStorage storage_team = new LocalStorage("team");
  List teams = [];

  getTeams() async {
    var jsonData = null;
    setState(() {
          isLoading = true;
    });
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var response = await authenticatedGet(team_api + "?user=" + sharedPreferences.getString('user_id'));
    print(response.statusCode);
    if (response.statusCode == 200) {
        jsonData = json.decode(response.body);
        print(jsonData);
        setState(() {
          teams = jsonData;
         });
       
    }
     setState(() {
          isLoading = false;
         });
  }

  getTeamMembers(teamId) async {
    print(user_api + '?team=' + teamId);
    var response = await authenticatedGet(team_api + teamId);
    print(response.statusCode);
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      print(jsonData);
      setState(() {
        teamMembers = jsonData['members'];
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
}
