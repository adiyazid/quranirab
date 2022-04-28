import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import 'package:provider/provider.dart';
import 'package:quranirab/theme/theme_provider.dart';
import 'package:quranirab/views/surah.screen.dart';
import 'package:skeleton_loader/skeleton_loader.dart';

import 'package:quranirab/provider/ayah.number.provider.dart';
import 'package:quranirab/provider/bookmark.provider.dart';
import 'package:quranirab/widget/LanguagePopup.dart';
import 'package:quranirab/widget/menu.dart';
import 'package:quranirab/widget/search.popup.dart';
import 'package:quranirab/widget/setting.popup.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    getList();
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
    return Scaffold(
        backgroundColor:
            themeProvider.isDarkMode ? Color(0xff666666) : Colors.white,
        drawer: const Menu(),
        body: NestedScrollView(
          physics: BouncingScrollPhysics(),
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
                actions: const [
                  Padding(
                      padding: EdgeInsets.only(right: 20.0),
                      child: SearchPopup()),
                  Padding(
                      padding: EdgeInsets.only(right: 20.0),
                      child: LangPopup()),
                  Padding(
                      padding: EdgeInsets.only(right: 20.0),
                      child: SettingPopup()),
                ],
              ),
            ];
          },
          body: Center(
              child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: 1024,
                  decoration: BoxDecoration(
                    color: themeProvider.isDarkMode
                        ? Color(0xff666666)
                        : Color.fromRGBO(255, 255, 255, 1),
                  ),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        ///todo:top container
                        Container(
                            alignment: Alignment.topLeft,
                            width: MediaQuery.of(context).size.width < 600
                                ? MediaQuery.of(context).size.width * 0.8
                                : MediaQuery.of(context).size.width * 0.85,
                            height: MediaQuery.of(context).size.height * 0.16,
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
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Consumer<BookMarkProvider>(
                                  builder: (context, bm, child) {
                                if (bm.bookmarkList.isNotEmpty) {
                                  return Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Align(
                                        child: Text(
                                          'Bookmark',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              decoration:
                                                  TextDecoration.underline,
                                              fontFamily: 'Open Sans',
                                              fontSize: MediaQuery.of(context)
                                                          .size
                                                          .width <
                                                      600
                                                  ? 20
                                                  : 24,
                                              letterSpacing:
                                                  -0.38723403215408325,
                                              fontWeight: FontWeight.normal,
                                              height: 1),
                                        ),
                                        alignment: Alignment.topLeft,
                                      ),
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.1,
                                          child: ListView.builder(
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              if (index ==
                                                  bm.bookmarkList.length) {
                                                return IconButton(
                                                  onPressed: () => bm.deleteAll(),
                                                  icon:
                                                      Icon(Icons.delete_sharp),
                                                );
                                              }
                                              return InkWell(
                                                onTap: () async {
                                                  var a = await getTotalPage(bm
                                                      .bookmarkList[index]
                                                      .suraId!);
                                                  Provider.of<AyaProvider>(
                                                          context,
                                                          listen: false)
                                                      .getPage(int.parse(bm
                                                          .bookmarkList[index]
                                                          .pages!
                                                          .first));
                                                  Provider.of<AyaProvider>(
                                                          context,
                                                          listen: false)
                                                      .setDefault();
                                                  Provider.of<AyaProvider>(
                                                          context,
                                                          listen: false)
                                                      .getStart(
                                                          int.parse(bm
                                                              .bookmarkList[
                                                                  index]
                                                              .suraId!),
                                                          int.parse(bm
                                                              .bookmarkList[
                                                                  index]
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
                                                                bm
                                                                    .bookmarkList[
                                                                        index]
                                                                    .suraId!,
                                                                bm
                                                                    .bookmarkList[
                                                                        index]
                                                                    .tname!,
                                                                bm
                                                                    .bookmarkList[
                                                                        index]
                                                                    .ename!,
                                                                a.indexOf(bm
                                                                    .bookmarkList[
                                                                        index]
                                                                    .pages!
                                                                    .first),
                                                              )));
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 16.0),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(10),
                                                        topRight:
                                                            Radius.circular(10),
                                                        bottomLeft:
                                                            Radius.circular(10),
                                                        bottomRight:
                                                            Radius.circular(10),
                                                      ),
                                                      color: themeProvider
                                                              .isDarkMode
                                                          ? Color(0xff67748E)
                                                          : Color.fromRGBO(
                                                              255, 255, 255, 1),
                                                      border: Border.all(
                                                        color: themeProvider
                                                                .isDarkMode
                                                            ? Color(0xffD2D6DA)
                                                            : Color.fromRGBO(
                                                                231, 111, 0, 1),
                                                        width: 1,
                                                      ),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              16.0),
                                                      child: Center(
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceAround,
                                                          children: [
                                                            Text(
                                                              bm
                                                                  .bookmarkList[
                                                                      index]
                                                                  .tname!,
                                                              style: TextStyle(
                                                                  fontSize: 22),
                                                            ),
                                                            Container(
                                                              width: 75,
                                                              height: 25,
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
                                                                    ? Color
                                                                        .fromRGBO(
                                                                            128,
                                                                            138,
                                                                            177,
                                                                            1)
                                                                    : Color(
                                                                        0xffFFB55F),
                                                                border:
                                                                    Border.all(
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
                                                                    .bookmarkList[
                                                                        index]
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
                                            itemCount:
                                                bm.bookmarkList.length + 1,
                                          )),
                                    ],
                                  );
                                }
                                return Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Align(
                                      child: Text(
                                        'Bookmark',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            decoration:
                                                TextDecoration.underline,
                                            fontFamily: 'Open Sans',
                                            fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width <
                                                    600
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
                                            fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width <
                                                    600
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

                        ///todo:bottom container
                        Container(
                          width: MediaQuery.of(context).size.width < 600
                              ? MediaQuery.of(context).size.width * 0.8
                              : MediaQuery.of(context).size.width * 0.85,
                          height: MediaQuery.of(context).size.height * 0.7,
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
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
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
                                              letterSpacing:
                                                  -0.38723403215408325,
                                              fontWeight: FontWeight.normal,
                                              height: 1),
                                        ),
                                        Text(
                                          'Juz',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontFamily: 'Open Sans',
                                              fontSize: 24,
                                              letterSpacing:
                                                  -0.38723403215408325,
                                              fontWeight: FontWeight.normal,
                                              height: 1),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.63,
                                  child: TabBarView(
                                      controller: _tabController,
                                      children: [
                                        SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.63,
                                            child: _list.isNotEmpty
                                                ? MediaQuery.of(context)
                                                            .size
                                                            .width >
                                                        600
                                                    ? GridView.builder(
                                                        controller:
                                                            ScrollController(),
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
                                                                4.5),
                                                        itemCount: 114,
                                                        itemBuilder:
                                                            (BuildContext
                                                                    context,
                                                                int index) {
                                                          return Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        16.0,
                                                                    vertical:
                                                                        8),
                                                            child: InkWell(
                                                              onTap: () async {
                                                                var a = await getTotalPage(
                                                                    _list[index]
                                                                        ["id"]);
                                                                Provider.of<AyaProvider>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .getPage(int
                                                                        .parse(a
                                                                            .first));
                                                                Provider.of<AyaProvider>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .setDefault();
                                                                Provider.of<AyaProvider>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .getStart(
                                                                        int.parse(_list[index]
                                                                            [
                                                                            'id']),
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
                                                                            _list[index]["id"],
                                                                            _list[index]["tname"],
                                                                            _list[index]["ename"],
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
                                                                            ? Color(
                                                                                0xff67748E)
                                                                            : Color.fromRGBO(
                                                                                255,
                                                                                255,
                                                                                255,
                                                                                1),
                                                                        border:
                                                                            Border.all(
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
                                                                              ? Color(0xff808BA1)
                                                                              : Color.fromRGBO(255, 181, 94, 1),
                                                                        ),
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              Text(
                                                                            '${index + 1}',
                                                                            textAlign:
                                                                                TextAlign.left,
                                                                            style: TextStyle(
                                                                                fontFamily: 'Open Sans',
                                                                                fontSize: 24,
                                                                                letterSpacing: -0.38723403215408325,
                                                                                fontWeight: FontWeight.normal,
                                                                                height: 1),
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
                                                                              TextAlign.left,
                                                                          style: TextStyle(
                                                                              fontFamily: 'Open Sans',
                                                                              fontSize: 24,
                                                                              letterSpacing: -0.38723403215408325,
                                                                              fontWeight: FontWeight.normal,
                                                                              height: 1),
                                                                        ),
                                                                        Text(
                                                                          _list[index]
                                                                              [
                                                                              "ename"],
                                                                          textAlign:
                                                                              TextAlign.left,
                                                                          style: TextStyle(
                                                                              color: Color.fromRGBO(151, 151, 151, 1),
                                                                              fontFamily: 'Open Sans',
                                                                              fontSize: 22,
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
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        8.0,
                                                                    vertical:
                                                                        8),
                                                            child: InkWell(
                                                              onTap: () async {
                                                                var a = await getTotalPage(
                                                                    _list[index]
                                                                        ["id"]);
                                                                Provider.of<AyaProvider>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .getPage(int
                                                                        .parse(a
                                                                            .first));
                                                                Provider.of<AyaProvider>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .setDefault();
                                                                Provider.of<AyaProvider>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .getStart(
                                                                        int.parse(_list[index]
                                                                            [
                                                                            'id']),
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
                                                                            _list[index]["id"],
                                                                            _list[index]["tname"],
                                                                            _list[index]["ename"],
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
                                                                            ? Color(
                                                                                0xff67748E)
                                                                            : Color.fromRGBO(
                                                                                255,
                                                                                255,
                                                                                255,
                                                                                1),
                                                                        border:
                                                                            Border.all(
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
                                                                              ? Color(0xff808BA1)
                                                                              : Color.fromRGBO(255, 181, 94, 1),
                                                                        ),
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              Text(
                                                                            '${index + 1}',
                                                                            textAlign:
                                                                                TextAlign.left,
                                                                            style: TextStyle(
                                                                                fontFamily: 'Open Sans',
                                                                                fontSize: 24,
                                                                                letterSpacing: -0.38723403215408325,
                                                                                fontWeight: FontWeight.normal,
                                                                                height: 1),
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
                                                                              TextAlign.left,
                                                                          style: TextStyle(
                                                                              fontFamily: 'Open Sans',
                                                                              fontSize: 24,
                                                                              letterSpacing: -0.38723403215408325,
                                                                              fontWeight: FontWeight.normal,
                                                                              height: 1),
                                                                        ),
                                                                        Text(
                                                                          _list[index]
                                                                              [
                                                                              "ename"],
                                                                          textAlign:
                                                                              TextAlign.left,
                                                                          style: TextStyle(
                                                                              color: Color.fromRGBO(151, 151, 151, 1),
                                                                              fontFamily: 'Open Sans',
                                                                              fontSize: MediaQuery.of(context).size.width < 600 ? 20 : 24,
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
                                                            ),
                                                          );
                                                        },
                                                      )
                                                : SkeletonLoader(
                                                    builder: SizedBox(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.63,
                                                      child: MediaQuery.of(context)
                                                          .size
                                                          .width >
                                                          600 ?GridView.builder(
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
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        32.0,
                                                                    vertical:
                                                                        8),
                                                            child: Container(
                                                              width: 400,
                                                              height: 100,
                                                              decoration:
                                                                  BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius
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
                                                                      color: themeProvider
                                                                              .isDarkMode
                                                                          ? Color(
                                                                              0xff67748E)
                                                                          : Color.fromRGBO(
                                                                              255,
                                                                              255,
                                                                              255,
                                                                              1),
                                                                      border:
                                                                          Border
                                                                              .all(
                                                                        color: themeProvider.isDarkMode
                                                                            ? Color(
                                                                                0xffD2D6DA)
                                                                            : Color.fromRGBO(
                                                                                231,
                                                                                111,
                                                                                0,
                                                                                1),
                                                                        width:
                                                                            1,
                                                                      )),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Container(
                                                                      width: 50,
                                                                      height:
                                                                          100,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.only(
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
                                                                            ? Color(
                                                                                0xff808BA1)
                                                                            : Color.fromRGBO(
                                                                                255,
                                                                                181,
                                                                                94,
                                                                                1),
                                                                      ),
                                                                      child:
                                                                          Center(
                                                                        child:
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
                                                                            TextAlign.left,
                                                                        style: TextStyle(
                                                                            fontFamily:
                                                                                'Open Sans',
                                                                            fontSize:
                                                                                24,
                                                                            letterSpacing:
                                                                                -0.38723403215408325,
                                                                            fontWeight:
                                                                                FontWeight.normal,
                                                                            height: 1),
                                                                      ),
                                                                      Text(
                                                                        '',
                                                                        textAlign:
                                                                            TextAlign.left,
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
                                                                                FontWeight.normal,
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
                                                      ): ListView.builder(
                                                        itemCount: 114,
                                                        itemBuilder:
                                                            (BuildContext
                                                        context,
                                                            int index) {
                                                          return Padding(
                                                            padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal:
                                                                8.0,
                                                                vertical:
                                                                8),
                                                            child: InkWell(
                                                              child: Container(
                                                                width: 400,
                                                                height: 100,
                                                                decoration:
                                                                BoxDecoration(
                                                                    borderRadius:
                                                                    BorderRadius
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
                                                                        ? Color(
                                                                        0xff67748E)
                                                                        : Color.fromRGBO(
                                                                        255,
                                                                        255,
                                                                        255,
                                                                        1),
                                                                    border:
                                                                    Border.all(
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
                                                                              ? Color(0xff808BA1)
                                                                              : Color.fromRGBO(255, 181, 94, 1),
                                                                        ),
                                                                        child:
                                                                        Center(
                                                                          child:
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
                                                                        )),
                                                                    Spacer(),
                                                                    Column(
                                                                      mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                      children: [
                                                                        Text('',
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
                                                                              fontSize: MediaQuery.of(context).size.width < 600 ? 20 : 24,
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
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                    items: 1,
                                                    period:
                                                        Duration(seconds: 2),
                                                    highlightColor:
                                                        themeProvider.isDarkMode
                                                            ? Colors.grey
                                                            : Color(0xffaa9f9f),
                                                    direction:
                                                        SkeletonDirection.rtl,
                                                  )),
                                        SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.63,
                                            child: _list.isNotEmpty
                                                ? MediaQuery.of(context)
                                                            .size
                                                            .width >
                                                        600
                                                    ? GridView.builder(
                                                        controller:
                                                            ScrollController(),
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
                                                                4.5),
                                                        itemCount: 30,
                                                        itemBuilder:
                                                            (BuildContext
                                                                    context,
                                                                int index) {
                                                          return Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        16.0,
                                                                    vertical:
                                                                        8),
                                                            child: InkWell(
                                                              onTap: () async {
                                                                var a = await getTotalPage(
                                                                    _list[index]
                                                                        ["id"]);
                                                                Provider.of<AyaProvider>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .getPage(int
                                                                        .parse(a
                                                                            .first));
                                                                Provider.of<AyaProvider>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .setDefault();
                                                                Provider.of<AyaProvider>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .getStart(
                                                                        int.parse(_list[index]
                                                                            [
                                                                            'id']),
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
                                                                            _list[index]["id"],
                                                                            _list[index]["tname"],
                                                                            _list[index]["ename"],
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
                                                                            ? Color(
                                                                                0xff67748E)
                                                                            : Color.fromRGBO(
                                                                                255,
                                                                                255,
                                                                                255,
                                                                                1),
                                                                        border:
                                                                            Border.all(
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
                                                                              ? Color(0xff808BA1)
                                                                              : Color.fromRGBO(255, 181, 94, 1),
                                                                        ),
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              Text(
                                                                            '${index + 1}',
                                                                            textAlign:
                                                                                TextAlign.left,
                                                                            style: TextStyle(
                                                                                fontFamily: 'Open Sans',
                                                                                fontSize: 24,
                                                                                letterSpacing: -0.38723403215408325,
                                                                                fontWeight: FontWeight.normal,
                                                                                height: 1),
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
                                                                              TextAlign.left,
                                                                          style: TextStyle(
                                                                              fontFamily: 'Open Sans',
                                                                              fontSize: 24,
                                                                              letterSpacing: -0.38723403215408325,
                                                                              fontWeight: FontWeight.normal,
                                                                              height: 1),
                                                                        ),
                                                                        Text(
                                                                          _list[index]
                                                                              [
                                                                              "ename"],
                                                                          textAlign:
                                                                              TextAlign.left,
                                                                          style: TextStyle(
                                                                              color: Color.fromRGBO(151, 151, 151, 1),
                                                                              fontFamily: 'Open Sans',
                                                                              fontSize: 22,
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
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        8.0,
                                                                    vertical:
                                                                        8),
                                                            child: InkWell(
                                                              onTap: () async {
                                                                var a = await getTotalPage(
                                                                    _list[index]
                                                                        ["id"]);
                                                                Provider.of<AyaProvider>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .getPage(int
                                                                        .parse(a
                                                                            .first));
                                                                Provider.of<AyaProvider>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .setDefault();
                                                                Provider.of<AyaProvider>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .getStart(
                                                                        int.parse(_list[index]
                                                                            [
                                                                            'id']),
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
                                                                            _list[index]["id"],
                                                                            _list[index]["tname"],
                                                                            _list[index]["ename"],
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
                                                                            ? Color(
                                                                                0xff67748E)
                                                                            : Color.fromRGBO(
                                                                                255,
                                                                                255,
                                                                                255,
                                                                                1),
                                                                        border:
                                                                            Border.all(
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
                                                                              ? Color(0xff808BA1)
                                                                              : Color.fromRGBO(255, 181, 94, 1),
                                                                        ),
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              Text(
                                                                            '${index + 1}',
                                                                            textAlign:
                                                                                TextAlign.left,
                                                                            style: TextStyle(
                                                                                fontFamily: 'Open Sans',
                                                                                fontSize: 24,
                                                                                letterSpacing: -0.38723403215408325,
                                                                                fontWeight: FontWeight.normal,
                                                                                height: 1),
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
                                                                              TextAlign.left,
                                                                          style: TextStyle(
                                                                              fontFamily: 'Open Sans',
                                                                              fontSize: 24,
                                                                              letterSpacing: -0.38723403215408325,
                                                                              fontWeight: FontWeight.normal,
                                                                              height: 1),
                                                                        ),
                                                                        Text(
                                                                          _list[index]
                                                                              [
                                                                              "ename"],
                                                                          textAlign:
                                                                              TextAlign.left,
                                                                          style: TextStyle(
                                                                              color: Color.fromRGBO(151, 151, 151, 1),
                                                                              fontFamily: 'Open Sans',
                                                                              fontSize: MediaQuery.of(context).size.width < 600 ? 20 : 24,
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
                                                            ),
                                                          );
                                                        },
                                                      )
                                                : SkeletonLoader(
                                                    builder: SizedBox(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.63,
                                                      child: GridView.builder(
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
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        32.0,
                                                                    vertical:
                                                                        8),
                                                            child: Container(
                                                              width: 400,
                                                              height: 100,
                                                              decoration:
                                                                  BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius
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
                                                                      color: themeProvider
                                                                              .isDarkMode
                                                                          ? Color(
                                                                              0xff67748E)
                                                                          : Color.fromRGBO(
                                                                              255,
                                                                              255,
                                                                              255,
                                                                              1),
                                                                      border:
                                                                          Border
                                                                              .all(
                                                                        color: themeProvider.isDarkMode
                                                                            ? Color(
                                                                                0xffD2D6DA)
                                                                            : Color.fromRGBO(
                                                                                231,
                                                                                111,
                                                                                0,
                                                                                1),
                                                                        width:
                                                                            1,
                                                                      )),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Container(
                                                                      width: 50,
                                                                      height:
                                                                          100,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.only(
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
                                                                            ? Color(
                                                                                0xff808BA1)
                                                                            : Color.fromRGBO(
                                                                                255,
                                                                                181,
                                                                                94,
                                                                                1),
                                                                      ),
                                                                      child:
                                                                          Center(
                                                                        child:
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
                                                                            TextAlign.left,
                                                                        style: TextStyle(
                                                                            fontFamily:
                                                                                'Open Sans',
                                                                            fontSize:
                                                                                24,
                                                                            letterSpacing:
                                                                                -0.38723403215408325,
                                                                            fontWeight:
                                                                                FontWeight.normal,
                                                                            height: 1),
                                                                      ),
                                                                      Text(
                                                                        '',
                                                                        textAlign:
                                                                            TextAlign.left,
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
                                                                                FontWeight.normal,
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
                                                      ),
                                                    ),
                                                    items: 1,
                                                    period:
                                                        Duration(seconds: 2),
                                                    highlightColor:
                                                        themeProvider.isDarkMode
                                                            ? Colors.grey
                                                            : Color(0xffaa9f9f),
                                                    direction:
                                                        SkeletonDirection.rtl,
                                                  )),
                                      ]),
                                )
                              ],
                            ),
                          ),
                        ),
                      ]))),
        ));
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
    });
    var data = _total.map((e) => e["medina_mushaf_page_id"]).toList();
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
}
