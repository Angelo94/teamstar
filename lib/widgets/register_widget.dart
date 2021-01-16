import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:team_superstar/controllers/AuthController.dart';
import 'package:team_superstar/global_variables.dart';


class SigninPage extends StatefulWidget {
  @override
  _SigninPageState createState() => _SigninPageState();
}

class _SigninPageState extends StateMVC<SigninPage> {
  
  AuthController _con;
  TextEditingController emailController = new TextEditingController();
  // TextEditingController companyNameController = new TextEditingController();
  TextEditingController usernameController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController repeatPasswordController = new TextEditingController();
  final _formKey2 = GlobalKey<FormState>();
  String passSaved;
  bool _obscureText = true;
  bool _obscureText1 = true;


  _SigninPageState() : super(AuthController()) {
    _con = controller;
  }


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
    body:
    Form(
      key: _formKey2,
      child: Container(
      decoration: BoxDecoration(
        //crea una sfumatura lineare verticale (topCenter a bottom Center)
        gradient: LinearGradient(
          colors: [
            Theme.of(context).accentColor,
            Colors.orange[300],
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomLeft
        ),
      ),
        child: _con.isLoading ? Center(child:  CircularProgressIndicator(),) : ListView(
          children: <Widget>[
            headerSection(),
            textSection(),
            buttonSection(),
            buttonLogIn()
          ],
        ),
    )));
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
          if (_formKey2.currentState.validate()) {
            _con.isLoading = true;
          print(_con.isLoading);
          _con.signIn(usernameController.text, emailController.text, passwordController.text);
          }
        },
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Text("Registrati", style: TextStyle(color: Colors.black)),
      )
    );
  }

   Container buttonLogIn(){
    return Container(
      //Width automatica in base allo schermo
      width: MediaQuery.of(context).size.width,
      height: 40.0,
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      margin: EdgeInsets.only(top: 30),
      child: RaisedButton(
      color: Colors.grey[200],
      onPressed: () {  
        Navigator.of(context).pushReplacementNamed("/LogIn");
      },
      child: Text("Già registrato, Login!", style: TextStyle(color: Colors.black),),
      )
    );
  }


signIn(String username, password) async {
Map data = {
  'username': username,
  'password': password
};
var jsonData = null;
SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  var response = await http.post(login_api, body: data);
  print(response.statusCode);
  if(response.statusCode == 200){
    jsonData = json.decode(response.body);

    setState(() {
      _con.isLoading = false;
      print(jsonData['key']);
      sharedPreferences.setString("token", jsonData['token']);
    }
    );

   
  }
  else{
    print(response.body);
    setState(() {
      _con.isLoading = false;
    });
    var error = json.decode(response.body);
    var field = '';
    if(error['password'] == null || error['username']==null) {
      error = error['non_field_errors'];
      field = 'Credentials';
    }
    print(error);
    if (error[0]!=null){
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              title: new Text(field),
              content: new Text(error[0]),
              actions: <Widget>[
                FlatButton(
                  child: Text('Ok'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            ));
    }
  
  }
}

  Container textSection(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      margin: EdgeInsets.only(top: 15),
      child: Column(
        children:<Widget> [
          txtUserName("username", Icons.account_circle),
          SizedBox(height: 30.0,),
          // txtCompanyName("Company name", FontAwesomeIcons.building),
          // SizedBox(height: 30.0,),
          txtEmail("email", Icons.email),
          SizedBox(height: 30.0,),
          txtPassword("password", Icons.lock),
          SizedBox(height: 30.0,),
          txtRepeatPassword("conferma password", Icons.lock),
        ],
      ),
    );
  }

    TextFormField txtUserName(String title, IconData icon){
    return TextFormField(
      controller: usernameController,
      validator: (value) => value.length < 3 ? "Attenzione, inserire uno username valido" : null,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: title,
        hintStyle: TextStyle(color: Colors.white),
        icon: Icon(icon, color: Colors.black,)
      ),
    );
  }

  //     TextFormField txtCompanyName(String title, IconData icon){
  //   return TextFormField(
  //     controller: nameController,
  //     validator: (value) => value.isEmpty ? "Attenzione, inserire un'azienda valida" : null,
  //     style: TextStyle(color: Colors.white),
  //     decoration: InputDecoration(
  //       hintText: title,
  //       hintStyle: TextStyle(color: Colors.white),
  //       icon: Icon(icon)
  //     ),
  //   );
  // }
  //primo textbox email
  TextFormField txtEmail(String title, IconData icon){
    return TextFormField(
      controller: emailController,
      validator: (value) { 
        if(value.length<3 || !value.contains("@"))
        { 
          return "Attenzione, inserire una mail valida";
        } 
        else return null;
      },
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: title,
        hintStyle: TextStyle(color: Colors.white),
        icon: Icon(icon, color: Colors.black,)
      ),
    );
  }

    //secondo textbox Password
  TextFormField txtPassword(String title, IconData icon){
    return TextFormField(
      controller: passwordController,
      validator: (value) {
         setState((){
          passSaved = value;
        });
        if(value.length<3) 
        {
          return "Attenzione, inserire la password";
         } else return null;
      },
      style: TextStyle(color: Colors.white),
      obscureText: _obscureText,
      decoration: InputDecoration(
        hintText: title,
        hintStyle: TextStyle(color: Colors.white),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility : Icons.visibility_off,
          ),
          color: Colors.white,
          onPressed: (){
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        ),
        icon: Icon(icon, color: Colors.black),
      ),
    );
  }

  TextFormField txtRepeatPassword(String title, IconData icon){
    return TextFormField(
      controller: repeatPasswordController,
      validator: (value) {
        if(value.length < 3) {
        return "Attenzione, inserire la password"; 
        }
        else if (value!=passSaved){
        return "Le due password non coincidono!";
        }
        else return null;
      },
      style: TextStyle(color: Colors.white),
      obscureText: _obscureText1,
      decoration: InputDecoration(
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText1 ? Icons.visibility : Icons.visibility_off,
          ),
          color: Colors.white,
          onPressed: (){
            setState(() {
              _obscureText1 = !_obscureText1;
            });
          },
        ),
        hintText: title,
        hintStyle: TextStyle(color: Colors.white),
        icon: Icon(icon, color: Colors.black)
      ),
    );
  }



  Container headerSection(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
      child: Row( 
      mainAxisAlignment:  MainAxisAlignment.spaceBetween,
      children: <Widget>[
      Text("Registrazione", style: TextStyle(color: Colors.white, fontSize: 35.0, fontWeight: FontWeight.bold)),
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