import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:team_superstar/widgets/languages_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    bool lockInBackground = true;
    bool notificationsEnabled = true;

    _launchURL(url) async {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }

    return Scaffold(
      body: SettingsList(
        // backgroundColor: Colors.orange,
        sections: [
          SettingsSection(
            title: 'Common',
            // titleTextStyle: TextStyle(fontSize: 30),
            tiles: [
              SettingsTile(
                title: 'Language',
                subtitle: 'English',
                leading: Icon(Icons.language),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => LanguagesScreen()));
                },
              )
            ],
          ),
          SettingsSection(
            title: 'Security',
            tiles: [
              SettingsTile.switchTile(
                title: 'Change password',
                leading: Icon(Icons.lock),
                switchValue: true,
                onToggle: (bool value) {},
              ),
              SettingsTile.switchTile(
                title: 'Enable Notifications',
                enabled: notificationsEnabled,
                leading: Icon(Icons.notifications_active),
                switchValue: true,
                onToggle: (value) {},
              ),
            ],
          ),
          SettingsSection(
            title: 'Account',
            tiles: [
              SettingsTile(title: 'Email', leading: Icon(Icons.email)),
              SettingsTile(
                  title: 'Sign out',
                  leading: Icon(Icons.exit_to_app),
                  onTap: () async {
                    SharedPreferences sharedPreferences =
                        await SharedPreferences.getInstance();
                    sharedPreferences.clear();
                    Navigator.of(context).pushReplacementNamed('/LogIn');
                  }),
            ],
          ),
          SettingsSection(
            title: 'Misc',
            tiles: [
              SettingsTile(
                  title: 'support@crazystar', leading: Icon(Icons.support_agent_sharp), onTap: () {
                    _launchURL("mailto:support@crazystar");
                  }),
              SettingsTile(
                  title: 'Terms of Service', leading: Icon(Icons.description))
            ],
          ),
          CustomSection(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 22, bottom: 8),
                  child: Image.asset(
                    'assets/img/settings.png',
                    height: 50,
                    width: 50,
                    color: Color(0xFF777777),
                  ),
                ),
                Text(
                  'Crazy Star',
                  style: TextStyle(
                      color: Color(0xFF777777), fontWeight: FontWeight.bold),
                ),
                Text(
                  'Version: 1.1.0',
                  style: TextStyle(color: Color(0xFF777777)),
                ),
              ],
            ),
          ),
          CustomSection(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 5, bottom: 8),
                ),
                Text("Powered by: ",
                    style: TextStyle(color: Color(0xFF777777))),
                InkWell(
                    onTap: () {
                      const url = "https://www.tommasobellini.it";
                      _launchURL(url);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Tommaso Bellini ",
                            style: TextStyle(
                                color: Colors.deepPurple,
                                fontWeight: FontWeight.bold)),
                        Text("& "),
                        Text("Angelo Calabria",
                            style: TextStyle(
                                color: Colors.deepPurple,
                                fontWeight: FontWeight.bold)),
                      ],
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }
}
