// ignore: non_constant_identifier_names
import 'package:flutter_dotenv/flutter_dotenv.dart';

String base_url =
    'http://34.251.245.121:8000' + '/api/'; // NOTE: or add your address ip
// ignore: non_constant_identifier_names
String onesignal_key = 'dd43cf2f-c90a-4e93-bd23-16e2b0687f61';

// URLS
String login_api = base_url + 'auth/token/';
String register_api = base_url + 'auth/userregistration/';
String user_api = base_url + 'auth/user/';
String team_api = base_url + 'teamstar/team/';
