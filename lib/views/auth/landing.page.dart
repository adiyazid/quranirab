import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quranirab/facebook/screens/home_screen.dart';
import 'package:quranirab/provider/user.provider.dart';
import 'package:quranirab/quiz_module/Quiz.Home.dart';
import 'package:quranirab/views/auth/login.dart';
import 'package:quranirab/views/data.from.firestore.dart';
import 'package:quranirab/views/home.page.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appUser = Provider.of<AppUser>(context);

    if (appUser.user != null) {
      print('Logged in');
      return const DataFromFirestore();
    } else {
      print('Not logged in');
      return LoginPage();
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
                                builder: (context) =>
                                    const FacebookHomeScreen()));
                      },
                      child: const Text('Surah screen')),
                  const SizedBox(
                    height: 8,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LandingPage()));
                      },
                      child: const Text('Firebase integration')),
                  const SizedBox(
                    height: 8,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const FacebookHomeScreen()));
                      },
                      child: const Text('Facebook template')),
                  const SizedBox(
                    height: 8,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomePage()));
                      },
                      child: const Text('Home')),
                  const SizedBox(
                    height: 8,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const QuizHome()));
                      },
                      child: const Text('Quiz')),
                ]),
          )),
    );
  }
}
