import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quranirab/provider/user.provider.dart';
import 'package:quranirab/quiz_module/quiz.home.dart';

import '../data.from.firestore.dart';
import '../home.page.dart';
import 'login.screen.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appUser = Provider.of<AppUser>(context);

    if (appUser.user != null) {
      print('Logged in');
      return const QuizHome(1);
      // return const DummyPage();
    } else {
      print('Not logged in');
      return const SigninWidget();
    }
  }
}
