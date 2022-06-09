import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get_storage/get_storage.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode? themeMode;
  var box = GetStorage();

  ThemeProvider() {
    getLocal();
  }

  bool get isDarkMode {
    if (themeMode == ThemeMode.system) {
      final brightness = SchedulerBinding.instance.window.platformBrightness;
      return brightness == Brightness.dark;
    } else {
      return themeMode == ThemeMode.dark;
    }
  }

  Future<void> toggleTheme(bool isOn) async {
    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    await box.write('dark', isOn);
    notifyListeners();
  }

  Future<void> getLocal() async {
    var bool = await box.read('dark');
    if (bool == null) {
      themeMode = ThemeMode.system;
    } else {
      if (!bool) themeMode = ThemeMode.light;
      if (bool) themeMode = ThemeMode.dark;
    }
    notifyListeners();
  }
}

class QuranThemes {
  static final darkTheme = ThemeData(
    primaryColorDark: Colors.grey,
    primaryColorLight: Colors.orangeAccent,
    //text color  white black
    indicatorColor: Colors.orange,
    primarySwatch: Colors.orange,
    bottomAppBarColor: Colors.orange,
    dividerColor: const Color(0xFFD2D6DA),
    // stroke color = white orange
    cardColor: Colors.orange,
    canvasColor: Colors.orange,
    focusColor: const Color(0xFF808BA1),
    secondaryHeaderColor: const Color(0xFFD2D6DA),
    //white(d2d6da) black color
    scaffoldBackgroundColor: const Color(0xFF666666),
    primaryColor: const Color(0xFF67748E),
    //blue 6778e combo , peach
    iconTheme: const IconThemeData(color: Colors.white),
    // icon color white and orange
    // textSelectionTheme:
    // const TextSelectionThemeData(cursorColor: Colors.orange),
    colorScheme: const ColorScheme.dark(),
    textSelectionTheme: TextSelectionThemeData(selectionColor: Colors.white),
  );
  static final lightTheme = ThemeData(
    primaryColorDark: Colors.grey,
    primaryColorLight: Colors.orangeAccent,
    canvasColor: Colors.orange,
    focusColor: Colors.white,
    secondaryHeaderColor: Colors.black,
    scaffoldBackgroundColor: Colors.white,
    primaryColor: const Color(0xFFFFC896),
    colorScheme: ColorScheme.light(),
    iconTheme: const IconThemeData(color: Color(0xFFE86F00)),
    indicatorColor: Colors.orange,
    primarySwatch: Colors.orange,
    bottomAppBarColor: Colors.orange,
    dividerColor: const Color(0xFFE86F00),
    cardColor: Colors.orange,
    textSelectionTheme: TextSelectionThemeData(selectionColor: Colors.black),
    // textSelectionTheme:
    // const TextSelectionThemeData(cursorColor: Colors.orange),
  );
}
