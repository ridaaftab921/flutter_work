import 'dart:convert';
import 'package:facebook/Data/Profile.dart';
import 'package:facebook/Helper/Constants.dart';
import 'package:facebook/Manager/DatabaseManager.dart';
import 'package:facebook/Manager/SharedPreferenceManager.dart';
import 'package:facebook/ProfileScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;
import 'Data/Profile.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Constants.facebook,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<HomePage> {
  static final facebookLogin = FacebookLogin();
  Profile loggedInUser;
  String _message = '';
  String accessToken = '';


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: _background(),
    );
  }
  @override
  void initState() {
    getUser().then((value){
      print('Async done');
      if(loggedInUser != null ){
        navigateToProfile(loggedInUser);
      }
    });
    super.initState();
  }
  PreferredSizeWidget _appBar() {
    return AppBar(
      title: Text("Demo app"),
    );
  }
  _background() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.6, 0.8, 1.0],
          colors: [
            Colors.grey[200],
            Colors.grey[300],
            Colors.grey[400],
          ],
        )
      ),
      child: _body(),
    );
  }
  _body() {
    return Center (
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 100,),
          _facebookTitle(),
          SizedBox(height: 50,),
          SizedBox(
            height: 300,
            child: _facebookLogo(),
          ),
          _errorMessageDisplay(),
          _facebookLoginBtn(),
        ],
      ),
    );
  }
  _facebookTitle() {
    return Text(
      "Facebook Utility",
      style: new TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 24,
        color: Constants.facebook,
      ),
    );
  }
  _facebookLoginBtn() {
    return RaisedButton(
        child: new Text(
          "Login with Facebook",
          style: new TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        color: Constants.facebook,
        padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
        onPressed: _login
    );
  }
  _errorMessageDisplay() {
    if (_message != null) {
      return Text(
        _message,
        style: new TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
          color: Colors.red,
        ),
      );
    } else {
      return Text("");
    }
  }
  _facebookLogo() {
    return Image.asset('assets/Facebook.png');
  }
  Future getUser() async {
    String userId = await SharedPreferenceManager.instance.getUserId();
    if(userId != null ) {
      loggedInUser = await DatabaseManager.instance.getUserWithId(userId);
    }
  }
  void _login() async {
    var profileObject = Profile(id: 12, name: "Rida", email: "", url: "");
    navigateToProfile(profileObject);
  }
  /*void _loginFacebook() async {

    final result = await facebookLogin.logIn(['email']);
    String newMessage;
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        accessToken = result.accessToken.token;
        saveUser(result.accessToken.userId, result.accessToken.expires);
        getUserProfile(result.accessToken.token, result.accessToken.expires);
        break;
      case FacebookLoginStatus.cancelledByUser:
        break;
      case FacebookLoginStatus.error:
        newMessage = 'Login error: ${result.errorMessage}';
        break;
    }

    setState(() {
      _message = newMessage;
    });
  }*/
  void getUserProfile(String token, DateTime expiry) async {
    final graphResponse = await http.get(
        'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email,picture.width(800).height(800),location,birthday,hometown&access_token=${token}');

//    final profile = json.decode(graphResponse.body);
//
//    final profileObject = Profile.fromJson(json.decode(graphResponse.body));
//    profileObject.expiry = expiry.toString();

    var profileObject = Profile(id: 12, name: "Rida", email: "", url: "");

    updateUser(profileObject);
    print(profileObject);
//    print(profile);
    navigateToProfile(profileObject);

  }
  void navigateToProfile(Profile profile) {
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProfileScreen(profile))
    );
  }
  void saveUser(String id, DateTime expiry) {

    SharedPreferenceManager.instance.saveUserId(id);

    Profile user = Profile(
      id: int.parse(id),
      expiry: expiry.toIso8601String(),
    );
    DatabaseManager.instance.insertUser(user);
  }
  void updateUser(Profile user) {
    DatabaseManager.instance.updateUser(user);
  }
}