import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quranirab/models/category.dart';
import 'package:quranirab/provider/user.provider.dart';
import 'package:quranirab/quiz_module/LeaderBoard.Table.dart';
import 'package:quranirab/theme/theme_provider.dart';
import 'package:quranirab/widget/LanguagePopup.dart';
import 'package:quranirab/widget/setting.popup.dart';
import 'package:quranirab/widget/menu.dart';

class LeaderBoardMenu extends StatefulWidget {
  const LeaderBoardMenu({Key? key}) : super(key: key);

  @override
  State<LeaderBoardMenu> createState() => _LeaderBoardMenuState();
}

class _LeaderBoardMenuState extends State<LeaderBoardMenu> {
  int diff = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      drawer: const Menu(),
      body: NestedScrollView(
        physics: const NeverScrollableScrollPhysics(),
        headerSliverBuilder: (context, value) {
          return [
            SliverAppBar(
              iconTheme: Theme.of(context).iconTheme,
              leading: IconButton(
                icon: const Icon(
                  Icons.menu,
                ),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              title: const CircleAvatar(
                backgroundImage: AssetImage('assets/quranirab.png'),
                radius: 18.0,
              ),
              centerTitle: false,
              floating: true,
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.search,
                        size: 26.0,
                      )),
                ),
                const Padding(
                    padding: EdgeInsets.only(right: 20.0), child: LangPopup()),
                const Padding(
                    padding: EdgeInsets.only(right: 20.0),
                    child: SettingPopup()),
              ],
            ),
          ];
        },
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                      width: 2.0,
                      color: themeProvider.isDarkMode
                          ? Colors.white
                          : const Color(0xffE86F00)),
                ),
                color: themeProvider.isDarkMode
                    ? const Color(0xff808BA1)
                    : const Color.fromRGBO(255, 237, 173, 1)),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Align(
                    alignment: Alignment.topCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        themeProvider.isDarkMode
                            ? Image.asset(
                                'assets/Image2.png',
                                scale: 2.5,
                              )
                            : Image.asset(
                                'assets/Image1.png',
                                scale: 2.5,
                              ),
                        const SizedBox(width: 32),
                        Text(
                          'Leaderboards',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: themeProvider.isDarkMode
                                  ? Colors.white
                                  : const Color.fromRGBO(0, 0, 0, 1),
                              fontFamily: 'Source Serif Pro',
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.05,
                              letterSpacing:
                                  0 /*percentages not used in flutter. defaulting to zero*/,
                              fontWeight: FontWeight.normal,
                              height: 1),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      setState(() {
                        catData.category = 'overall';
                      });
                      await calcOverallScore();
                      await Future.delayed(const Duration(seconds: 2), () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const LeaderBoardTable()));
                      });
                    },
                    child: Container(
                      width: 600,
                      height: MediaQuery.of(context).size.height * 0.15,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                        color: themeProvider.isDarkMode
                            ? const Color(0xffD2D6DA)
                            : const Color.fromRGBO(255, 250, 208, 1),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Image.asset(
                              'assets/Image7.png',
                              scale: 4,
                            ),
                            Spacer(),
                            Text(
                              'Overall',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Color.fromRGBO(0, 0, 0, 1),
                                  fontFamily: 'Source Serif Pro',
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.03,
                                  letterSpacing:
                                      0 /*percentages not used in flutter. defaulting to zero*/,
                                  fontWeight: FontWeight.normal,
                                  height: 1),
                            ),
                            Spacer(),
                          ],
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      setState(() {
                        catData.category = 'categoryU201';
                      });
                      await calcCategory1();
                      await Future.delayed(const Duration(seconds: 2), () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const LeaderBoardTable()));
                      });
                    },
                    child: Container(
                      width: 600,
                      height: MediaQuery.of(context).size.height * 0.15,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                        color: themeProvider.isDarkMode
                            ? const Color(0xffD2D6DA)
                            : const Color.fromRGBO(255, 250, 208, 1),
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Image.asset(
                                'assets/Image7.png',
                                scale: 4,
                              ),
                              Spacer(),
                              Text(
                                'Page 1 - 201',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Color.fromRGBO(0, 0, 0, 1),
                                    fontFamily: 'Source Serif Pro',
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.03,
                                    letterSpacing:
                                        0 /*percentages not used in flutter. defaulting to zero*/,
                                    fontWeight: FontWeight.normal,
                                    height: 1),
                              ),
                              Spacer(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      setState(() {
                        catData.category = 'categoryU402';
                      });
                      await calcCategory2();
                      await Future.delayed(const Duration(seconds: 2), () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const LeaderBoardTable()));
                      });
                    },
                    child: Container(
                      width: 600,
                      height: MediaQuery.of(context).size.height * 0.15,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                        color: themeProvider.isDarkMode
                            ? const Color(0xffD2D6DA)
                            : const Color.fromRGBO(255, 250, 208, 1),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 30.0),
                              child: Image.asset(
                                'assets/Image7.png',
                                scale: 4,
                              ),
                            ),
                            Spacer(),
                            Text(
                              'Page 202 - 402',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Color.fromRGBO(0, 0, 0, 1),
                                  fontFamily: 'Source Serif Pro',
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.03,
                                  letterSpacing:
                                      0 /*percentages not used in flutter. defaulting to zero*/,
                                  fontWeight: FontWeight.normal,
                                  height: 1),
                            ),
                            Spacer(),
                          ],
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      setState(() {
                        catData.category = 'categoryU604';
                      });
                      await calcCategory3();
                      await Future.delayed(const Duration(seconds: 2), () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const LeaderBoardTable()));
                      });
                    },
                    child: Container(
                      width: 600,
                      height: MediaQuery.of(context).size.height * 0.15,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                        color: themeProvider.isDarkMode
                            ? const Color(0xffD2D6DA)
                            : const Color.fromRGBO(255, 250, 208, 1),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 30.0),
                              child: Image.asset(
                                'assets/Image7.png',
                                scale: 4,
                              ),
                            ),
                            Spacer(),
                            Text(
                              'Page 403 - 604',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Color.fromRGBO(0, 0, 0, 1),
                                  fontFamily: 'Source Serif Pro',
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.03,
                                  letterSpacing:
                                      0 /*percentages not used in flutter. defaulting to zero*/,
                                  fontWeight: FontWeight.normal,
                                  height: 1),
                            ),
                            Spacer(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ])),
      ),
    );
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
}
