import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceManager {

  final key_userId = 'user_id';


  SharedPreferenceManager._privateConstructor();
  static final SharedPreferenceManager instance = SharedPreferenceManager._privateConstructor();


  saveUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key_userId, userId);
    print('saved $key_userId');
  }

  Future<String> getUserId() async {

    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key_userId);
  }
}