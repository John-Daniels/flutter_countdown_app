import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

ThemeMode? themeMode;

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: AppBarTheme(
      // elevation: 2,
      backgroundColor: Colors.blue,
      iconTheme: IconThemeData(
        color: Colors.black,
      )),
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: Color(0xff15161a),
  appBarTheme: AppBarTheme(
    elevation: 0,
    backgroundColor: Color(0xff15161a),
  ),
);

Future<bool> saveTheme(String theme) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  bool result = await sharedPreferences.setString("theme", theme);

  return result;
}

Future<String?> getTheme() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String? currentTheme = sharedPreferences.getString("theme");
  return currentTheme;
}

void toggleTheme() async {
  if (themeMode == ThemeMode.light) {
    // themeMode = ThemeMode.dark;
    await saveTheme("dark");
  } else {
    // themeMode = ThemeMode.light;
    await saveTheme("light");
  }
}
