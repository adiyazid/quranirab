import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quranirab/models/category.dart';
import 'package:quranirab/quiz_module/LeaderBoard.Table.dart';
import 'package:quranirab/theme/theme_provider.dart';
import 'package:quranirab/widget/menu.dart';

import '../widget/appbar.widget.dart';

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
      body: Column(
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
            height: 57,
            child: CustomScrollView(
              slivers: const [Appbar()],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height - 57,
            decoration: BoxDecoration(
                color: themeProvider.isDarkMode
                    ? const Color(0xff808BA1)
                    : const Color.fromRGBO(255, 237, 173, 1)),
            child: Column(
                mainAxisAlignment: MediaQuery.of(context).size.width > 600
                    ? MainAxisAlignment.spaceAround
                    : MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Align(
                    alignment: Alignment.topCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        themeProvider.isDarkMode
                            ? Image.asset(
                                'assets/Image2.png',
                                scale: MediaQuery.of(context).size.width > 600
                                    ? 2.5
                                    : 3,
                              )
                            : Image.asset(
                                'assets/Image1.png',
                                scale: MediaQuery.of(context).size.width > 600
                                    ? 2.5
                                    : 3,
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
                      await Future.delayed(const Duration(seconds: 2), () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const LeaderBoardTable()));
                      });
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width<600? MediaQuery.of(context).size.width*0.7 :600,
                      height: MediaQuery.of(context).size.width > 600
                          ? MediaQuery.of(context).size.height * 0.15
                          : 100,
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
                              scale: MediaQuery.of(context).size.width > 600
                                  ? 4
                                  : 10,
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LeaderBoardTable()));
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width<600? MediaQuery.of(context).size.width*0.7 :600,
                      height: MediaQuery.of(context).size.width > 600
                          ? MediaQuery.of(context).size.height * 0.15
                          : 100,
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
                                scale: MediaQuery.of(context).size.width > 600
                                    ? 4
                                    : 10,
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LeaderBoardTable()));
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width<600? MediaQuery.of(context).size.width*0.7 :600,
                      height: MediaQuery.of(context).size.width > 600
                          ? MediaQuery.of(context).size.height * 0.15
                          : 100,
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
                                scale: MediaQuery.of(context).size.width > 600
                                    ? 4
                                    : 10,
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LeaderBoardTable()));
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width<600? MediaQuery.of(context).size.width*0.7 :600,
                      height: MediaQuery.of(context).size.width > 600
                          ? MediaQuery.of(context).size.height * 0.15
                          : 100,
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
                                scale: MediaQuery.of(context).size.width > 600
                                    ? 4
                                    : 10,
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
                ]),
          ),
        ],
      ),
    );
  }
}
