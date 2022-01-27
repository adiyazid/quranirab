import 'package:flutter/material.dart';
import 'package:quranirab/facebook/screens/Appbar/appbar.dart';
import 'package:quranirab/quiz_module/LeaderBoard.Menu.dart';
import 'package:quranirab/quiz_module/quiz.dart';
import 'package:quranirab/widget/menu.dart';
import 'package:quranirab/widget/setting.dart';

class QuizHome extends StatefulWidget {
  const QuizHome({Key? key}) : super(key: key);

  @override
  _QuizHomeState createState() => _QuizHomeState();
}

class _QuizHomeState extends State<QuizHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Menu(),
      endDrawer: const Setting(),
      body: DefaultTabController(
        length: 3,
        child: Stack(
          children: [
            const SizedBox(
              height: 115,
              child: CustomScrollView(
                slivers: [Appbar()],
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Quiz()));
                  },
                  child: const Text('LeaderBoard')),
            )
          ],
        ),
      ),
    );
  }
}
//