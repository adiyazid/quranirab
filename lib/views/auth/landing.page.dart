import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quranirab/provider/user.provider.dart';
import 'package:quranirab/views/quran.words.dart';
import 'package:quranirab/views/slice/slice2.dart';

import 'login.screen.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appUser = Provider.of<AppUser>(context);

    if (appUser.user != null) {
      print('Logged in');
      // return const DataFromFirestore();
      return const DummyPage();
    } else {
      print('Not logged in');
      return const SigninWidget();
    }
  }
}

class DummyPage extends StatelessWidget {
  const DummyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Slice2()));
                      },
                      child: const Text('Flutter Slice')),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Words()));
                      },
                      child: const Text('Alfatihah slice')),
                ]),
          )),
    );
  }
}
