import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quranirab/provider/user.provider.dart';
import 'package:quranirab/views/auth/login.screen.dart';
import 'package:quranirab/views/home.page.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    var user = Provider.of<AppUser>(context).user;
    if (user != null) {
      return HomePage();
    } else {
      return SigninWidget();
    }
  }
}
