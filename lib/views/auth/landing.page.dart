import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quranirab/provider/ayah.number.provider.dart';
import 'package:quranirab/provider/user.provider.dart';

import '../home.page.dart';
import 'login.screen.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<AyaProvider>(context,listen: false).getScreenSize(context);
    Provider.of<AyaProvider>(context,listen: false).getFontSize(context);
    return Consumer<AppUser>(builder: (context, user, child) {
      if (user.user != null) {
        return const HomePage();
      }
      return SigninWidget();
    });
  }
}
