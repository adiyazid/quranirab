import 'dart:math';

import 'package:flutter/material.dart';
import 'package:quranirab/facebook/screens/home_screen.dart';
import 'package:quranirab/quiz_module/Quiz.Home.dart';
import 'package:quranirab/widget/menu.dart';
import 'package:quranirab/widget/setting.dart';
import 'package:quranirab/facebook/screens/Appbar/appbar.dart';
import 'package:quranirab/quiz_module/utils/button182.dart';
import 'package:quranirab/quiz_module/LeaderBoard.Menu.dart';
import 'package:quranirab/quiz_module/quiz_list.dart';

class QuizScore extends StatefulWidget {
  QuizScore(this.score, {Key? key}) : super(key: key);
  int score;

  @override
  _QuizScoreState createState() => _QuizScoreState();
}

class _QuizScoreState extends State<QuizScore> {
  var windowWidth;
  var windowHeight;
  double windowSize = 0;

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    windowSize = min(windowWidth, windowHeight);

    return Scaffold(
        backgroundColor: Colors.white12,
        drawer: const Menu(),
        endDrawer: const Setting(),
        body: DefaultTabController(
          length: 3,
          child: Stack(
            children:  [
              const SizedBox(
                height: 115,
                child: CustomScrollView(
                  slivers: [Appbar()],
                ),
              ),
              Align(
                  alignment: Alignment.center,
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
                      child: Container(
                        color: const Color(0xfffff5ec),
                        width: MediaQuery.of(context).size.width/1.4,
                        height: MediaQuery.of(context).size.height/1.4,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 50,
                            ),
                            const Text(
                              "Your Score",
                              style: TextStyle(
                                  fontSize: 34, fontWeight: FontWeight.w800,
                                  color: Colors.black
                              ),
                            ),
                            const SizedBox(
                              height: 50,
                            ),
                            Text(
                              "${widget.score}""/" "${questions.length}",
                              style: const TextStyle(
                                  fontSize: 34, fontWeight: FontWeight.w800,
                                  color: Colors.black
                              ),
                            ),
                            const SizedBox(
                              height: 50,
                            ),
                            Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  button182('Play Again', const TextStyle(fontSize: 28), const Color(0xffffb55f),
                                      10, () {
                                         Navigator.push(
                                         context,
                                         MaterialPageRoute(
                                          builder: (context) => const QuizHome()));
                                      }, true), //insert route to play again at quiz screen
                                  const SizedBox(width:10,),
                                  button182('Back to Page', const TextStyle(fontSize: 28), const Color(0xffffb55f),
                                      10, () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => const FacebookHomeScreen()));
                                      }, true), //insert route to return to back to surah page
                                  const SizedBox(width:10,),
                                  button182('Leaderboard', const TextStyle(fontSize: 28), const Color(0xffffb55f),
                                      10, () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => const LeaderBoardMenu()));
                                      }, true), //insert route to leaderboard
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                  )
              )
            ],
          ),

        )
    );
  }
}
//

