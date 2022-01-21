import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quranirab/quiz_module/LeaderBoard.Table.dart';
import 'package:quranirab/theme/theme_provider.dart';
import 'package:quranirab/widget/LanguagePopup.dart';
import 'package:quranirab/widget/SettingPopup.dart';
import 'package:quranirab/widget/menu.dart';

class LeaderBoardMenu extends StatefulWidget {
  const LeaderBoardMenu({Key? key}) : super(key: key);

  @override
  State<LeaderBoardMenu> createState() => _LeaderBoardMenuState();
}

class _LeaderBoardMenuState extends State<LeaderBoardMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Menu(),
      body: NestedScrollView(
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
            decoration: const BoxDecoration(
              color: Color.fromRGBO(255, 237, 173, 1),
            ),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  const Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      'Leaderboards',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Color.fromRGBO(0, 0, 0, 1),
                          fontFamily: 'Source Serif Pro',
                          fontSize: 72,
                          letterSpacing:
                              0 /*percentages not used in flutter. defaulting to zero*/,
                          fontWeight: FontWeight.normal,
                          height: 1),
                    ),
                  ),
                  Container(
                    width: 500,
                    height: 130,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                      color: Color.fromRGBO(255, 250, 208, 1),
                    ),
                    child: const Center(
                      child: Text(
                        'Overall',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 1),
                            fontFamily: 'Source Serif Pro',
                            fontSize: 64,
                            letterSpacing:
                                0 /*percentages not used in flutter. defaulting to zero*/,
                            fontWeight: FontWeight.normal,
                            height: 1),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LeaderBoardTable()));
                    },
                    child: Container(
                      width: 500,
                      height: 130,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                        color: Color.fromRGBO(255, 250, 208, 1),
                      ),
                      child: const Center(
                        child: Text(
                          'Page 1 - 201',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Color.fromRGBO(0, 0, 0, 1),
                              fontFamily: 'Source Serif Pro',
                              fontSize: 64,
                              letterSpacing:
                                  0 /*percentages not used in flutter. defaulting to zero*/,
                              fontWeight: FontWeight.normal,
                              height: 1),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 500,
                    height: 130,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                      color: Color.fromRGBO(255, 250, 208, 1),
                    ),
                    child: const Center(
                      child: Text(
                        'Page 202 - 402',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 1),
                            fontFamily: 'Source Serif Pro',
                            fontSize: 64,
                            letterSpacing:
                                0 /*percentages not used in flutter. defaulting to zero*/,
                            fontWeight: FontWeight.normal,
                            height: 1),
                      ),
                    ),
                  ),
                  Container(
                    width: 500,
                    height: 130,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                      color: Color.fromRGBO(255, 250, 208, 1),
                    ),
                    child: const Center(
                      child: Text(
                        'Page 403 - 604',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 1),
                            fontFamily: 'Source Serif Pro',
                            fontSize: 64,
                            letterSpacing:
                                0 /*percentages not used in flutter. defaulting to zero*/,
                            fontWeight: FontWeight.normal,
                            height: 1),
                      ),
                    ),
                  )
                ])),
      ),
    );
  }
}
