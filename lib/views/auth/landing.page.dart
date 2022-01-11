import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quranirab/facebook/screens/home_screen.dart';
import 'package:quranirab/provider/user.provider.dart';
import 'package:quranirab/views/auth/login.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appUser = Provider.of<AppUser>(context);

    if (appUser.user != null) {
      print('Logged in');
      return const FacebookHomeScreen();
    } else {
      print('Not logged in');
      return LoginPage();
    }
  }
}
