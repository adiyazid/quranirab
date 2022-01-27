import 'package:firebase_core/firebase_core.dart';
import 'package:quranirab/provider/user.provider.dart';
import 'package:quranirab/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quranirab/views/auth/landing.page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    // Replace with actual values
    options: const FirebaseOptions(
        apiKey: "AIzaSyC8qmY0DC3tRKcyV0r8YXmymr-c1y78r0Y",
        authDomain: "quranirab-74bba.firebaseapp.com",
        projectId: "quranirab-74bba",
        storageBucket: "quranirab-74bba.appspot.com",
        messagingSenderId: "422246535912",
        appId: "1:422246535912:web:b9fb40db672516fa2cef5d",
        measurementId: "G-GF36EVS4JQ"),
  );
  final appUser = AppUser();
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider<AppUser>.value(value: appUser),
      ],
      child: ChangeNotifierProvider(
          create: (context) => FontSizeController(),
          builder: (context, _) {
            return ChangeNotifierProvider(
                create: (context) => ThemeProvider(),
                builder: (context, _) {
                  final themeProvider =
                      Provider.of<ThemeProvider>(context, listen: true);
                  return MaterialApp(
                    home: const DummyPage(),
                    themeMode: themeProvider.themeMode,
                    theme: QuranThemes.lightTheme,
                    darkTheme: QuranThemes.darkTheme,
                    debugShowCheckedModeBanner: false,
                  );
                });
          })));
}
