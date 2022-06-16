import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_storage/get_storage.dart';
import 'package:quranirab/provider/ayah.number.provider.dart';
import 'package:quranirab/provider/bookmark.provider.dart';
import 'package:quranirab/provider/delete.provider.dart';
import 'package:quranirab/provider/language.provider.dart';
import 'package:quranirab/provider/user.provider.dart';
import 'package:quranirab/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quranirab/views/auth/landing.page.dart';
import 'framework/horizontal.scroll.web.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'framework/ms.language.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp(
    // Replace with actual values
    options: kIsWeb == true
        ? const FirebaseOptions(
            apiKey: "AIzaSyC8qmY0DC3tRKcyV0r8YXmymr-c1y78r0Y",
            authDomain: "quranirab-74bba.firebaseapp.com",
            projectId: "quranirab-74bba",
            storageBucket: "quranirab-74bba.appspot.com",
            messagingSenderId: "422246535912",
            appId: "1:422246535912:web:b9fb40db672516fa2cef5d",
            measurementId: "G-GF36EVS4JQ")
        : null,
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = Locale('en');

  void setLocale(Locale value) {
    setState(() {
      _locale = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final appUser = AppUser();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppUser>.value(value: appUser),
        ChangeNotifierProvider<AyaProvider>(create: (context) => AyaProvider()),
        ChangeNotifierProvider<LangProvider>(
            create: (context) => LangProvider()),
        ChangeNotifierProvider<BookMarkProvider>(
            create: (context) => BookMarkProvider()),
        ChangeNotifierProvider<DeleteProvider>(
            create: (context) => DeleteProvider())
      ],

      child: ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
          builder: (context, _) {
            final themeProvider =
                Provider.of<ThemeProvider>(context, listen: true);
            return MaterialApp(
              title: "QuranIrab Web App",
              scrollBehavior: MyCustomScrollBehavior(),
              home: LandingPage(),
              locale: _locale,
              themeMode: themeProvider.themeMode,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
                MsMaterialLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale('ms', 'MY'),
                Locale('en', ''),
                Locale('ar', ''),
              ],
              theme: QuranThemes.lightTheme,
              darkTheme: QuranThemes.darkTheme,
              debugShowCheckedModeBanner: false,
            );
          }),
    );
  }
}
