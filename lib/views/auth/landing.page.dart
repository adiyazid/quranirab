import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quranirab/provider/user.provider.dart';

import '../data.from.firestore.dart';
import '../home.page.dart';
import 'login.screen.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AppUser>(builder: (context, user, child) {
      if (user.user != null) {
        return const HomePage();
      }
      return SigninWidget();
    });
  }
}
