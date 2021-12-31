import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quranirab/theme/theme_provider.dart';
import 'package:quranirab/themes/theme_model.dart';
import 'package:quranirab/widget/language.dart';
import 'package:quranirab/widget/menu.dart';
import 'package:quranirab/widget/setting.dart';

import 'Juz.dart';
import 'Surah.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  bool isSearch = false;
  List _suraList = [];
  final CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('suras');

  Future<void> getData() async {
    // Get docs from collection reference
    QuerySnapshot querySnapshot =
        await _collectionRef.orderBy("created_at").get();

    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    setState(() {
      _suraList = allData;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getData();

    super.initState();
  }

  final TextEditingController _search = TextEditingController();
  String surah = 'Surah Name';
  String detail = 'Surah Detail';
  String arab = 'Arabic Name';

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    TabController _tabController = TabController(length: 2, vsync: this);
    return Consumer<ThemeModel>(
        builder: (context, ThemeModel themeNotifier, child) {
      return Scaffold(
        drawer: Menu(),
        endDrawer: Setting(),
        appBar: AppBar(
          iconTheme: Theme.of(context).iconTheme,
          title: Row(
            children: const [
              CircleAvatar(
                backgroundImage: AssetImage('assets/quranirab.png'),
                radius: 18.0,
              ),
            ],
          ),
          elevation: 0,
          centerTitle: false,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          actions: <Widget>[
            IconButton(
              tooltip: MaterialLocalizations.of(context).searchFieldLabel,
              onPressed: () => setState(() {
                isSearch = true;
              }),
              icon: Icon(
                Icons.search,
                color: Theme.of(context).iconTheme.color,
              ),
            ),
            const SizedBox(width: 20),
            Padding(
                padding: const EdgeInsets.only(right: 20.0), child: Language()),
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(
                  Icons.settings,
                ),
                onPressed: () => Scaffold.of(context).openEndDrawer(),
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              ),
            ),
          ],
        ),
        body: Stack(
          children: [
            isSearch ? buildSuggestions(context) : Container(),
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 89,
                  ),
                  Container(
                      padding: const EdgeInsets.only(left: 50),
                      child: RichText(
                        text: TextSpan(children: [
                          TextSpan(
                            text: "Bookmark",
                            style: TextStyle(
                              shadows: [
                                Shadow(
                                    color: (themeProvider.isDarkMode)
                                        ? const Color(0xFFFFFFFF)
                                        : const Color(0xFF000000),
                                    offset: const Offset(0, -10))
                              ],
                              color: Colors.transparent,
                              fontSize: 20,
                              decoration: TextDecoration.underline,
                              // decorationColor: Colors.grey,
                              decorationThickness: 2,
                            ),
                          ),
                          TextSpan(
                              text: "\nYou do not have any bookmark yet.",
                              style: TextStyle(
                                  fontSize: 20,
                                  color: (themeProvider.isDarkMode)
                                      ? const Color(0xFFFFFFFF)
                                      : const Color(0xFF000000))),
                        ]),
                      )),
                  const SizedBox(
                    height: 100,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TabBar(
                      labelColor: (themeProvider.isDarkMode)
                          ? const Color(0xFFFFFFFF)
                          : const Color(0xFF000000),
                      unselectedLabelColor: (themeProvider.isDarkMode)
                          ? const Color(0xFFFFFFFF)
                          : const Color(0xFF000000),
                      isScrollable: true,
                      labelPadding: const EdgeInsets.only(left: 50, right: 50),
                      indicatorSize: TabBarIndicatorSize.label,
                      indicatorColor: (themeProvider.isDarkMode)
                          ? const Color(0xFF263D4A)
                          : const Color(0xFFE86F00),
                      controller: _tabController,
                      tabs: const [
                        Tab(
                          text: "Sura",
                        ),
                        Tab(
                          text: "Juz",
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 50),
                    height: 650,
                    child: TabBarView(
                      controller: _tabController,
                      children: const [
                        SurahGrid(),
                        JuzGrid(),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  buildSuggestions(BuildContext context) {
    List listToShow;
    if (_search.text.isNotEmpty) {
      listToShow = _suraList
          .map((e) => e["tname"])
          .where((e) =>
              e.toLowerCase().contains(_search.text) ||
              e.toUpperCase().contains(_search.text))
          .toList();
    } else {
      listToShow = _suraList.map((e) => e["tname"]).toList();
    }

    return Visibility(
      visible: isSearch,
      child: Positioned(
        right: 100,
        child: Align(
          alignment: Alignment.topRight,
          child: Container(
            height: 300,
            width: 200,
            margin: const EdgeInsets.all(10.0),
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.orange),
            ),
            child: Stack(children: [
              Positioned(
                child: Align(
                  alignment: Alignment.topLeft,
                  child: SizedBox(
                    child: TextField(
                      controller: _search,
                      onChanged: (v) async {
                        setState(() {
                          if (v.isEmpty) {
                            isSearch = false;
                          }
                          isSearch = true;
                        });
                      },
                      decoration: InputDecoration(
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.orange),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.orange),
                          ),
                          border: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.orange),
                          ),
                          label: Text(
                            "Search",
                            style: TextStyle(
                                color: Theme.of(context).iconTheme.color),
                          ),
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _search.clear();
                                  isSearch = false;
                                });
                              },
                              icon: Icon(
                                Icons.cancel,
                                color: Theme.of(context).iconTheme.color,
                              ))),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 55,
                left: 5,
                child: Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 200,
                    height: 310,
                    child: ListView.builder(
                      itemCount: listToShow.length,
                      itemBuilder: (_, i) {
                        var surahs = listToShow[i];
                        return GestureDetector(
                          child: ListTile(
                            title: Text(surahs),
                          ),
                          onTap: () {
                            getDetails(surahs);
                            setState(() {
                              isSearch = false;
                              surah = surahs;
                              _search.clear();
                            });
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  Future<void> getDetails(String surah) async {
    // Get docs from collection reference
    QuerySnapshot querySnapshot =
        await _collectionRef.where("tname", isEqualTo: surah).get();

    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc["ename"]);
    final allData1 = querySnapshot.docs.map((doc) => doc["start_line"]);

    setState(() {
      detail = allData.first;
      arab = allData1.first;
    });
  }
}
