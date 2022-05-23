import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quranirab/quiz_module/quiz.home.dart';
import 'package:quranirab/theme/theme_provider.dart';
import 'package:quranirab/widget/appbar.widget.dart';
import 'package:quranirab/widget/menu.dart';
import 'package:quranirab/widget/setting.dart';
import 'package:quranirab/quiz_module/utils/button182.dart';
import 'package:quranirab/quiz_module/LeaderBoard.Menu.dart';

import '../provider/user.provider.dart';

class QuizScore extends StatefulWidget {
  final int score;
  final int questionsCount;
  final int page;

  const QuizScore(this.score, this.questionsCount, this.page, {Key? key})
      : super(key: key);

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
    var themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
        backgroundColor:
            themeProvider.isDarkMode ? Color(0xff666666) : Colors.white,
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
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 40),
                      child: Container(
                        color: const Color(0xfffff5ec),
                        width: MediaQuery.of(context).size.width / 1.4,
                        height: MediaQuery.of(context).size.height / 1.4,
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
                                  fontSize: 34,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.black),
                            ),
                            const SizedBox(
                              height: 50,
                            ),
                            AutoSizeText(
                              "${widget.score}" " / " +
                                  '${widget.questionsCount}',
                              //"${questions.length}",
                              style: const TextStyle(
                                  fontSize: 34,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.black),
                            ),
                            const SizedBox(
                              height: 50,
                            ),
                            Center(
                              child: Wrap(
                                alignment: WrapAlignment.center,
                                runSpacing: 10,
                                children: [
                                  button182(
                                      'Play Again',
                                      const TextStyle(fontSize: 28),
                                      const Color(0xffffb55f),
                                      10, () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                QuizHome(widget.page)));
                                  }, true),
                                  //insert route to play again at quiz screen
                                  const SizedBox(
                                    width: 10,
                                    height: 10,
                                  ),
                                  button182(
                                      'Back to Page',
                                      const TextStyle(fontSize: 28),
                                      const Color(0xffffb55f),
                                      10, () {
                                    Navigator.pop(context);
                                  }, true),
                                  //insert route to return to back to surah page
                                  const SizedBox(
                                    width: 10,
                                    height: 10,
                                  ),
                                  button182(
                                      'Leaderboard',
                                      const TextStyle(fontSize: 28),
                                      const Color(0xffffb55f),
                                      10, () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const LeaderBoardMenu()));
                                  }, true),
                                  const SizedBox(
                                    width: 10,
                                    height: 10,
                                  ),
                                  //insert route to leaderboard
                                ],
                              ),
                            )
                          ],
                        ),
                      )))
            ],
          ),
        ));
  }

  Future<void> calcOverallScore() async {
    int overall = 0;
    int num = 0;
    int newOverall = 0;
    int newNum = 0;
    await FirebaseFirestore.instance
        .collection('quranIrabUsers')
        .doc(AppUser.instance.user!.uid)
        .collection('quizs')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        var now = DateTime.now();
        var time = DateTime.parse(doc['date-taken'].toDate().toString());
        int score = doc['score'];
        setState(() {
          var diff = now.difference(time).inDays;
          if (diff > 30) {
            overall = overall + score;
            num = num + 1;
          } else {
            newOverall = newOverall + score;
            newNum = newNum + 1;
          }
        });
      }
      if (newNum != 0 || num != 0) {
        addToFirebase(newOverall, newNum, overall, num, 'overall');
      }
    });
  }

  Future<void> calcCategory1() async {
    int overall = 0;
    int num = 0;
    int newOverall = 0;
    int newNum = 0;
    await FirebaseFirestore.instance
        .collection('quranIrabUsers')
        .doc(AppUser.instance.user!.uid)
        .collection('quizs')
        .where('medina_mushaf_page_id', isLessThanOrEqualTo: 201)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if (doc['medina_mushaf_page_id'] > 0) {
          var now = DateTime.now();
          var time = DateTime.parse(doc['date-taken'].toDate().toString());
          int score = doc['score'];
          setState(() {
            var diff = now.difference(time).inDays;
            if (diff > 30) {
              overall = overall + score;
              num = num + 1;
            } else {
              newOverall = newOverall + score;
              newNum = newNum + 1;
            }
          });
        }
      }
    });
    if (newNum != 0 || num != 0) {
      addToFirebase(newOverall, newNum, overall, num, 'categoryU201');
    }
  }

  Future<void> calcCategory2() async {
    int overall = 0;
    int num = 0;
    int newOverall = 0;
    int newNum = 0;
    await FirebaseFirestore.instance
        .collection('quranIrabUsers')
        .doc(AppUser.instance.user!.uid)
        .collection('quizs')
        .where('medina_mushaf_page_id', isLessThanOrEqualTo: 402)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if (doc['medina_mushaf_page_id'] > 201) {
          var now = DateTime.now();
          var time = DateTime.parse(doc['date-taken'].toDate().toString());
          int score = doc['score'];
          setState(() {
            var diff = now.difference(time).inDays;
            if (diff > 30) {
              overall = overall + score;
              num = num + 1;
            } else {
              newOverall = newOverall + score;
              newNum = newNum + 1;
            }
          });
        }
      }
    });
    if (newNum != 0 || num != 0) {
      addToFirebase(newOverall, newNum, overall, num, 'categoryU402');
    }
  }

  Future<void> calcCategory3() async {
    int overall = 0;
    int num = 0;
    int newOverall = 0;
    int newNum = 0;
    await FirebaseFirestore.instance
        .collection('quranIrabUsers')
        .doc(AppUser.instance.user!.uid)
        .collection('quizs')
        .where('medina_mushaf_page_id', isLessThanOrEqualTo: 604)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if (doc['medina_mushaf_page_id'] > 402) {
          var now = DateTime.now();
          var time = DateTime.parse(doc['date-taken'].toDate().toString());
          int score = doc['score'];
          setState(() {
            var diff = now.difference(time).inDays;
            if (diff > 30) {
              overall = overall + score;
              num = num + 1;
            } else {
              newOverall = newOverall + score;
              newNum = newNum + 1;
            }
          });
        }
      }
    });
    if (newNum != 0 || num != 0) {
      addToFirebase(newOverall, newNum, overall, num, 'categoryU604');
    }
  }

  Future<void> addToFirebase(
      int newOverAll, int newNum, int overAll, int num, String category) async {
    await FirebaseFirestore.instance
        .collection('leaderboards')
        .doc(category)
        .collection('scores')
        .doc(AppUser.instance.user!.uid)
        .set(
      {
        'name': AppUser.instance.user!.displayName, // John Doe
        'scores': newOverAll,
        'total-quiz': newNum,
        'last-updated': DateTime.now()
      },
      SetOptions(merge: true),
    );
    await FirebaseFirestore.instance
        .collection('leaderboards')
        .doc(category)
        .collection('oldScores')
        .doc(AppUser.instance.user!.uid)
        .set(
      {
        'name': AppUser.instance.user!.displayName, // John Doe
        'scores': overAll + newOverAll,
        'total-quiz': num + newNum,
        'last-updated': DateTime.now()
      },
      SetOptions(merge: true),
    );
  }
}
