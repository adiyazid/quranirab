import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quranirab/facebook/widgets/responsive.dart';
import 'package:quranirab/theme/theme_provider.dart';
import 'package:quranirab/widget/LanguagePopup.dart';
import 'package:quranirab/widget/setting.popup.dart';
import 'package:quranirab/widget/TranslationPopup.dart';
import 'package:quranirab/widget/menu.dart';

import 'Appbar/appbar.dart';
import 'Surah/surah1.dart';
import 'Surah/surah2.dart';
import 'Translation/translation.dart';

class FacebookHomeScreen2 extends StatefulWidget {
  const FacebookHomeScreen2({Key? key}) : super(key: key);

  @override
  _FacebookHomeScreen2State createState() => _FacebookHomeScreen2State();
}

class _FacebookHomeScreen2State extends State<FacebookHomeScreen2> {
  final TrackingScrollController _trackingScrollController =
      TrackingScrollController();

  @override
  void dispose() {
    _trackingScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Responsive(
          mobile: () {
            return _HomeScreenMobile(
                scrollController: _trackingScrollController);
          },
          desktop: () {
            return _HomeScreenDesktop(
                scrollController: _trackingScrollController);
          },
        ),
      ),
    );
  }
}

class _HomeScreenMobile extends StatelessWidget {
  final TrackingScrollController scrollController;

  const _HomeScreenMobile({
    Key? key,
    required this.scrollController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Menu(),
      //endDrawer: const Setting(),
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            SizedBox(
              height: 115,
              child: CustomScrollView(
                controller: scrollController,
                slivers: const [
                  Appbar(),
                  // TabBarWidget()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeScreenDesktop extends StatefulWidget {
  final TrackingScrollController scrollController;

  const _HomeScreenDesktop({
    Key? key,
    required this.scrollController,
  }) : super(key: key);

  @override
  State<_HomeScreenDesktop> createState() => _HomeScreenDesktopState();
}

class _HomeScreenDesktopState extends State<_HomeScreenDesktop> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: const Color(0xff666666),
      drawer: const Menu(),
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
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
                      padding: EdgeInsets.only(right: 20.0),
                      child: LangPopup()),
                  const Padding(
                      padding: EdgeInsets.only(right: 20.0),
                      child: SettingPopup()),
                ],
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(120),
                  child: Column(
                    children: [
                      Row(children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: ListTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'Al-Fatihah',
                                  style: TextStyle(fontSize: 18),
                                ),
                                Text(
                                  'The Opener',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 16),
                                ),
                              ],
                            ),
                            trailing: const Icon(Icons.keyboard_arrow_down),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                          height: 40,
                          child: VerticalDivider(
                            thickness: 2,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(
                          width: 320,
                          child: Row(
                            children: const [
                              VerticalDivider(
                                thickness: 2,
                                color: Colors.grey,
                              ),
                              SizedBox(width: 16),
                              Flexible(
                                child: Text(
                                  'Juz 1 / Hizb 1 - Page 1',
                                  style: TextStyle(fontSize: 16),
                                ),
                              )
                            ],
                          ),
                        ),
                        const Spacer(),
                        const Padding(
                          padding: EdgeInsets.only(left: 20, right: 8),
                          child: TransPopup(),
                        ),
                      ]),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: TabBar(
                            indicatorPadding: const EdgeInsets.all(8),
                            indicator: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                // Creates border
                                color: Theme.of(context).primaryColor),
                            tabs: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Tab(
                                  child: Text(
                                    'Translations',
                                    style: TextStyle(
                                        color: themeProvider.isDarkMode
                                            ? Colors.white
                                            : Colors.black),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Tab(
                                  child: Text(
                                    'Reading',
                                    style: TextStyle(
                                        color: themeProvider.isDarkMode
                                            ? Colors.white
                                            : Colors.black),
                                  ),
                                ),
                              )
                            ]),
                      ),
                    ],
                  ),
                ),
              ),
            ];
          },
          body:  const TabBarView(
            children: [
              TranslationPage('1','1'),
              SurahPage2('1', '1'),
            ],
          ),
        ),
      ),
    );
  }
}

class ItemModel {
  String text;
  IconData icon;

  ItemModel(this.text, this.icon);
}
