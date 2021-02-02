import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:social_media_buttons/social_media_button.dart';
import 'package:social_media_buttons/social_media_icons.dart';
import 'package:team_superstar/controllers/AuthController.dart';



class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends StateMVC<LoginPage> {

  AuthController _con;
  TextEditingController usernameController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  bool usernameTextboxSelected = true;
  bool pwdTextboxSelected = false;
  _LoginPageState() : super(AuthController()) {
    _con = controller;
  }


  @override
  void initState() {
    super.initState();
    print('IS LOADING');
    print(_con.isLoading);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    body:
    Form(
      key: _formKey,
      child: Container(
      decoration: BoxDecoration(
        //crea una sfumatura lineare verticale (topCenter a bottom Center)
        gradient: LinearGradient(
          colors: [
            Theme.of(context).accentColor,
            Colors.deepPurple[300],
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomRight
        ),
      ),
        child: _con.isLoading ? Center(child:  CircularProgressIndicator(),) : ListView(
          children: <Widget>[
            headerSection(),
            textSection(),
            buttonSection(),
            buttonRegister(),
            socialSection(),
            SizedBox(height: 50),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
              child: Column(children: [
                  Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.star, color: Colors.yellow, size: 70)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.star, color: Colors.yellow, size: 50)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(Icons.star, color: Colors.yellow, size: 70)
              ],
            ),
              ],))
          ],
        ),
    )
    )
    );
  }

  Container buttonSection(){
    return Container(
      //Width automatica in base allo schermo
      width: MediaQuery.of(context).size.width,
      height: 40.0,
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      margin: EdgeInsets.only(top: 30),
      child: RaisedButton(
        onPressed: (){
          if (_formKey.currentState.validate()) {
            _con.isLoading = true;
          //   setState(() {
          //   _isLoading = true;
          // });
          _con.logIn(usernameController.text, passwordController.text);
          print(_con.isLoading);
          }
        },
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Text("Login", style: TextStyle(color: Colors.black)),
      )
    );
  }

  Container buttonRegister(){
    return Container(
      //Width automatica in base allo schermo
      width: MediaQuery.of(context).size.width,
      height: 40.0,
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      margin: EdgeInsets.only(top: 30),
      child: RaisedButton(
      color: Colors.grey[200],
      onPressed: () {  
        Navigator.of(context).pushReplacementNamed("/SignIn");
      },
      child: Text("Register", style: TextStyle(color: Colors.black),),
      )
    );
  }

  Container socialSection() {
    return Container(
      child: Padding(
        padding: EdgeInsets.only(top:60),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SocialMediaButton.google(
              url: "https://twitter.com/CipliOnat",
              size: 35,
              color: Colors.red,
              onTap: () {
                print('onTap ');
              },
            ),
            SocialMediaButton.facebook(
              url: "https://twitter.com/CipliOnat",
              size: 35,
              color: Colors.blue,
              onTap: () {
                print('onTap ');
              },
            ),
          ]
        ),
      )
      );
  }
  Container textSection(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      margin: EdgeInsets.only(top: 15),
      child: Column(
        children:<Widget> [
          txtusername("username", Icons.account_circle),
          SizedBox(height: 30.0,),
          txtPassword("password", Icons.lock),
          
        ],
      ),
    );
  }

  //primo textbox username
  TextFormField txtusername(String title, IconData icon){
    return TextFormField(
      controller: usernameController,
      autofocus: true,
      validator: (value) => value.length<3 ? "Attenzione, inserire lo username" : null,
      style: TextStyle(color: Colors.white),
      onTap: () {
        setState(() {
          usernameTextboxSelected = true;
        });
      },
      onChanged: (text) {
        print("First text field: $text");
      },
      decoration: InputDecoration(
        hintText: title,
        hintStyle: TextStyle(color: Colors.white),
        icon: Icon(icon, color: usernameTextboxSelected ? Colors.white : Colors.black,),     
      ),
      
    );
  }

    //secondo textbox Password
  TextFormField txtPassword(String title, IconData icon){
    return TextFormField(
      controller: passwordController,
      validator: (value) => value.length<3 ? "Attenzione, inserire la password" : null,
      style: TextStyle(color: Colors.white),
      obscureText: _obscureText,
      onTap: () {
        setState(() {
          pwdTextboxSelected = true;
        });
      },
      decoration: InputDecoration(
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText?
            Icons.visibility : Icons.visibility_off,
            color: Colors.white,
          ), 
          onPressed: (){
            setState(() {
              _obscureText = !_obscureText;
            });
            }
          ),
        hintText: title,
        hintStyle: TextStyle(color: Colors.white),
        icon: Icon(icon, color: pwdTextboxSelected ? Colors.white : Colors.black,),
      ),
    );
  }

Container headerSection(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
      child: Row( 
      mainAxisAlignment:  MainAxisAlignment.spaceBetween,
      children: <Widget>[
      Text("Login", style: TextStyle(color: Colors.white, fontSize: 35.0, fontWeight: FontWeight.bold)),
      IconButton(
        icon: Icon(Icons.home), 
        color: Colors.white,
        iconSize: 35,
        onPressed: (){
          Navigator.of(context).pushReplacementNamed("/HomePage");
          }
        )
      ]),
    );
  }
}
