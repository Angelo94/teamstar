
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

//CRUD --> CERATE(POST), READ(GET), UPDATE(PUT), DELETE(DELETE)
//all the crud process corresponds to a http operation


 //CREATE(POST)
authenticatedPost(url, body) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var _token = sharedPreferences.getString("token");
    var response = await http.post(
      url,
      headers: {
        "Authorization": "Token $_token",
      },
      body: body
    );
    return response;
}

authenticatedPostToken(url, body, token) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var response = await http.post(
      url,
      headers: {
        "Authorization": "Token $token",
      },
      body: body
    );
    return response;
}

apiPost(url, body) async {
    print(body);
    var response = await http.post(
      url,
      body: body
    );
    return response;
}


//READ(GET)
authenticatedGet(url) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var _token = sharedPreferences.getString("token");
    var response = await http.get(
      url,
      headers: {
        "Authorization": "Token $_token",
      }
    );
    return response;
}

apiGet(url) async {
    var response = await http.get(
      url,
    );
    return response;
}

//UPDATE(PUT)
apiPut(url, body) async{
  var response = await http.put(
    url,
    body: body,
  );
  return response;
}

apiPutAuthenticated(url, body) async{
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  var _token = sharedPreferences.getString("token");
  var response = await http.put(
    url,
    body: body,
    headers: {
      "Authorization": "Token $_token",
    }
  );
  return response;
}

//DELETE(DELETE)

apiDelete(url) async{
  var response = http.delete(url);
  return response;
}

apiDeleteAuthenticated(url) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  var _token = sharedPreferences.getString("token");
  var response = http.delete(url, headers: 
  {
    "Authorization": "Token $_token",
  }
  );
  return response;
}