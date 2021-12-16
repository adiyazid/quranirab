import 'package:firebase_core/firebase_core.dart';
import 'package:quranirab/themes/app_theme.dart';
import 'package:quranirab/themes/theme_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quranirab/views/quran.home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(ChangeNotifierProvider(
      create: (_) => ThemeModel(),
      child: Consumer<ThemeModel>(
          builder: (context, ThemeModel themeNotifier, child) {
            return MaterialApp(
              home: const QuranHome(),
              theme: themeNotifier.isDark ? AppTheme.dark : AppTheme.light,
              debugShowCheckedModeBanner: false,
            );
          })));
}
