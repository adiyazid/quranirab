import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    calcOverallScore();
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
                              fontSize: 72,
                              letterSpacing:
                                  0 /*percentages not used in flutter. defaulting to zero*/,
                              fontWeight: FontWeight.normal,
                              height: 1),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LeaderBoardTable()));
                    },
                    child: Container(
                      width: 600,
                      height: 130,
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
                          children: [
                            Image.asset(
                              'assets/Image7.png',
                              scale: 4,
                            ),
                            const SizedBox(
                              width: 104,
                            ),
                            const Flexible(
                              child: Text(
                                'Overall',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Color.fromRGBO(0, 0, 0, 1),
                                    fontFamily: 'Source Serif Pro',
                                    fontSize: 56,
                                    letterSpacing:
                                        0 /*percentages not used in flutter. defaulting to zero*/,
                                    fontWeight: FontWeight.normal,
                                    height: 1),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    // onTap: () {
                    //   Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //           builder: (context) => const LeaderBoardTable()));
                    // },
                    child: Container(
                      width: 600,
                      height: 130,
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
                            children: [
                              Image.asset(
                                'assets/Image7.png',
                                scale: 4,
                              ),
                              const SizedBox(
                                width: 56,
                              ),
                              const Flexible(
                                child: Text(
                                  'Page 1 - 201',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Color.fromRGBO(0, 0, 0, 1),
                                      fontFamily: 'Source Serif Pro',
                                      fontSize: 56,
                                      letterSpacing:
                                          0 /*percentages not used in flutter. defaulting to zero*/,
                                      fontWeight: FontWeight.normal,
                                      height: 1),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LeaderBoardTable()));
                    },
                    child: Container(
                      width: 600,
                      height: 130,
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
                            Image.asset(
                              'assets/Image7.png',
                              scale: 4,
                            ),
                            const Flexible(
                              child: Text(
                                'Page 202 - 402',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Color.fromRGBO(0, 0, 0, 1),
                                    fontFamily: 'Source Serif Pro',
                                    fontSize: 56,
                                    letterSpacing:
                                        0 /*percentages not used in flutter. defaulting to zero*/,
                                    fontWeight: FontWeight.normal,
                                    height: 1),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LeaderBoardTable()));
                    },
                    child: Container(
                      width: 600,
                      height: 130,
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
                            Image.asset(
                              'assets/Image7.png',
                              scale: 4,
                            ),
                            const Flexible(
                              child: Text(
                                'Page 403 - 604',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Color.fromRGBO(0, 0, 0, 1),
                                    fontFamily: 'Source Serif Pro',
                                    fontSize: 56,
                                    letterSpacing:
                                        0 /*percentages not used in flutter. defaulting to zero*/,
                                    fontWeight: FontWeight.normal,
                                    height: 1),
                              ),
                            ),
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
    await FirebaseFirestore.instance
        .collection('quranIrabUsers')
        .doc(AppUser.instance.user!.uid)
        .collection('quizs')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        int score = doc['score'];
        setState(() {
          overall = overall + score;
          num = num + 1;
        });
      }
    });

    await FirebaseFirestore.instance
        .collection('leaderboards')
        .doc('overall')
        .collection('scores')
        .doc(AppUser.instance.user!.uid)
        .set(
      {
        'name': AppUser.instance.user!.displayName, // John Doe
        'scores': overall,
        'total-quiz': num
      },
      SetOptions(merge: true),
    );
  }
}
