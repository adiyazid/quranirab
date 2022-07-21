import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:quranirab/provider/ayah.number.provider.dart';
import 'package:quranirab/provider/bookmark.provider.dart';
import 'package:quranirab/provider/delete.provider.dart';
import 'package:quranirab/provider/language.provider.dart';
import 'package:quranirab/provider/user.provider.dart';
import 'package:quranirab/theme/theme_provider.dart';
import 'package:quranirab/views/auth/landing.page.dart';

import 'firebase_options.dart';
import 'framework/horizontal.scroll.web.dart';
import 'framework/ms.language.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
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
        ChangeNotifierProvider<AppUser>(
          create: (context) => AppUser(),
        ),
        ChangeNotifierProvider<AyaProvider>(create: (context) => AyaProvider()),
        ChangeNotifierProvider<LangProvider>(
            create: (context) => LangProvider()),
        ChangeNotifierProvider<BookMarkProvider>(
            create: (context) => BookMarkProvider()),
        ChangeNotifierProvider<DeleteProvider>(
            create: (context) => DeleteProvider()),
        ChangeNotifierProvider<ThemeProvider>(
            create: (context) => ThemeProvider())
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
