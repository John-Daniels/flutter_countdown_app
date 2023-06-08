import 'package:countdown_app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'views/countdown-page.dart';

void main() async {
  // themeMode = currentTheme == 'light' ? ThemeMode.light : ThemeMode.dark;

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode themeMode =
      getTheme() == 'light' ? ThemeMode.light : ThemeMode.dark;

  void toggleTheme() async {
    if (themeMode == ThemeMode.light) {
      themeMode = ThemeMode.dark;
      await saveTheme("dark");
    } else {
      themeMode = ThemeMode.light;
      await saveTheme("light");
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Countdown app',
      themeMode: themeMode,
      theme: lightTheme,
      darkTheme: darkTheme,
      home: CountdownPage(onThemeChanged: () {
        toggleTheme();
      }),
    );
  }
}
