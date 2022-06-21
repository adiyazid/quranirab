import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:multiquranirab/Routes/route.dart';
import 'package:multiquranirab/providers/db.list.providers.dart';
import 'package:multiquranirab/providers/user.provider.dart';
import 'package:multiquranirab/theme/theme_provider.dart';
import 'package:provider/provider.dart';

import 'Routes/onGenerateRoute.dart';
import 'auth/landing.page.dart';
import 'firebase_options.dart';
import 'framework/horizontal.scroll.web.dart';
import 'framework/ms.language.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
          ChangeNotifierProvider<ThemeProvider>(
              create: (context) => ThemeProvider()),
          ChangeNotifierProvider<DbListProvider>(
              create: (context) => DbListProvider())
        ],
        child: AdaptiveTheme(
          light: ThemeData(
            // brightness: Brightness.light,
            colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.red)
                .copyWith(secondary: Colors.amber),
          ),
          dark: ThemeData(
            // brightness: Brightness.dark,
            colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.red)
                .copyWith(secondary: Colors.amber),
          ),
          initial: AdaptiveThemeMode.light,
          builder: (theme, darkTheme) => MaterialApp(
            title: "QuranIrab Web App",
            scrollBehavior: MyCustomScrollBehavior(),
            home: const LandingPage(),
            locale: _locale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              MsMaterialLocalizations.delegate,
            ],
            initialRoute: RoutesName.landingPage,
            onGenerateRoute: RouteGenerator.generateRoute,
            supportedLocales: const [
              Locale('ms', 'MY'),
              Locale('en', ''),
              Locale('ar', ''),
            ],
            themeMode: ThemeMode.light,
            theme: theme,
            darkTheme: darkTheme,
            debugShowCheckedModeBanner: false,
          ),
        ));
  }
}
