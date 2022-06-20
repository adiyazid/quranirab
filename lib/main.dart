import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:multiquranirab/theme/theme_provider.dart';
import 'package:multiquranirab/user.provider.dart';
import 'package:provider/provider.dart';

import 'Routes/onGenerateRoute.dart';
import 'auth/landing.page.dart';
import 'firebase_options.dart';
import 'framework/horizontal.scroll.web.dart';
import 'framework/ms.language.dart';

Future<void> main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('en');

  void setLocale(Locale value) {
    setState(() {
      _locale = value;
    });
  }

  final appUser = AppUser();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppUser>.value(value: appUser),
        ChangeNotifierProvider<AppUser>(
          create: (context) => AppUser(),
        ),
      ],
      child: ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
          builder: (context, _) {
            final themeProvider =
                Provider.of<ThemeProvider>(context, listen: true);
            return MaterialApp(
              title: "QuranIrab Web App",
              scrollBehavior: MyCustomScrollBehavior(),
              home: const LandingPage(),
              locale: _locale,
              themeMode: themeProvider.themeMode,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
                MsMaterialLocalizations.delegate,
              ],
              onGenerateRoute: RouteGenerator.generateRoute,
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
