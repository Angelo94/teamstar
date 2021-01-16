// ignore: non_constant_identifier_names
import 'package:flutter_dotenv/flutter_dotenv.dart';

String base_url = 'http://192.168.1.6:8000' + '/api/'; // NOTE: or add your address ip
// ignore: non_constant_identifier_names
String onesignal_key = 'XXXXXXXX-XXXXXXXXXXXX-XXXXXXXXX';

// URLS
String login_api = base_url + 'auth/token/';
String register_api = base_url + 'auth/userregistration/';
String user_api = base_url + 'auth/user/';
String team_api = base_url + 'team/team/';