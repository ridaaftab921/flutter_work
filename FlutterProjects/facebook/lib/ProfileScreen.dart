import 'package:facebook/Data/Profile.dart';
import 'package:facebook/Manager/DatabaseManager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'Locations.dart';
import 'NearByResturants.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen(this.userProfile);

  final Profile userProfile;
  @override
  _ProfileScreenState createState() => new _ProfileScreenState(userProfile);
}

class _ProfileScreenState extends State<ProfileScreen> {
  static final facebookLogin = FacebookLogin();
  _ProfileScreenState(this.userProfile);
  final Profile userProfile;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Profile"),
        automaticallyImplyLeading: false,
      ),
      body: _body()
    );
  }
  _body() {
    return Center(
      child: Column (
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          _displayUserData(),
          SizedBox(height: 20,),
          _sepetator(),
          _logoutButton(),
          _sepetator(),
          _searchLocationButton(),
          _sepetator(),
          _nearByResturants(),
          _sepetator(),
        ],
      ),
    );
  }
  _sepetator() {
    return Divider(
      height: 1,
      indent: 30,
      endIndent: 30,
      color: Colors.grey,
    );
  }
  _displayUserData() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding (
          padding: EdgeInsets.all(20.0),
          child: Container (
            height: 200.0,
            width: 200.0,
            decoration: getProfileImage(),
          ),
        ),
        SizedBox(height: 28.0),
        Text(
          "${userProfile.name}",
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w600
          ),
        ),
        Text(
          "${userProfile.email}",
          style: TextStyle(
            fontSize: 16.0,
          ),
        ),
      ],
    );
  }
  BoxDecoration getProfileImage() {
    if(userProfile.url != null) {
      return BoxDecoration(
          color: Colors.grey[200],
          shape: BoxShape.circle,
          image: DecorationImage(
            fit: BoxFit.fill,
            image: NetworkImage(
              userProfile.url,
            ),
          )
      );
    }
  }
  _logoutButton() {

    return FlatButton(
        child: new Text(
            'Log out',
          style: TextStyle(
          decoration: TextDecoration.underline,
        ),
    ),
      onPressed: _logout,
        color: Colors.transparent,
    );
  }
  _searchLocationButton() {
    return FlatButton(
        child: new Text(
            'Find near by locations',
          style: TextStyle(
          decoration: TextDecoration.underline,
        ),
    ),
      onPressed: _nearby,
        color: Colors.transparent,
    );
  }
  _nearByResturants() {
    return FlatButton(
        child: new Text(
            'Near by Resturants',
            style: TextStyle(
              decoration: TextDecoration.underline,
            ),
        ),
        onPressed: _nearByResturantsPressed,
        color: Colors.transparent,
    );
  }
  void _logout() async {
    facebookLogin.logOut();
    DatabaseManager.instance.deleteUser(userProfile.id);
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }
  void _nearby() {
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Locations())
    );
  }
  void _nearByResturantsPressed() {
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => NearByResturants())
    );
  }
}