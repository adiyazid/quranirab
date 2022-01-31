import 'package:flutter/material.dart';
import 'package:quranirab/facebook/screens/Appbar/appbar.dart';
import 'package:quranirab/facebook/screens/home_screen_1.dart';
import 'package:quranirab/quiz_module/utils/button114.dart';
import 'package:quranirab/quiz_module/utils/button182.dart';
import 'package:quranirab/quiz_module/utils/colors.dart';
import 'package:quranirab/widget/menu.dart';
import 'package:quranirab/widget/setting.dart';
import 'package:quranirab/quiz_module/Quiz.dart';

class QuizHome extends StatefulWidget {
  const QuizHome({Key? key}) : super(key: key);

  @override
  _QuizHomeState createState() => _QuizHomeState();
}

class _QuizHomeState extends State<QuizHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white12,
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 50, bottom: 20),
                      child: Container(
                          color: const Color(0xfffff5ec),
                          width: MediaQuery.of(context).size.width / 1.4,
                          height: MediaQuery.of(context).size.height / 1.4,
                          child: Center(
                            child: button182(
                                'Start the Quiz',
                                const TextStyle(fontSize: 28),
                                ManyColors.color11,
                                10, () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Quiz()));
                            }, true),
                          )),
                    ),
                    button114(
                        'Back',
                        const TextStyle(color: Colors.black, fontSize: 18),
                        const Color(0xffffb55f),
                        10, () {
                      Navigator.pop(context);
                    }, true),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
