import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quranirab/theme/theme_provider.dart';
import 'package:quranirab/views/surah.screen.dart';
import 'package:skeleton_loader/skeleton_loader.dart';
import 'package:quranirab/provider/ayah.number.provider.dart';
import 'package:quranirab/provider/bookmark.provider.dart';
import 'package:quranirab/widget/menu.dart';
import '../widget/appbar.widget.dart';
import 'juz.screen.dart';

class HomePage1 extends StatefulWidget {
  const HomePage1({Key? key}) : super(key: key);

  @override
  State<HomePage1> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage1>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  //int count=0;

  var j;
  List _juzsName = [];
  @override
  void initState() {
    // TODO: implement initState
    getList();
    getJuzs();
    getSurah();
    getJuzsName();

    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);

    // Figma Flutter Generator Desktop31Widget - FRAME
    return SafeArea(
      child: Scaffold(
          backgroundColor:
          themeProvider.isDarkMode ? Color(0xff666666) : Colors.white,
          drawer: const Menu(),
          body: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
                child: CustomScrollView(
                  slivers: const [Appbar()],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Container(
                    height: MediaQuery.of(context).size.height * 0.25,
                    alignment: Alignment.topLeft,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                      color: themeProvider.isDarkMode
                          ? Color(0xff666666)
                          : Colors.white,
                      border: Border.all(
                        color: themeProvider.isDarkMode
                            ? Color(0xffD2D6DA)
                            : Color.fromRGBO(231, 111, 0, 1),
                        width: 1,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Consumer<BookMarkProvider>(
                          builder: (context, bm, child) {
                            if (bm.bookmarkList.isNotEmpty) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Align(
                                    child: Text(
                                      'Bookmark',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          fontFamily: 'Open Sans',
                                          fontSize:
                                          MediaQuery.of(context).size.width <
                                              600
                                              ? 20
                                              : 24,
                                          letterSpacing: -0.38723403215408325,
                                          fontWeight: FontWeight.normal,
                                          height: 1),
                                    ),
                                    alignment: Alignment.topLeft,
                                  ),
                                  SizedBox(
                                      height:
                                      MediaQuery.of(context).size.height * 0.15,
                                      child: ListView.builder(
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          if (index == bm.bookmarkList.length) {
                                            return IconButton(
                                              onPressed: () => bm.deleteAll(),
                                              icon: Icon(Icons.delete_sharp),
                                            );
                                          }
                                          return InkWell(
                                            onTap: () async {
                                              var a = await getTotalPage(
                                                  bm.bookmarkList[index].suraId!);
                                              Provider.of<AyaProvider>(context,
                                                  listen: false)
                                                  .getPage(int.parse(bm
                                                  .bookmarkList[index]
                                                  .pages!
                                                  .first));
                                              Provider.of<AyaProvider>(context,
                                                  listen: false)
                                                  .setDefault();
                                              Provider.of<AyaProvider>(context,
                                                  listen: false)
                                                  .getStart(
                                                  int.parse(bm
                                                      .bookmarkList[index]
                                                      .suraId!),
                                                  int.parse(bm
                                                      .bookmarkList[index]
                                                      .pages!
                                                      .first));

                                              // Provider.of<AyaProvider>(context,
                                              //     listen: false)
                                              //     .getPage(439);
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          SurahScreen(
                                                            a,
                                                            bm.bookmarkList[index]
                                                                .suraId!,
                                                            bm.bookmarkList[index]
                                                                .tname!,
                                                            bm.bookmarkList[index]
                                                                .ename!,
                                                            a.indexOf(bm
                                                                .bookmarkList[index]
                                                                .pages!
                                                                .first),
                                                          )));
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 16.0),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(10),
                                                    topRight: Radius.circular(10),
                                                    bottomLeft: Radius.circular(10),
                                                    bottomRight:
                                                    Radius.circular(10),
                                                  ),
                                                  color: themeProvider.isDarkMode
                                                      ? Color(0xff67748E)
                                                      : Color.fromRGBO(
                                                      255, 255, 255, 1),
                                                  border: Border.all(
                                                    color: themeProvider.isDarkMode
                                                        ? Color(0xffD2D6DA)
                                                        : Color.fromRGBO(
                                                        231, 111, 0, 1),
                                                    width: 1,
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding:
                                                  const EdgeInsets.all(16.0),
                                                  child: Center(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                      children: [
                                                        Text(
                                                          bm.bookmarkList[index]
                                                              .tname!,
                                                          style: TextStyle(
                                                              fontSize: 22),
                                                        ),
                                                        Container(
                                                          width: 75,
                                                          height: 25,
                                                          decoration: BoxDecoration(
                                                            borderRadius:
                                                            BorderRadius.only(
                                                              topLeft:
                                                              Radius.circular(
                                                                  10),
                                                              topRight:
                                                              Radius.circular(
                                                                  10),
                                                              bottomLeft:
                                                              Radius.circular(
                                                                  10),
                                                              bottomRight:
                                                              Radius.circular(
                                                                  10),
                                                            ),
                                                            color: themeProvider
                                                                .isDarkMode
                                                                ? Color.fromRGBO(
                                                                128,
                                                                138,
                                                                177,
                                                                1)
                                                                : Color(0xffFFB55F),
                                                            border: Border.all(
                                                              color: themeProvider
                                                                  .isDarkMode
                                                                  ? Color.fromRGBO(
                                                                  128,
                                                                  138,
                                                                  177,
                                                                  1)
                                                                  : Color(
                                                                  0xffFFB55F),
                                                              width: 1,
                                                            ),
                                                          ),
                                                          child: Center(
                                                            child: Text(bm
                                                                .bookmarkList[index]
                                                                .ayahNo!),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                        scrollDirection: Axis.horizontal,
                                        itemCount: bm.bookmarkList.length + 1,
                                      )),
                                ],
                              );
                            }
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Align(
                                  child: Text(
                                    'Bookmark',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        fontFamily: 'Open Sans',
                                        fontSize:
                                        MediaQuery.of(context).size.width < 600
                                            ? 20
                                            : 24,
                                        letterSpacing: -0.38723403215408325,
                                        fontWeight: FontWeight.normal,
                                        height: 1),
                                  ),
                                  alignment: Alignment.topLeft,
                                ),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    'You do not have any bookmark yet',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontFamily: 'Open Sans',
                                        fontSize:
                                        MediaQuery.of(context).size.width < 600
                                            ? 20
                                            : 24,
                                        letterSpacing: -0.38723403215408325,
                                        fontWeight: FontWeight.normal,
                                        height: 1),
                                  ),
                                ),
                              ],
                            );
                          }),
                    )),
              ),
              SizedBox(
                height: 16,
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 32.0, right: 32.0, bottom: 32.0),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.55,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                    color: themeProvider.isDarkMode
                        ? Color(0xff666666)
                        : Colors.white,
                    border: Border.all(
                      color: themeProvider.isDarkMode
                          ? Color(0xffD2D6DA)
                          : Color.fromRGBO(231, 111, 0, 1),
                      width: 1,
                    ),
                  ),
                  child: Padding(
                    padding:
                    const EdgeInsets.only(top: 8.0, right: 8.0, left: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05,
                          width: 180,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TabBar(
                              indicatorColor: themeProvider.isDarkMode
                                  ? Colors.white
                                  : Colors.black,
                              controller: _tabController,
                              tabs: const [
                                Text(
                                  'Sura',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontFamily: 'Open Sans',
                                      fontSize: 24,
                                      letterSpacing: -0.38723403215408325,
                                      fontWeight: FontWeight.normal,
                                      height: 1),
                                ),
                                Text(
                                  'Juz',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontFamily: 'Open Sans',
                                      fontSize: 24,
                                      letterSpacing: -0.38723403215408325,
                                      fontWeight: FontWeight.normal,
                                      height: 1),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.48,
                          child: TabBarView(
                              controller: _tabController,
                              children: [
                                Column(
                                  children: [
                                    Expanded(
                                      child: _list.isNotEmpty
                                          ? MediaQuery.of(context).size.width >
                                          600
                                          ? GridView.builder(
                                        controller:
                                        ScrollController(),
                                        gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount:
                                            MediaQuery.of(context)
                                                .size
                                                .width <
                                                1200
                                                ? 2
                                                : 3,
                                            crossAxisSpacing: 5.0,
                                            mainAxisSpacing: 5.0,
                                            childAspectRatio:
                                            4.5),
                                        itemCount: 114,
                                        itemBuilder:
                                            (BuildContext context,
                                            int index) {
                                          return Padding(
                                            padding: const EdgeInsets
                                                .symmetric(
                                                horizontal: 16.0,
                                                vertical: 8),
                                            child: InkWell(
                                              onTap: () async {
                                                var a =
                                                await getTotalPage(
                                                    _list[index]
                                                    ["id"]);
                                                Provider.of<AyaProvider>(
                                                    context,
                                                    listen: false)
                                                    .getPage(
                                                    int.parse(
                                                        a.first));
                                                Provider.of<AyaProvider>(
                                                    context,
                                                    listen: false)
                                                    .setDefault();
                                                Provider.of<AyaProvider>(
                                                    context,
                                                    listen: false)
                                                    .getStart(
                                                    int.parse(_list[
                                                    index]
                                                    ['id']),
                                                    int.parse(
                                                        a.first));

                                                // Provider.of<AyaProvider>(context,
                                                //     listen: false)
                                                //     .getPage(439);
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) => SurahScreen(
                                                            a,
                                                            _list[index]
                                                            [
                                                            "id"],
                                                            _list[index]
                                                            [
                                                            "tname"],
                                                            _list[index]
                                                            [
                                                            "ename"],
                                                            0)));
                                              },
                                              child: Container(
                                                width: 400,
                                                height: 100,
                                                decoration:
                                                BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius
                                                        .only(
                                                      topLeft: Radius
                                                          .circular(
                                                          10),
                                                      topRight: Radius
                                                          .circular(
                                                          10),
                                                      bottomLeft:
                                                      Radius.circular(
                                                          10),
                                                      bottomRight:
                                                      Radius.circular(
                                                          10),
                                                    ),
                                                    color: themeProvider
                                                        .isDarkMode
                                                        ? Color(
                                                        0xff67748E)
                                                        : Color.fromRGBO(
                                                        255,
                                                        255,
                                                        255,
                                                        1),
                                                    border: Border
                                                        .all(
                                                      color: themeProvider
                                                          .isDarkMode
                                                          ? Color(
                                                          0xffD2D6DA)
                                                          : Color.fromRGBO(
                                                          231,
                                                          111,
                                                          0,
                                                          1),
                                                      width: 1,
                                                    )),
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                                  children: [
                                                    Container(
                                                        width: 50,
                                                        height: 100,
                                                        decoration:
                                                        BoxDecoration(
                                                          borderRadius:
                                                          BorderRadius
                                                              .only(
                                                            topLeft: Radius
                                                                .circular(
                                                                10),
                                                            topRight:
                                                            Radius.circular(
                                                                10),
                                                            bottomLeft:
                                                            Radius.circular(
                                                                10),
                                                            bottomRight:
                                                            Radius.circular(
                                                                10),
                                                          ),
                                                          color: themeProvider
                                                              .isDarkMode
                                                              ? Color(
                                                              0xff808BA1)
                                                              : Color.fromRGBO(
                                                              255,
                                                              181,
                                                              94,
                                                              1),
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                            '${index + 1}',
                                                            textAlign:
                                                            TextAlign
                                                                .left,
                                                            style: TextStyle(
                                                                fontFamily:
                                                                'Open Sans',
                                                                fontSize:
                                                                24,
                                                                letterSpacing:
                                                                -0.38723403215408325,
                                                                fontWeight: FontWeight
                                                                    .normal,
                                                                height:
                                                                1),
                                                          ),
                                                        )),
                                                    Spacer(),
                                                    Column(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .center,
                                                      children: [
                                                        Text(
                                                          _list[index]
                                                          [
                                                          "tname"],
                                                          textAlign:
                                                          TextAlign
                                                              .left,
                                                          style: TextStyle(
                                                              fontFamily:
                                                              'Open Sans',
                                                              fontSize:
                                                              24,
                                                              letterSpacing:
                                                              -0.38723403215408325,
                                                              fontWeight:
                                                              FontWeight
                                                                  .normal,
                                                              height:
                                                              1),
                                                        ),
                                                        Text(
                                                          _list[index]
                                                          [
                                                          "ename"],
                                                          textAlign:
                                                          TextAlign
                                                              .left,
                                                          style: TextStyle(
                                                              color: Color.fromRGBO(
                                                                  151,
                                                                  151,
                                                                  151,
                                                                  1),
                                                              fontFamily:
                                                              'Open Sans',
                                                              fontSize:
                                                              22,
                                                              letterSpacing:
                                                              -0.38723403215408325,
                                                              fontWeight:
                                                              FontWeight
                                                                  .normal,
                                                              height:
                                                              1),
                                                        )
                                                      ],
                                                    ),
                                                    Spacer()
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      )
                                          : ListView.builder(
                                        controller:
                                        ScrollController(),
                                        itemCount: 114,
                                        itemBuilder:
                                            (BuildContext context,
                                            int index) {
                                          return Padding(
                                            padding: const EdgeInsets
                                                .symmetric(
                                                horizontal: 8.0,
                                                vertical: 8),
                                            child: InkWell(
                                              onTap: () async {
                                                var a =
                                                await getTotalPage(
                                                    _list[index]
                                                    ["id"]);
                                                Provider.of<AyaProvider>(
                                                    context,
                                                    listen: false)
                                                    .getPage(
                                                    int.parse(
                                                        a.first));
                                                Provider.of<AyaProvider>(
                                                    context,
                                                    listen: false)
                                                    .setDefault();
                                                Provider.of<AyaProvider>(
                                                    context,
                                                    listen: false)
                                                    .getStart(
                                                    int.parse(_list[
                                                    index]
                                                    ['id']),
                                                    int.parse(
                                                        a.first));

                                                // Provider.of<AyaProvider>(context,
                                                //     listen: false)
                                                //     .getPage(439);
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) => SurahScreen(
                                                            a,
                                                            _list[index]
                                                            [
                                                            "id"],
                                                            _list[index]
                                                            [
                                                            "tname"],
                                                            _list[index]
                                                            [
                                                            "ename"],
                                                            0)));
                                              },
                                              child: Container(
                                                width: 400,
                                                height: 100,
                                                decoration:
                                                BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius
                                                        .only(
                                                      topLeft: Radius
                                                          .circular(
                                                          10),
                                                      topRight: Radius
                                                          .circular(
                                                          10),
                                                      bottomLeft:
                                                      Radius.circular(
                                                          10),
                                                      bottomRight:
                                                      Radius.circular(
                                                          10),
                                                    ),
                                                    color: themeProvider
                                                        .isDarkMode
                                                        ? Color(
                                                        0xff67748E)
                                                        : Color.fromRGBO(
                                                        255,
                                                        255,
                                                        255,
                                                        1),
                                                    border: Border
                                                        .all(
                                                      color: themeProvider
                                                          .isDarkMode
                                                          ? Color(
                                                          0xffD2D6DA)
                                                          : Color.fromRGBO(
                                                          231,
                                                          111,
                                                          0,
                                                          1),
                                                      width: 1,
                                                    )),
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                                  children: [
                                                    Container(
                                                        width: 50,
                                                        height: 100,
                                                        decoration:
                                                        BoxDecoration(
                                                          borderRadius:
                                                          BorderRadius
                                                              .only(
                                                            topLeft: Radius
                                                                .circular(
                                                                10),
                                                            topRight:
                                                            Radius.circular(
                                                                10),
                                                            bottomLeft:
                                                            Radius.circular(
                                                                10),
                                                            bottomRight:
                                                            Radius.circular(
                                                                10),
                                                          ),
                                                          color: themeProvider
                                                              .isDarkMode
                                                              ? Color(
                                                              0xff808BA1)
                                                              : Color.fromRGBO(
                                                              255,
                                                              181,
                                                              94,
                                                              1),
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                            '${index + 1}',
                                                            textAlign:
                                                            TextAlign
                                                                .left,
                                                            style: TextStyle(
                                                                fontFamily:
                                                                'Open Sans',
                                                                fontSize:
                                                                24,
                                                                letterSpacing:
                                                                -0.38723403215408325,
                                                                fontWeight: FontWeight
                                                                    .normal,
                                                                height:
                                                                1),
                                                          ),
                                                        )),
                                                    Spacer(),
                                                    Column(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .center,
                                                      children: [
                                                        Text(
                                                          _list[index]
                                                          [
                                                          "tname"],
                                                          textAlign:
                                                          TextAlign
                                                              .left,
                                                          style: TextStyle(
                                                              fontFamily:
                                                              'Open Sans',
                                                              fontSize:
                                                              24,
                                                              letterSpacing:
                                                              -0.38723403215408325,
                                                              fontWeight:
                                                              FontWeight
                                                                  .normal,
                                                              height:
                                                              1),
                                                        ),
                                                        Text(
                                                          _list[index]
                                                          [
                                                          "ename"],
                                                          textAlign:
                                                          TextAlign
                                                              .left,
                                                          style: TextStyle(
                                                              color: Color.fromRGBO(
                                                                  151,
                                                                  151,
                                                                  151,
                                                                  1),
                                                              fontFamily:
                                                              'Open Sans',
                                                              fontSize: MediaQuery.of(context).size.width <
                                                                  600
                                                                  ? 20
                                                                  : 24,
                                                              letterSpacing:
                                                              -0.38723403215408325,
                                                              fontWeight:
                                                              FontWeight
                                                                  .normal,
                                                              height:
                                                              1),
                                                        )
                                                      ],
                                                    ),
                                                    Spacer()
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      )
                                          : SkeletonLoader(
                                        builder: SizedBox(
                                          height: MediaQuery.of(context)
                                              .size
                                              .height *
                                              0.45,
                                          child:
                                          MediaQuery.of(context)
                                              .size
                                              .width >
                                              600
                                              ? GridView.builder(
                                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount:
                                                MediaQuery.of(context)
                                                    .size
                                                    .width <
                                                    1200
                                                    ? 2
                                                    : 3,
                                                crossAxisSpacing:
                                                5.0,
                                                mainAxisSpacing:
                                                5.0,
                                                childAspectRatio:
                                                4),
                                            itemCount: 114,
                                            itemBuilder:
                                                (BuildContext
                                            context,
                                                int index) {
                                              return Padding(
                                                padding: const EdgeInsets
                                                    .symmetric(
                                                    horizontal:
                                                    32.0,
                                                    vertical:
                                                    8),
                                                child:
                                                Container(
                                                  width: 400,
                                                  height: 100,
                                                  decoration:
                                                  BoxDecoration(
                                                      borderRadius: BorderRadius
                                                          .only(
                                                        topLeft:
                                                        Radius.circular(10),
                                                        topRight:
                                                        Radius.circular(10),
                                                        bottomLeft:
                                                        Radius.circular(10),
                                                        bottomRight:
                                                        Radius.circular(10),
                                                      ),
                                                      color: themeProvider.isDarkMode
                                                          ? Color(0xff67748E)
                                                          : Color.fromRGBO(255, 255, 255, 1),
                                                      border: Border.all(
                                                        color: themeProvider.isDarkMode
                                                            ? Color(0xffD2D6DA)
                                                            : Color.fromRGBO(231, 111, 0, 1),
                                                        width:
                                                        1,
                                                      )),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                    children: [
                                                      Container(
                                                          width:
                                                          50,
                                                          height:
                                                          100,
                                                          decoration:
                                                          BoxDecoration(
                                                            borderRadius:
                                                            BorderRadius.only(
                                                              topLeft: Radius.circular(10),
                                                              topRight: Radius.circular(10),
                                                              bottomLeft: Radius.circular(10),
                                                              bottomRight: Radius.circular(10),
                                                            ),
                                                            color: themeProvider.isDarkMode
                                                                ? Color(0xff808BA1)
                                                                : Color.fromRGBO(255, 181, 94, 1),
                                                          ),
                                                          child:
                                                          Center(
                                                            child:
                                                            Text(
                                                              '',
                                                              textAlign: TextAlign.left,
                                                              style: TextStyle(fontFamily: 'Open Sans', fontSize: 24, letterSpacing: -0.38723403215408325, fontWeight: FontWeight.normal, height: 1),
                                                            ),
                                                          )),
                                                      Spacer(),
                                                      Column(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment.center,
                                                        children: const [
                                                          Text(
                                                            '',
                                                            textAlign:
                                                            TextAlign.left,
                                                            style: TextStyle(
                                                                fontFamily: 'Open Sans',
                                                                fontSize: 24,
                                                                letterSpacing: -0.38723403215408325,
                                                                fontWeight: FontWeight.normal,
                                                                height: 1),
                                                          ),
                                                          Text(
                                                            '',
                                                            textAlign:
                                                            TextAlign.left,
                                                            style: TextStyle(
                                                                color: Color.fromRGBO(151, 151, 151, 1),
                                                                fontFamily: 'Open Sans',
                                                                fontSize: 24,
                                                                letterSpacing: -0.38723403215408325,
                                                                fontWeight: FontWeight.normal,
                                                                height: 1),
                                                          )
                                                        ],
                                                      ),
                                                      Spacer()
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          )
                                              : ListView.builder(
                                            itemCount: 114,
                                            itemBuilder:
                                                (BuildContext
                                            context,
                                                int index) {
                                              return Padding(
                                                padding: const EdgeInsets
                                                    .symmetric(
                                                    horizontal:
                                                    8.0,
                                                    vertical:
                                                    8),
                                                child: InkWell(
                                                  child:
                                                  Container(
                                                    width: 400,
                                                    height: 100,
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.only(
                                                          topLeft:
                                                          Radius.circular(10),
                                                          topRight:
                                                          Radius.circular(10),
                                                          bottomLeft:
                                                          Radius.circular(10),
                                                          bottomRight:
                                                          Radius.circular(10),
                                                        ),
                                                        color: themeProvider.isDarkMode ? Color(0xff67748E) : Color.fromRGBO(255, 255, 255, 1),
                                                        border: Border.all(
                                                          color: themeProvider.isDarkMode
                                                              ? Color(0xffD2D6DA)
                                                              : Color.fromRGBO(231, 111, 0, 1),
                                                          width:
                                                          1,
                                                        )),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                      children: [
                                                        Container(
                                                            width:
                                                            50,
                                                            height:
                                                            100,
                                                            decoration:
                                                            BoxDecoration(
                                                              borderRadius: BorderRadius.only(
                                                                topLeft: Radius.circular(10),
                                                                topRight: Radius.circular(10),
                                                                bottomLeft: Radius.circular(10),
                                                                bottomRight: Radius.circular(10),
                                                              ),
                                                              color: themeProvider.isDarkMode ? Color(0xff808BA1) : Color.fromRGBO(255, 181, 94, 1),
                                                            ),
                                                            child:
                                                            Center(
                                                              child: Text(
                                                                '',
                                                                textAlign: TextAlign.left,
                                                                style: TextStyle(fontFamily: 'Open Sans', fontSize: 24, letterSpacing: -0.38723403215408325, fontWeight: FontWeight.normal, height: 1),
                                                              ),
                                                            )),
                                                        Spacer(),
                                                        Column(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment.center,
                                                          children: [
                                                            Text(
                                                              '',
                                                              textAlign: TextAlign.left,
                                                              style: TextStyle(fontFamily: 'Open Sans', fontSize: 24, letterSpacing: -0.38723403215408325, fontWeight: FontWeight.normal, height: 1),
                                                            ),
                                                            Text(
                                                              '',
                                                              textAlign: TextAlign.left,
                                                              style: TextStyle(color: Color.fromRGBO(151, 151, 151, 1), fontFamily: 'Open Sans', fontSize: MediaQuery.of(context).size.width < 600 ? 20 : 24, letterSpacing: -0.38723403215408325, fontWeight: FontWeight.normal, height: 1),
                                                            )
                                                          ],
                                                        ),
                                                        Spacer()
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                        items: 1,
                                        period: Duration(seconds: 2),
                                        highlightColor:
                                        themeProvider.isDarkMode
                                            ? Colors.grey
                                            : Color(0xffaa9f9f),
                                        direction: SkeletonDirection.rtl,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Expanded(
                                      child: _list.isNotEmpty
                                          ? MediaQuery.of(context).size.width >
                                          600
                                          ? GridView.builder(
                                        controller:
                                        ScrollController(),
                                        gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount:
                                            MediaQuery.of(context)
                                                .size
                                                .width <
                                                1200
                                                ? 2
                                                : 3,
                                            crossAxisSpacing: 5.0,
                                            mainAxisSpacing: 5.0,
                                            childAspectRatio:
                                            4.5),
                                        itemCount: _juzs.length,
                                        itemBuilder:
                                            (BuildContext context,
                                            int index) {
                                          //getJuzsName();
                                          return Padding(
                                            padding: const EdgeInsets
                                                .symmetric(
                                                horizontal: 16.0,
                                                vertical: 8),
                                            child: InkWell(
                                              onTap: () async {

                                                //print(index);
                                                var a =
                                                await getTotalJPage(
                                                    _juzs[index]
                                                    ["id"]);
                                                //var b= await getSPage(_juzs[index]["sura_id"]);
                                                Provider.of<AyaProvider>(
                                                    context,
                                                    listen: false)
                                                    .getPage(
                                                    int.parse(
                                                        a.first));
                                                Provider.of<AyaProvider>(
                                                    context,
                                                    listen: false)
                                                    .setDefault();
                                                Provider.of<AyaProvider>(
                                                    context,
                                                    listen: false)
                                                    .getStart(
                                                    int.parse(_juzs[
                                                    index]
                                                    ['sura_id']),
                                                    int.parse(
                                                        a.first));
                                                //await getSurah();
                                                //await getJuzsName();



                                                // Provider.of<AyaProvider>(context,
                                                //     listen: false)
                                                //     .getPage(439);
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) => JuzScreen(
                                                            a,
                                                            _juzs[
                                                            index]
                                                            ['sura_id'],//juzId[index],
                                                            _juzstName[index],
                                                            _juzseName[index],
                                                            0)));
                                              },
                                              child: Container(
                                                width: 400,
                                                height: 100,
                                                decoration:
                                                BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius
                                                        .only(
                                                      topLeft: Radius
                                                          .circular(
                                                          10),
                                                      topRight: Radius
                                                          .circular(
                                                          10),
                                                      bottomLeft:
                                                      Radius.circular(
                                                          10),
                                                      bottomRight:
                                                      Radius.circular(
                                                          10),
                                                    ),
                                                    color: themeProvider
                                                        .isDarkMode
                                                        ? Color(
                                                        0xff67748E)
                                                        : Color.fromRGBO(
                                                        255,
                                                        255,
                                                        255,
                                                        1),
                                                    border: Border
                                                        .all(
                                                      color: themeProvider
                                                          .isDarkMode
                                                          ? Color(
                                                          0xffD2D6DA)
                                                          : Color.fromRGBO(
                                                          231,
                                                          111,
                                                          0,
                                                          1),
                                                      width: 1,
                                                    )),
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                                  children: [
                                                    Container(
                                                        width: 50,
                                                        height: 100,
                                                        decoration:
                                                        BoxDecoration(
                                                          borderRadius:
                                                          BorderRadius
                                                              .only(
                                                            topLeft: Radius
                                                                .circular(
                                                                10),
                                                            topRight:
                                                            Radius.circular(
                                                                10),
                                                            bottomLeft:
                                                            Radius.circular(
                                                                10),
                                                            bottomRight:
                                                            Radius.circular(
                                                                10),
                                                          ),
                                                          color: themeProvider
                                                              .isDarkMode
                                                              ? Color(
                                                              0xff808BA1)
                                                              : Color.fromRGBO(
                                                              255,
                                                              181,
                                                              94,
                                                              1),
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                            '${index + 1}',
                                                            textAlign:
                                                            TextAlign
                                                                .left,
                                                            style: TextStyle(
                                                                fontFamily:
                                                                'Open Sans',
                                                                fontSize:
                                                                24,
                                                                letterSpacing:
                                                                -0.38723403215408325,
                                                                fontWeight: FontWeight
                                                                    .normal,
                                                                height:
                                                                1),
                                                          ),
                                                        )),
                                                    Spacer(),
                                                    Column(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .center,
                                                      children: [
                                                        Text(
                                                          _juzstName[index],
                                                          textAlign:
                                                          TextAlign
                                                              .left,
                                                          style: TextStyle(
                                                              fontFamily:
                                                              'Open Sans',
                                                              fontSize:
                                                              24,
                                                              letterSpacing:
                                                              -0.38723403215408325,
                                                              fontWeight:
                                                              FontWeight
                                                                  .normal,
                                                              height:
                                                              1),
                                                        ),
                                                        Text(
                                                          _juzseName[index],
                                                          textAlign:
                                                          TextAlign
                                                              .left,
                                                          style: TextStyle(
                                                              color: Color.fromRGBO(
                                                                  151,
                                                                  151,
                                                                  151,
                                                                  1),
                                                              fontFamily:
                                                              'Open Sans',
                                                              fontSize:
                                                              22,
                                                              letterSpacing:
                                                              -0.38723403215408325,
                                                              fontWeight:
                                                              FontWeight
                                                                  .normal,
                                                              height:
                                                              1),
                                                        )
                                                      ],
                                                    ),
                                                    Spacer()
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      )
                                          : ListView.builder(
                                        itemCount: 30,
                                        itemBuilder:
                                            (BuildContext context,
                                            int index) {
                                          return Padding(
                                            padding: const EdgeInsets
                                                .symmetric(
                                                horizontal: 8.0,
                                                vertical: 8),
                                            child: InkWell(
                                              onTap: () async {
                                                //await getJuzsName(_juzs[index]["sura_id"]);
                                                var a =
                                                await getTotalJPage(
                                                    _juzs[index]
                                                    ["id"]);
                                                Provider.of<AyaProvider>(
                                                    context,
                                                    listen: false)
                                                    .getPage(
                                                    int.parse(
                                                        a.first));
                                                Provider.of<AyaProvider>(
                                                    context,
                                                    listen: false)
                                                    .setDefault();
                                                Provider.of<AyaProvider>(
                                                    context,
                                                    listen: false)
                                                    .getStart(
                                                    int.parse(_juzs[
                                                    index]
                                                    ['sura_id']),
                                                    int.parse(
                                                        a.first));

                                                // Provider.of<AyaProvider>(context,
                                                //     listen: false)
                                                //     .getPage(439);
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) => SurahScreen(
                                                            a,
                                                            _juzs[index]
                                                            [
                                                            "sura_id"],
                                                            _juzsName[index]
                                                            [
                                                            "tname"],
                                                            _juzsName[index]
                                                            [
                                                            "ename"],
                                                            0)));
                                              },
                                              child: Container(
                                                width: 400,
                                                height: 100,
                                                decoration:
                                                BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius
                                                        .only(
                                                      topLeft: Radius
                                                          .circular(
                                                          10),
                                                      topRight: Radius
                                                          .circular(
                                                          10),
                                                      bottomLeft:
                                                      Radius.circular(
                                                          10),
                                                      bottomRight:
                                                      Radius.circular(
                                                          10),
                                                    ),
                                                    color: themeProvider
                                                        .isDarkMode
                                                        ? Color(
                                                        0xff67748E)
                                                        : Color.fromRGBO(
                                                        255,
                                                        255,
                                                        255,
                                                        1),
                                                    border: Border
                                                        .all(
                                                      color: themeProvider
                                                          .isDarkMode
                                                          ? Color(
                                                          0xffD2D6DA)
                                                          : Color.fromRGBO(
                                                          231,
                                                          111,
                                                          0,
                                                          1),
                                                      width: 1,
                                                    )),
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                                  children: [
                                                    Container(
                                                        width: 50,
                                                        height: 100,
                                                        decoration:
                                                        BoxDecoration(
                                                          borderRadius:
                                                          BorderRadius
                                                              .only(
                                                            topLeft: Radius
                                                                .circular(
                                                                10),
                                                            topRight:
                                                            Radius.circular(
                                                                10),
                                                            bottomLeft:
                                                            Radius.circular(
                                                                10),
                                                            bottomRight:
                                                            Radius.circular(
                                                                10),
                                                          ),
                                                          color: themeProvider
                                                              .isDarkMode
                                                              ? Color(
                                                              0xff808BA1)
                                                              : Color.fromRGBO(
                                                              255,
                                                              181,
                                                              94,
                                                              1),
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                            '${index + 1}',
                                                            textAlign:
                                                            TextAlign
                                                                .left,
                                                            style: TextStyle(
                                                                fontFamily:
                                                                'Open Sans',
                                                                fontSize:
                                                                24,
                                                                letterSpacing:
                                                                -0.38723403215408325,
                                                                fontWeight: FontWeight
                                                                    .normal,
                                                                height:
                                                                1),
                                                          ),
                                                        )),
                                                    Spacer(),
                                                    Column(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .center,
                                                      children: [
                                                        Text(
                                                          _list[index]
                                                          [
                                                          "tname"],
                                                          textAlign:
                                                          TextAlign
                                                              .left,
                                                          style: TextStyle(
                                                              fontFamily:
                                                              'Open Sans',
                                                              fontSize:
                                                              24,
                                                              letterSpacing:
                                                              -0.38723403215408325,
                                                              fontWeight:
                                                              FontWeight
                                                                  .normal,
                                                              height:
                                                              1),
                                                        ),
                                                        Text(
                                                          _list[index]
                                                          [
                                                          "ename"],
                                                          textAlign:
                                                          TextAlign
                                                              .left,
                                                          style: TextStyle(
                                                              color: Color.fromRGBO(
                                                                  151,
                                                                  151,
                                                                  151,
                                                                  1),
                                                              fontFamily:
                                                              'Open Sans',
                                                              fontSize: MediaQuery.of(context).size.width <
                                                                  600
                                                                  ? 20
                                                                  : 24,
                                                              letterSpacing:
                                                              -0.38723403215408325,
                                                              fontWeight:
                                                              FontWeight
                                                                  .normal,
                                                              height:
                                                              1),
                                                        )
                                                      ],
                                                    ),
                                                    Spacer()
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      )
                                          : SkeletonLoader(
                                        builder: SizedBox(
                                          height: MediaQuery.of(context)
                                              .size
                                              .height *
                                              0.5,
                                          child: GridView.builder(
                                            gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount:
                                                MediaQuery.of(context)
                                                    .size
                                                    .width <
                                                    1200
                                                    ? 2
                                                    : 3,
                                                crossAxisSpacing: 5.0,
                                                mainAxisSpacing: 5.0,
                                                childAspectRatio: 4),
                                            itemCount: 30,
                                            itemBuilder:
                                                (BuildContext context,
                                                int index) {
                                              return Padding(
                                                padding: const EdgeInsets
                                                    .symmetric(
                                                    horizontal: 32.0,
                                                    vertical: 8),
                                                child: Container(
                                                  width: 400,
                                                  height: 100,
                                                  decoration:
                                                  BoxDecoration(
                                                      borderRadius:
                                                      BorderRadius
                                                          .only(
                                                        topLeft: Radius
                                                            .circular(
                                                            10),
                                                        topRight: Radius
                                                            .circular(
                                                            10),
                                                        bottomLeft: Radius
                                                            .circular(
                                                            10),
                                                        bottomRight: Radius
                                                            .circular(
                                                            10),
                                                      ),
                                                      color: themeProvider
                                                          .isDarkMode
                                                          ? Color(
                                                          0xff67748E)
                                                          : Color
                                                          .fromRGBO(
                                                          255,
                                                          255,
                                                          255,
                                                          1),
                                                      border:
                                                      Border.all(
                                                        color: themeProvider
                                                            .isDarkMode
                                                            ? Color(
                                                            0xffD2D6DA)
                                                            : Color.fromRGBO(
                                                            231,
                                                            111,
                                                            0,
                                                            1),
                                                        width: 1,
                                                      )),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                    children: [
                                                      Container(
                                                          width: 50,
                                                          height: 100,
                                                          decoration:
                                                          BoxDecoration(
                                                            borderRadius:
                                                            BorderRadius
                                                                .only(
                                                              topLeft: Radius
                                                                  .circular(
                                                                  10),
                                                              topRight: Radius
                                                                  .circular(
                                                                  10),
                                                              bottomLeft:
                                                              Radius.circular(
                                                                  10),
                                                              bottomRight:
                                                              Radius.circular(
                                                                  10),
                                                            ),
                                                            color: themeProvider
                                                                .isDarkMode
                                                                ? Color(
                                                                0xff808BA1)
                                                                : Color.fromRGBO(
                                                                255,
                                                                181,
                                                                94,
                                                                1),
                                                          ),
                                                          child: Center(
                                                            child: Text(
                                                              '',
                                                              textAlign:
                                                              TextAlign
                                                                  .left,
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                  'Open Sans',
                                                                  fontSize:
                                                                  24,
                                                                  letterSpacing:
                                                                  -0.38723403215408325,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                                  height:
                                                                  1),
                                                            ),
                                                          )),
                                                      Spacer(),
                                                      Column(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                        children: const [
                                                          Text(
                                                            '',
                                                            textAlign:
                                                            TextAlign
                                                                .left,
                                                            style: TextStyle(
                                                                fontFamily:
                                                                'Open Sans',
                                                                fontSize:
                                                                24,
                                                                letterSpacing:
                                                                -0.38723403215408325,
                                                                fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                                height:
                                                                1),
                                                          ),
                                                          Text(
                                                            '',
                                                            textAlign:
                                                            TextAlign
                                                                .left,
                                                            style: TextStyle(
                                                                color: Color.fromRGBO(
                                                                    151,
                                                                    151,
                                                                    151,
                                                                    1),
                                                                fontFamily:
                                                                'Open Sans',
                                                                fontSize:
                                                                24,
                                                                letterSpacing:
                                                                -0.38723403215408325,
                                                                fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                                height:
                                                                1),
                                                          )
                                                        ],
                                                      ),
                                                      Spacer()
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                        items: 1,
                                        period: Duration(seconds: 2),
                                        highlightColor:
                                        themeProvider.isDarkMode
                                            ? Colors.grey
                                            : Color(0xffaa9f9f),
                                        direction: SkeletonDirection.rtl,
                                      ),
                                    ),
                                  ],
                                ),
                              ]),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }

  List _total = [];

  final CollectionReference _collectionSura =
  FirebaseFirestore.instance.collection('sura_relationships');

  Future<List> getTotalPage(String id) async {
    QuerySnapshot querySnapshot = await _collectionSura
        .where('sura_id', isEqualTo: id)
        .orderBy('created_at')
        .get();

    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    setState(() {
      _total = allData;
      //print(allData);
    });
    var data = _total.map((e) => e["medina_mushaf_page_id"]).toList();
    //print(data);
    //print(_total);
    return data;
  }

  List _list = [];
  final CollectionReference _collectionRef =
  FirebaseFirestore.instance.collection('suras');

  Future<void> getList() async {
    await Provider.of<BookMarkProvider>(context, listen: false).getList();

    // Get docs from collection reference
    QuerySnapshot querySnapshot =
    await _collectionRef.orderBy('created_at').get();

    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    setState(() {
      _list = allData;
    });
  }

  List _totalJuzs = [];

  final CollectionReference _collectionJ =
  FirebaseFirestore.instance.collection('medina_mushaf_pages');

  Future<List> getTotalJPage(String id) async {
    QuerySnapshot querySnapshot = await _collectionJ
        .where('juz_id', isEqualTo: id)
    //.where('sura_id',isEqualTo: sura_id)
        .orderBy('created_at')
        .get();

    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    setState(() {
      _totalJuzs = allData;
      //print(allData.length);
    });
    var data = _totalJuzs.map((e) => e['id']).toList();
    //print(_totalJuzs);
    return data;
  }

  List _juzs = [];
  final CollectionReference _collectionJuzs =
  FirebaseFirestore.instance.collection('juzs');

  Future<void> getJuzs() async {
    await Provider.of<BookMarkProvider>(context, listen: false).getList();

    // Get docs from collection reference
    QuerySnapshot querySnapshot =
    await _collectionJuzs.orderBy('created_at').get();

    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    setState(() {
      _juzs = allData;
      //print(allData.first);
    });
  }


  List _juzstName = ["Al-Faatiha","Al-Baqara","Al-Baqara","Aal-i-Imraan","An-Nisaa","An-Nisaa","Al-Maaida","Al-An'aam",
    "Al-A'raaf","Al-Anfaal","At-Tawba","Hud","Yusuf","Al-Hijr","Al-Israa","Al-Kahf","Al-Anbiyaa","Al-Muminoon",
    "Al-Furqaan","An-Naml","Al-Ankaboot","Al-Ahzaab","Yaseen","Az-Zumar","Fussilat","Al-Ahqaf","Adh-Dhaariyat",
    "Al-Mujaadila","Al-Mulk","An-Naba"];
  List _juzseName = ["The Opening","The Cow", "The Cow", "The Family of Imraan", "The Women", "The Women", "The Table", "The Cattle", "The Heights",
    "The Spoils of War", "The Repentance", "Hud", "Joseph", "The Rock", "The Night Journey", "The Cave", "The Prophets", "The Believers",
    "The Criterion", "The Ant", "The Spider", "The Clans", "Yaseen", "The Groups", "Explained in detail", "The Dunes", "The Winnowing Winds",
    "The Pleading Woman", "The Sovereignty", "The Announcement"];


  int i=0;
  List sId=[];
  List name=[];
  List detail=[];
  Future<void> getSurah() async {
    List s=[];
    for( i = 0; i < _totalJuzs.length; i++) {
      // Get docs from collection reference
      await _collectionJ
          .where('id', isEqualTo: _totalJuzs[i]["id"])
      // .where('sura_id', isEqualTo: widget.sura_id)
          .orderBy('created_at')
          .get()
          .then((QuerySnapshot querySnapshot) {
        for (var doc in querySnapshot.docs) {
          setState(() {
            s.add(doc['sura_id']);
            //widget.sura_id = int.parse(doc['sura_id']) as String;
          });
        }
        setState(() {
          sId = s;
          //print(sId);
        });
      });}
    List t = [];
    List e = [];
    for( int j = 0; j < sId.length; j++) {
      await _collectionRef
          .where('id', isEqualTo: sId[j])
      // .where('sura_id', isEqualTo: widget.sura_id)
          .orderBy('created_at')
          .get()
          .then((QuerySnapshot querySnapshot) {
        for (var doc in querySnapshot.docs) {
          setState(() {
            t.add(doc['tname']);
            e.add(doc['ename']);
            //widget.sura_id = int.parse(doc['sura_id']) as String;
          });
        }
        setState(() {
          name = t;
          detail = e;
          //print(name);
        });
      });
    }
  }
  List juzId=[];
  List tname=[];
  List ename=[];

  Future<void> getJuzsName() async {
    List s=[];
    List t = [];
    List e = [];
    for( int k = 0; k < _juzs.length; k++) {
      // Get docs from collection reference
      await _collectionRef
          .where('id', isEqualTo: _juzs[k]["sura_id"])
      // .where('sura_id', isEqualTo: widget.sura_id)
          .orderBy('created_at')
          .get()
          .then((QuerySnapshot querySnapshot) {
        for (var doc in querySnapshot.docs) {
          setState(() {
            s.add(doc['id']);
            t.add(doc['tname']);
            e.add(doc['ename']);
            //widget.sura_id = int.parse(doc['sura_id']) as String;
          });
        }
        setState(() {
          juzId = s;
          tname = t;
          ename = e;
          //print(ename);
        });
      });}
  }

  List sura=[];
  Future<List> getSPage(String id) async {
    QuerySnapshot querySnapshot = await _collectionSura
        .where('sura_id', isEqualTo: id)
        .orderBy('created_at')
        .get();

    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    setState(() {
      sura = allData;
      //print(allData);
    });
    var data = sura.map((e) => e["sura_id"]).toList();
    //print(data);
    //print(_total);
    return data;
  }


}
/*Future <void> getJuzsName() async {
    await Provider.of<BookMarkProvider>(context, listen: false).getList();
    List j=[];
    for (int count =0; count<= _juzs.length+1; count++){
      //for(int counts =0; counts<= _list.length+1; counts++){
      //if(_list[counts]["id"]==_juzs[count]["sura_id"]){
        _juzsName[count]=_juzs[count]["sura_id"];
      //}//}
    }
    print(_juzsName);
  //for (int count = 0; count <= _juzs.length+1; count++) {
    // Get docs from collection reference
    //QuerySnapshot querySnapshot =
    await _collectionJuzsName
        .where('id', isEqualTo: _juzsName)
        .orderBy('created_at').get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        setState(() {
          j.add(doc['ename']);
          //print(_juzseName);
        });
      }

      setState(() {
        _juzseName = j;
        print(_juzseName);
      });
    });

    // Get data from docs and convert map to List
    //final allData = await querySnapshot.docs.map((doc) => doc.data()).toList();
    /*for (var doc in querySnapshot.docs) {
      _juzstName.add(doc["tname"]);
      //_juzs.add(doc["ename"]);
      setState(() {
        _juzsName = allData;
      });
      //b=_juzstName.map((e) => e["tname"]).toList();
      //_juzseName.map((e) => e["ename"]).toList();
      print(_juzsName);
    } *///return allData;
  //} //return b;*/