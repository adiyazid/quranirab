import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quranirab/quiz_module/utils/button114.dart';
import 'package:quranirab/quiz_module/utils/button182.dart';
import 'package:quranirab/quiz_module/utils/colors.dart';
import 'package:quranirab/theme/theme_provider.dart';
import 'package:quranirab/widget/appbar.widget.dart';
import 'package:quranirab/widget/menu.dart';
import 'package:quranirab/widget/setting.dart';
import 'package:quranirab/quiz_module/quiz.dart';

class QuizHome extends StatefulWidget {
  final int page;

  const QuizHome(this.page, {Key? key}) : super(key: key);

  @override
  _QuizHomeState createState() => _QuizHomeState();
}

class _QuizHomeState extends State<QuizHome> {
  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: themeProvider.isDarkMode ? Color(0xff666666) : Colors.white,
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
                    // Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: Text('Quiz Page ${widget.page}',
                    //       style: TextStyle(
                    //         fontSize: 28,
                    //         color: ManyColors.color11,
                    //       )),
                    // ),
                    Padding(
                      padding: const EdgeInsets.only(top: 50, bottom: 20),
                      child: Container(
                          color: themeProvider.isDarkMode ? Color(0xff808ba1) : Color(0xfffff5ec),
                          width: MediaQuery.of(context).size.width / 1.4,
                          height: MediaQuery.of(context).size.height / 1.4,
                          child: Center(
                            child: button182(
                                'Start the Quiz',
                                const TextStyle(fontSize: 28),
                                themeProvider.isDarkMode ? ManyColors.color4 : ManyColors.color0,
                                10, () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Quiz(widget.page)));
                            }, true),
                          )),
                    ),
                    button114(
                        'Back',
                        const TextStyle(color: Colors.black, fontSize: 18),
                        const Color(0xfffff5ec),
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
