import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:plantavor/services/shared_pref.dart';
import 'package:plantavor/services/user_log_in.dart';
// import 'package:haruka1_0/app/data/models/user_logged_in.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefService {
  static Future<void> setNewName(String name) async {
    final pref = await SharedPreferences.getInstance();

    final loggedInUser = await getLoggedInUserData();

    loggedInUser.name = name;

    pref.setString('loggedUser', jsonEncode(loggedInUser.toMap()));
  }

  static Future<void> setNewPassword(String password) async {
    final pref = await SharedPreferences.getInstance();

    final loggedInUser = await getLoggedInUserData();

    loggedInUser.password = password;

    pref.setString('loggedUser', jsonEncode(loggedInUser.toMap()));
    debugPrint(jsonEncode(loggedInUser.toMap()));
  }

  static Future<UserLoggedIn> getLoggedInUserData() async {
    final pref = await SharedPreferences.getInstance();

    String userPref = pref.getString('loggedUser')!;

    Map<String, dynamic> userMap = jsonDecode(userPref);
    return UserLoggedIn.fromMap(userMap);
  }

  static void saveLoggedInUserData(Map<String, dynamic> userLoggedIn) async {
    final pref = await SharedPreferences.getInstance();

    pref.setString('loggedUser', jsonEncode(userLoggedIn));
  }
}
