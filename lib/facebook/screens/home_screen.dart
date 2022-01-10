import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:quranirab/facebook/palette.dart';
import 'package:quranirab/facebook/widgets/create_post_container.dart';
import 'package:quranirab/facebook/widgets/more_options_list.dart';
import 'package:quranirab/facebook/widgets/responsive.dart';
import 'package:quranirab/theme/theme_provider.dart';
import 'package:quranirab/widget/menu.dart';
import 'package:quranirab/widget/setting.dart';

import 'Appbar/appbar.dart';

class FacebookHomeScreen extends StatefulWidget {
  const FacebookHomeScreen({Key? key}) : super(key: key);

  @override
  _FacebookHomeScreenState createState() => _FacebookHomeScreenState();
}

class _FacebookHomeScreenState extends State<FacebookHomeScreen> {
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
      endDrawer: const Setting(),
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            SizedBox(
              height: 115,
              child: CustomScrollView(
                controller: scrollController,
                slivers: const [Appbar(), TabBarWidget()],
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
  bool onhover = false;

  get ayat1 {
    return 'بِسْمِ ٱللَّهِ ٱلرَّحْمَـٰنِ ٱلرَّحِيمِ ﴿١﴾b';
  }

  get ayat2 {
    return 'ٱلْحَمْدُ لِلَّهِ رَبِّ ٱلْعَـٰلَمِينَ ﴿٢﴾b';
  }

  get ayat3 {
    return 'ٱلرَّحْمَـٰنِ ٱلرَّحِيمِ ﴿٣﴾';
  }

  get ayat4 {
    return 'مَـٰلِكِ يَوْمِ ٱلدِّينِ ﴿٤﴾b';
  }

  get ayat5 {
    return 'إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ ﴿٥﴾';
  }

  get ayat6 {
    return 'ٱهْدِنَاbٱلصِّرَ ٰطَ ٱلْمُسْتَقِيمَ ﴿٦﴾';
  }

  get ayat7 {
    return 'صِرَ ٰطَ ٱلَّذِينَ أَنْعَمْتَbعَلَيْهِمْ غَيْرِ ٱلْمَغْضُوبِ عَلَيْهِمْbوَلَا ٱلضَّآلِّينَ ﴿٧﴾b';
  }

  var ontap = false;
  Color? textColor;

  Color changeBlue() {
    var c = Colors.blueAccent;
    return c;
  }

  Color changeRed() {
    var c = Colors.redAccent;
    return c;
  }

  @override
  Widget build(BuildContext context) {
    textColor = Colors.black;
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      drawer: const Menu(),
      endDrawer: const Setting(),
      body: DefaultTabController(
        length: 3,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 115,
                child: CustomScrollView(
                  slivers: [
                    Appbar(),
                    TabBarWidget(),
                  ],
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.9,
                child: Stack(
                  children: [
                    Align(
                      child: Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.9,
                            color: (themeProvider.isDarkMode)
                                ? Palette.dark
                                : const Color(0xffFFF5EC),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Flexible(
                                  child: Directionality(
                                      textDirection: TextDirection.rtl,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 96.0),
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              ontap = true;
                                            });
                                          },
                                          onDoubleTap: () {
                                            setState(() {
                                              ontap = false;
                                            });
                                          },
                                          child: Tooltip(
                                            message:
                                                'One click to show details, double click to close',
                                            child: RichText(
                                                textAlign: TextAlign.center,
                                                text: TextSpan(children: [
                                                  TextSpan(
                                                    onEnter: (v) async =>
                                                        setState(() {
                                                      onhover = true;
                                                    }),
                                                    onExit: (v) async =>
                                                        setState(() {
                                                      onhover = false;
                                                    }),
                                                    text: ayat1.replaceAll(
                                                      'b',
                                                      '\n',
                                                    ),
                                                    style: TextStyle(
                                                      fontFamily: 'MeQuran2',
                                                      fontSize: 40,
                                                      color: (onhover)
                                                          ? changeBlue()
                                                          : Theme.of(context)
                                                              .colorScheme
                                                              .onSecondary,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: ayat2.replaceAll(
                                                      'b',
                                                      '\n',
                                                    ),
                                                    style: TextStyle(
                                                      fontFamily: 'MeQuran2',
                                                      fontSize: 40,
                                                      color: textColor,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: ayat3.replaceAll(
                                                      'b',
                                                      '\n',
                                                    ),
                                                    style: TextStyle(
                                                      fontFamily: 'MeQuran2',
                                                      fontSize: 40,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onSecondary,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: ayat4.replaceAll(
                                                      'b',
                                                      '\n',
                                                    ),
                                                    style: TextStyle(
                                                      fontFamily: 'MeQuran2',
                                                      fontSize: 40,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onSecondary,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: ayat5.replaceAll(
                                                      'b',
                                                      '\n',
                                                    ),
                                                    style: TextStyle(
                                                      fontFamily: 'MeQuran2',
                                                      fontSize: 40,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onSecondary,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: ayat6.replaceAll(
                                                      'b',
                                                      '\n',
                                                    ),
                                                    style: TextStyle(
                                                      fontFamily: 'MeQuran2',
                                                      fontSize: 40,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onSecondary,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: ayat7.replaceAll(
                                                      'b',
                                                      '\n',
                                                    ),
                                                    style: TextStyle(
                                                      fontFamily: 'MeQuran2',
                                                      fontSize: 40,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onSecondary,
                                                    ),
                                                  ),
                                                ])),
                                          ),
                                        ),
                                      )),
                                ),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.1,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: (themeProvider.isDarkMode)
                                              ? const Color(0xffffffff)
                                              : const Color(0xffFFB55F)),
                                      color: Theme.of(context)
                                          .colorScheme
                                          .background,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {},
                                          style: ElevatedButton.styleFrom(
                                              primary: (themeProvider
                                                      .isDarkMode)
                                                  ? const Color(0xff808BA1)
                                                  : const Color(0xfffcd77a)),
                                          child: const Text(
                                            'Previous Page',
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ),
                                        const SizedBox(width: 25),
                                        ElevatedButton(
                                            onPressed: () {},
                                            style: ElevatedButton.styleFrom(
                                                primary: (themeProvider
                                                        .isDarkMode)
                                                    ? const Color(0xff4C6A7A)
                                                    : const Color(0xffffeeb0)),
                                            child: const Text(
                                              'Beginning Surah',
                                              style: TextStyle(
                                                  color: Colors.black),
                                            )),
                                        const SizedBox(width: 25),
                                        ElevatedButton(
                                            onPressed: () {},
                                            style: ElevatedButton.styleFrom(
                                                primary: (themeProvider
                                                        .isDarkMode)
                                                    ? const Color(0xff808BA1)
                                                    : const Color(0xfffcd77a)),
                                            child: const Text(
                                              'Next Page',
                                              style: TextStyle(
                                                  color: Colors.black),
                                            )),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: ontap,
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.2,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: (themeProvider.isDarkMode)
                                    ? const Color(0xffffffff)
                                    : const Color(0xffFFB55F)),
                            color: (themeProvider.isDarkMode)
                                ? const Color(0xff808ba1)
                                : const Color(0xfffff3ca),
                          ),
                          child: const MoreOptionsList(
                            surah: 'Straight',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TabBarWidget extends StatelessWidget {
  const TabBarWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final bool isDesktop = Responsive.isDesktop(context);
    return SliverPersistentHeader(
      floating: true,
      delegate: _SliverAppBarDelegate(
        TabBar(
          mouseCursor: SystemMouseCursors.basic,
          overlayColor: MaterialStateProperty.all(Colors.transparent),
          physics: const NeverScrollableScrollPhysics(),
          indicatorColor: Colors.transparent,
          tabs: [
            Padding(
              padding: isDesktop
                  ? const EdgeInsets.only(right: 110.0)
                  : const EdgeInsets.all(1),
              child: ListTile(
                title: InkWell(
                  onTap: () {},
                  child: SizedBox(
                    width: 240,
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Al-Fatihah',
                              style: TextStyle(fontSize: isDesktop ? 18 : 14),
                            ),
                            Text(
                              'The Opener',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: isDesktop ? 16 : 14),
                            ),
                          ],
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                ),
                trailing: SizedBox(
                  width: isDesktop ? 320 : 100,
                  child: Row(
                    children: [
                      const VerticalDivider(
                        thickness: 2,
                        color: Colors.grey,
                      ),
                      SizedBox(width: isDesktop ? 16 : 0),
                      Flexible(
                        child: Text(
                          'Juz 1 / Hizb 1 - Page 1',
                          style: TextStyle(fontSize: isDesktop ? 16 : 12),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            const CenterTabBar(),
            Icon(
              MdiIcons.bookOpen,
              color: (themeProvider.isDarkMode)
                  ? const Color(0xffD2D6DA)
                  : const Color(0xffE86F00),
            )
          ],
        ),
      ),
      pinned: true,
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
