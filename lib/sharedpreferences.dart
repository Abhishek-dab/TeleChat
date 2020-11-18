import 'package:shared_preferences/shared_preferences.dart';

class HelperFunction {
  static String sharedPreferenceKeyLogin = "ABCD";
  static String sharedPreferenceKeyName = "ZXCV";
  static String sharedPreferenceKeyMail = "KOLK";

  static Future<bool> saveUserLoginSharedPreference(bool isUserLoggedIn) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setBool(sharedPreferenceKeyLogin, isUserLoggedIn);
  }

  static Future<bool> saveUserName(String userName) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(sharedPreferenceKeyName, userName);
  }

  static Future<bool> saveUserMail(String userMail) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(sharedPreferenceKeyMail, userMail);
  }

  static Future<bool> getUserLoginSharedPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.getBool(sharedPreferenceKeyLogin);
  }

  static Future<String> getUserName() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.getString(sharedPreferenceKeyName);
  }

  static Future<String> getUserMail() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.getString(sharedPreferenceKeyMail);
  }
}
