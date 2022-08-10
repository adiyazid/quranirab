import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:quranirab/provider/ayah.number.provider.dart';
import 'package:quranirab/provider/bookmark.provider.dart';
import 'package:quranirab/provider/user.provider.dart';
import 'package:quranirab/theme/theme_provider.dart';
import 'package:quranirab/views/auth/login.screen.dart';
import 'package:quranirab/views/juz/juz.display.dart';
import 'package:quranirab/views/payment/payment.screen.dart';
import 'package:quranirab/views/surah.screen.dart';
import 'package:quranirab/widget/menu.dart';
import 'package:skeleton_loader/skeleton_loader.dart';

import '../widget/appbar.widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  dynamic snackBar;

  bool checkout = false;

  @override
  void initState() {
    // TODO: implement initState
    Provider.of<AppUser>(context, listen: false).getRole();
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
    snackBar = SnackBar(
        backgroundColor: Colors.tealAccent,
        content: Text(
          Provider.of<AppUser>(context, listen: false).role != 'premium-user'
              ? AppLocalizations.of(context)!.contentLock
              : AppLocalizations.of(context)!.showReceipt,
          style: TextStyle(color: Colors.black),
        ),
        action: SnackBarAction(
          textColor: Colors.black,
          label: AppLocalizations.of(context)!.upgradeNow,
          onPressed: _launchUrl,
        ));
    var themeProvider = Provider.of<ThemeProvider>(context);
    // Figma Flutter Generator Desktop31Widget - FRAME
    return SafeArea(
      child: Scaffold(
          backgroundColor:
              themeProvider.isDarkMode ? Color(0xff666666) : Colors.white,
          drawer: const Menu(),
          body: Consumer<AppUser>(builder: (context, user, child) {
            if (user.user != null) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
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
                    SizedBox(
                      height: 32,
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
                                        AppLocalizations.of(context)!.bookmark,
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
                                    SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.15,
                                        child: ListView.builder(
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            if (index ==
                                                bm.bookmarkList.length) {
                                              return IconButton(
                                                onPressed: () => bm.deleteAll(),
                                                icon: Icon(Icons.delete_sharp),
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
                                                padding: const EdgeInsets.only(
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
                                                                bottomRight:
                                                                    Radius
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
                                                                    ? Color
                                                                        .fromRGBO(
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
                                          itemCount: bm.bookmarkList.length + 1,
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
                                      AppLocalizations.of(context)!.bookmark,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          decoration: TextDecoration.underline,
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
                                      AppLocalizations.of(context)!
                                          .emptyBookmark,
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
                    ),
                    SizedBox(
                      height: 32,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 32.0, right: 32.0, bottom: 28.0),
                      child: Container(
                        height: context.height() * 0.53,
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
                          padding: const EdgeInsets.only(
                              top: 8.0, right: 8.0, left: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.07,
                                width: 180,
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
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
                                    // if (user.role != 'user')
                                    //   TextButton(
                                    //     onPressed: () async {
                                    //       await showDialog(
                                    //         context: context,
                                    //         builder: (BuildContext context) {
                                    //           return AlertDialog(
                                    //             title:
                                    //                 Text('Insert Page Number'),
                                    //             content: TextFormField(
                                    //               keyboardType: TextInputType
                                    //                   .numberWithOptions(
                                    //                       decimal: false),
                                    //               decoration: InputDecoration(
                                    //                   label: Text('Page')),
                                    //               controller: _page,
                                    //             ),
                                    //             actions: [
                                    //               TextButton(
                                    //                   onPressed: () =>
                                    //                       Navigator.pop(
                                    //                           context),
                                    //                   child: Text('Back')),
                                    //               ElevatedButton(
                                    //                   onPressed: () async {
                                    //                     if (int.parse(_page
                                    //                                 .text) >
                                    //                             604 ||
                                    //                         int.parse(_page
                                    //                                 .text) <
                                    //                             0) {
                                    //                       ScaffoldMessenger.of(
                                    //                               context)
                                    //                           .showSnackBar(SnackBar(
                                    //                               content: Text(
                                    //                                   'Page out of range. Please insert again')));
                                    //                     } else {
                                    //                       var suraId =
                                    //                           await getSuraId(
                                    //                               _page.text);
                                    //                       var suraName =
                                    //                           getSurahName(
                                    //                               int.parse(
                                    //                                   suraId));
                                    //                       var suraDesc =
                                    //                           getSurahNameEnglish(
                                    //                               int.parse(
                                    //                                   suraId));
                                    //                       List a =
                                    //                           await getTotalPage(
                                    //                               suraId);
                                    //                       var index = a.indexOf(
                                    //                           _page.text);
                                    //                       Provider.of<AyaProvider>(
                                    //                               context,
                                    //                               listen: false)
                                    //                           .getPage(int
                                    //                               .parse(_page
                                    //                                   .text));
                                    //                       Provider.of<AyaProvider>(
                                    //                               context,
                                    //                               listen: false)
                                    //                           .setDefault();
                                    //                       Provider.of<AyaProvider>(
                                    //                               context,
                                    //                               listen: false)
                                    //                           .getStart(
                                    //                               int.parse(
                                    //                                   suraId),
                                    //                               int.parse(
                                    //                                   a.first));
                                    //                       Navigator.pushReplacement(
                                    //                           context,
                                    //                           MaterialPageRoute(
                                    //                               builder: (context) =>
                                    //                                   SurahScreen(
                                    //                                       a,
                                    //                                       suraId,
                                    //                                       suraName,
                                    //                                       suraDesc,
                                    //                                       index)));
                                    //                     }
                                    //                   },
                                    //                   child: Text('Proceed'))
                                    //             ],
                                    //           );
                                    //         },
                                    //       );
                                    //     },
                                    //     child: Text(
                                    //       'Go to page',
                                    //       style: TextStyle(
                                    //           color: themeProvider.isDarkMode
                                    //               ? Colors.white
                                    //               : Colors.black),
                                    //     ),
                                    //   )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.height *
                                    (kIsWeb ? 0.5 : 0.42),
                                child: TabBarView(
                                    controller: _tabController,
                                    children: [
                                      ///todo:surah
                                      Column(
                                        children: [
                                          Expanded(
                                            child: _list.isNotEmpty
                                                ? MediaQuery.of(context)
                                                            .size
                                                            .width >
                                                        600
                                                    ? GridView.builder(
                                                        controller:
                                                            ScrollController(),
                                                        gridDelegate:
                                                            SliverGridDelegateWithFixedCrossAxisCount(
                                                                crossAxisCount: MediaQuery.of(context)
                                                                            .size
                                                                            .width <
                                                                        1200
                                                                    ? MediaQuery.of(context).size.width <
                                                                            700
                                                                        ? 1
                                                                        : 2
                                                                    : 3,
                                                                crossAxisSpacing:
                                                                    5.0,
                                                                mainAxisSpacing:
                                                                    5.0,
                                                                childAspectRatio:
                                                                    3.5),
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
                                                                // Provider.of<AyaProvider>(context,
                                                                //     listen: false)
                                                                //     .getPage(447);
                                                                var role = Provider.of<
                                                                            AppUser>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .role;
                                                                if (index > 0 &&
                                                                    role ==
                                                                        'user') {
                                                                  ScaffoldMessenger.of(
                                                                          context)
                                                                      .showSnackBar(
                                                                          snackBar);
                                                                } else {
                                                                  var a = await getTotalPage(
                                                                      _list[index]
                                                                          [
                                                                          "id"]);
                                                                  Provider.of<AyaProvider>(
                                                                          context,
                                                                          listen:
                                                                              false)
                                                                      .getPage(int
                                                                          .parse(
                                                                              a.first));
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
                                                                  Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) => SurahScreen(
                                                                              a,
                                                                              _list[index]["id"],
                                                                              _list[index]["tname"],
                                                                              _list[index]["ename"],
                                                                              0)));
                                                                }
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
                                                                        AutoSizeText(
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
                                                        controller:
                                                            ScrollController(),
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
                                                                // Provider.of<AyaProvider>(context,
                                                                //     listen: false)
                                                                //     .getPage(439);
                                                                var role = Provider.of<
                                                                            AppUser>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .role;
                                                                if (index > 0 &&
                                                                    role ==
                                                                        'user') {
                                                                  ScaffoldMessenger.of(
                                                                          context)
                                                                      .showSnackBar(
                                                                          snackBar);
                                                                } else {
                                                                  var a = await getTotalPage(
                                                                      _list[index]
                                                                          [
                                                                          "id"]);
                                                                  Provider.of<AyaProvider>(
                                                                          context,
                                                                          listen:
                                                                              false)
                                                                      .getPage(int
                                                                          .parse(
                                                                              a.first));
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
                                                                  Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) => SurahScreen(
                                                                              a,
                                                                              _list[index]["id"],
                                                                              _list[index]["tname"],
                                                                              _list[index]["ename"],
                                                                              0)));
                                                                }
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
                                                              (kIsWeb
                                                                  ? 0.5
                                                                  : 0.4),
                                                      child:
                                                          MediaQuery.of(context)
                                                                      .size
                                                                      .width >
                                                                  600
                                                              ? GridView
                                                                  .builder(
                                                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                                      crossAxisCount:
                                                                          MediaQuery.of(context).size.width < 1200
                                                                              ? 2
                                                                              : 3,
                                                                      crossAxisSpacing:
                                                                          5.0,
                                                                      mainAxisSpacing:
                                                                          5.0,
                                                                      childAspectRatio:
                                                                          4),
                                                                  itemCount:
                                                                      114,
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
                                                                        width:
                                                                            400,
                                                                        height:
                                                                            100,
                                                                        decoration: BoxDecoration(
                                                                            borderRadius: BorderRadius.only(
                                                                              topLeft: Radius.circular(10),
                                                                              topRight: Radius.circular(10),
                                                                              bottomLeft: Radius.circular(10),
                                                                              bottomRight: Radius.circular(10),
                                                                            ),
                                                                            color: themeProvider.isDarkMode ? Color(0xff67748E) : Color.fromRGBO(255, 255, 255, 1),
                                                                            border: Border.all(
                                                                              color: themeProvider.isDarkMode ? Color(0xffD2D6DA) : Color.fromRGBO(231, 111, 0, 1),
                                                                              width: 1,
                                                                            )),
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Container(
                                                                                width: 50,
                                                                                height: 100,
                                                                                decoration: BoxDecoration(
                                                                                  borderRadius: BorderRadius.only(
                                                                                    topLeft: Radius.circular(10),
                                                                                    topRight: Radius.circular(10),
                                                                                    bottomLeft: Radius.circular(10),
                                                                                    bottomRight: Radius.circular(10),
                                                                                  ),
                                                                                  color: themeProvider.isDarkMode ? Color(0xff808BA1) : Color.fromRGBO(255, 181, 94, 1),
                                                                                ),
                                                                                child: Center(
                                                                                  child: Text(
                                                                                    '',
                                                                                    textAlign: TextAlign.left,
                                                                                    style: TextStyle(fontFamily: 'Open Sans', fontSize: 24, letterSpacing: -0.38723403215408325, fontWeight: FontWeight.normal, height: 1),
                                                                                  ),
                                                                                )),
                                                                            Spacer(),
                                                                            Column(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              children: const [
                                                                                Text(
                                                                                  '',
                                                                                  textAlign: TextAlign.left,
                                                                                  style: TextStyle(fontFamily: 'Open Sans', fontSize: 24, letterSpacing: -0.38723403215408325, fontWeight: FontWeight.normal, height: 1),
                                                                                ),
                                                                                Text(
                                                                                  '',
                                                                                  textAlign: TextAlign.left,
                                                                                  style: TextStyle(color: Color.fromRGBO(151, 151, 151, 1), fontFamily: 'Open Sans', fontSize: 24, letterSpacing: -0.38723403215408325, fontWeight: FontWeight.normal, height: 1),
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
                                                              : ListView
                                                                  .builder(
                                                                  itemCount:
                                                                      114,
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
                                                                      child:
                                                                          InkWell(
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              400,
                                                                          height:
                                                                              100,
                                                                          decoration: BoxDecoration(
                                                                              borderRadius: BorderRadius.only(
                                                                                topLeft: Radius.circular(10),
                                                                                topRight: Radius.circular(10),
                                                                                bottomLeft: Radius.circular(10),
                                                                                bottomRight: Radius.circular(10),
                                                                              ),
                                                                              color: themeProvider.isDarkMode ? Color(0xff67748E) : Color.fromRGBO(255, 255, 255, 1),
                                                                              border: Border.all(
                                                                                color: themeProvider.isDarkMode ? Color(0xffD2D6DA) : Color.fromRGBO(231, 111, 0, 1),
                                                                                width: 1,
                                                                              )),
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Container(
                                                                                  width: 50,
                                                                                  height: 100,
                                                                                  decoration: BoxDecoration(
                                                                                    borderRadius: BorderRadius.only(
                                                                                      topLeft: Radius.circular(10),
                                                                                      topRight: Radius.circular(10),
                                                                                      bottomLeft: Radius.circular(10),
                                                                                      bottomRight: Radius.circular(10),
                                                                                    ),
                                                                                    color: themeProvider.isDarkMode ? Color(0xff808BA1) : Color.fromRGBO(255, 181, 94, 1),
                                                                                  ),
                                                                                  child: Center(
                                                                                    child: Text(
                                                                                      '',
                                                                                      textAlign: TextAlign.left,
                                                                                      style: TextStyle(fontFamily: 'Open Sans', fontSize: 24, letterSpacing: -0.38723403215408325, fontWeight: FontWeight.normal, height: 1),
                                                                                    ),
                                                                                  )),
                                                                              Spacer(),
                                                                              Column(
                                                                                mainAxisAlignment: MainAxisAlignment.center,
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
                                                    period:
                                                        Duration(seconds: 2),
                                                    highlightColor:
                                                        themeProvider.isDarkMode
                                                            ? Colors.grey
                                                            : Color(0xffaa9f9f),
                                                    direction:
                                                        SkeletonDirection.rtl,
                                                  ),
                                          ),
                                        ],
                                      ),

                                      ///todo:juz
                                      JuzDisplay(sura: _list)
                                    ]),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return SigninWidget();
            }
          })),
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
    if (mounted) {
      setState(() {
        _list = allData;
      });
    }
  }

  void _launchUrl() async {
    ///todo:for testing purpose
    // GetStorage().erase();
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => PaymentScreen()));
    // if (!await launchUrl(_url)) throw 'Could not launch $_url';
  }

  Future<String> getSuraId(String text) async {
    var data = await FirebaseFirestore.instance
        .collection('medina_mushaf_pages')
        .doc(text)
        .get()
        .then((value) => value['sura_id']);
    return data;
  }
}
