import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../data/reader.dart';

class UserStore {
  static const String _USER_LOGGED_IN = "user_logged_in";
  static const String _USER_DETAIL = "user_detail";
  static const String _USER_PROFILE = "user_profile";
  static const String _USER_Id = "user_id";
  static const String _AUTH_TOKEN = "auth_token";

  static Future<String?> getAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_AUTH_TOKEN);
  }

  static setAuthToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_AUTH_TOKEN, token);
  }

  static Future<String> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_USER_Id) ?? "";
  }

  static setUserId(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_USER_Id, userId);
  }

  static setUserLoggedIn(bool isUserLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(_USER_LOGGED_IN, isUserLoggedIn);
  }

  static isUserLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_USER_LOGGED_IN) ?? false;
  }

  static saveUser(Reader user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_USER_DETAIL, jsonEncode(user));
  }

  static saveUserProfileIcon(String icon) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_USER_PROFILE, icon);
  }

  static Future<String?> getUserProfileIcon() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_USER_PROFILE);
  }

  static Future<Reader?> getUserDetail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString(_USER_DETAIL);
    if (userString != null) {
      Map<String, dynamic> userMap =
          jsonDecode(userString) as Map<String, dynamic>;
      return Reader.fromJson(userMap);
    }
    return null;
  }

  static Future<void> clearUserDetail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_USER_LOGGED_IN);
    await prefs.remove(_USER_DETAIL);
    await prefs.remove(_USER_PROFILE);
    await prefs.remove(_USER_Id);
    await prefs.remove(_AUTH_TOKEN);
  }
}
