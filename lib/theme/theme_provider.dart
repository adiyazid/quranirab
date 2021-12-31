import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.system;

  bool get isDarkMode {
    if (themeMode == ThemeMode.system) {
      final brightness = SchedulerBinding.instance!.window.platformBrightness;
      return brightness == Brightness.dark;
    } else {
      return themeMode == ThemeMode.dark;
    }
  }

  void toggleTheme(bool isOn) {
    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class QuranThemes {
  static final darkTheme = ThemeData(
    textTheme: const TextTheme(
      headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
      headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
      bodyText2: TextStyle(fontSize: 20.0),
    ),
    indicatorColor: Colors.orange,
    primarySwatch: Colors.orange,
    bottomAppBarColor: Colors.orange,
    dividerColor: Colors.orange,
    cardColor: Colors.orange,
    canvasColor: Colors.orange,
    focusColor: Colors.orange,
    scaffoldBackgroundColor: const Color(0xFF666666),
    primaryColor: const Color(0xFFD2D6DA),
    iconTheme: const IconThemeData(color: Colors.white),
    textSelectionTheme:
        const TextSelectionThemeData(cursorColor: Colors.orange),
    colorScheme: const ColorScheme.dark(),
  );
  static final lightTheme = ThemeData(
    canvasColor: Colors.orange,
    focusColor: Colors.orange,
    scaffoldBackgroundColor: Colors.white,
    primaryColor: Colors.white,
    colorScheme: const ColorScheme.light(),
    iconTheme: const IconThemeData(color: Colors.black),
    indicatorColor: Colors.orange,
    primarySwatch: Colors.orange,
    bottomAppBarColor: Colors.orange,
    dividerColor: Colors.orange,
    cardColor: Colors.orange,
    textSelectionTheme:
        const TextSelectionThemeData(cursorColor: Colors.orange),
  );
}
