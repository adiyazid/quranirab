import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:quranirab/provider/user.provider.dart';
import 'package:quranirab/quiz_module/quiz.dart';
import 'package:quranirab/quiz_module/utils/button114.dart';
import 'package:quranirab/quiz_module/utils/button182.dart';
import 'package:quranirab/quiz_module/utils/colors.dart';
import 'package:quranirab/theme/theme_provider.dart';
import 'package:quranirab/widget/appbar.widget.dart';
import 'package:quranirab/widget/menu.dart';

class QuizHome extends StatefulWidget {
  final int page;

  const QuizHome(this.page, {Key? key}) : super(key: key);

  @override
  _QuizHomeState createState() => _QuizHomeState();
}

class _QuizHomeState extends State<QuizHome> {
  int? highscore;
  @override
  initState() {
    getHighScore();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor:
          themeProvider.isDarkMode ? Color(0xff808ba1) : Color(0xfffff5ec),
      drawer: const Menu(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                    width: 2.0,
                    color: themeProvider.isDarkMode
                        ? Colors.white
                        : const Color(0xffE86F00)),
              ),
            ),
            height: 77,
            child: CustomScrollView(
              slivers: const [Appbar()],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 77, bottom: 20),
            child: Container(
                margin: EdgeInsets.all(8),
                color: themeProvider.isDarkMode
                    ? Color(0xff808ba1)
                    : Color(0xfffff5ec),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Your high score is ' + highscore.toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                    Center(
                      child: button182(
                          AppLocalizations.of(context)!.startTheQuiz,
                          const TextStyle(fontSize: 28),
                          themeProvider.isDarkMode
                              ? ManyColors.color4
                              : ManyColors.color0,
                          10, () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    Quiz(widget.page, highscore!)));
                      }, true),
                    ),
                  ],
                )),
          ),
          button114(
              AppLocalizations.of(context)!.back,
              TextStyle(
                  color: themeProvider.isDarkMode ? Colors.white : Colors.black,
                  fontSize: 18),
              themeProvider.isDarkMode ? Color(0xff808ba1) : Color(0xfffff5ec),
              10, () {
            Navigator.pop(context);
          }, true),
        ],
      ),
    );
  }

  Future<void> getHighScore() async {
    await FirebaseFirestore.instance
        .collection('quranIrabUsers')
        .doc(AppUser.instance.user!.uid)
        .collection('quizs')
        .doc("${widget.page}")
        .get()
        .then((value) => setState(() {
              highscore = value['score'];
            }));
  }
}
