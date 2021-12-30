import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quranirab/themes/theme_model.dart';
import 'package:quranirab/views/mushaf.page.dart';
import 'package:quranirab/widget/language.dart';
import 'package:quranirab/widget/menu.dart';
import 'package:quranirab/widget/setting.dart';

class HomePage extends StatefulWidget {
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
    TabController _tabController = TabController(length: 2, vsync: this);
    return Consumer<ThemeModel>(
        builder: (context, ThemeModel themeNotifier, child) {
      return Scaffold(
        drawer: Menu(),
        endDrawer: const Setting(),
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 89,
                ),
                Container(
                    padding: const EdgeInsets.only(left: 69),
                    child: RichText(
                      text: TextSpan(children: [
                        const TextSpan(
                          text: "Bookmark",
                          style: TextStyle(
                            shadows: [
                              Shadow(
                                  color: Colors.black, offset: Offset(0, -10))
                            ],
                            fontSize: 20.0,
                            color: Colors.transparent,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.grey,
                            decorationThickness: 2,
                          ),
                        ),
                        TextSpan(
                            text: "\nYou do not have any bookmark yet.",
                            style: TextStyle(
                                fontSize: 20,
                                color: Theme.of(context).iconTheme.color)),
                      ]),
                    )),
                const SizedBox(
                  height: 100,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 19.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: TabBar(
                      labelColor: Colors.black,
                      unselectedLabelColor: Colors.grey,
                      isScrollable: true,
                      labelPadding: const EdgeInsets.only(left: 50, right: 50),
                      indicatorSize: TabBarIndicatorSize.label,
                      indicatorColor: Colors.orange,
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
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  padding: const EdgeInsets.only(left: 50),
                  height: 650,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      CustomScrollView(
                        shrinkWrap: true,
                        primary: false,
                        slivers: <Widget>[
                          SliverPadding(
                            padding: const EdgeInsets.all(20),
                            sliver: SliverGrid.count(
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              crossAxisCount: 3,
                              childAspectRatio:
                                  MediaQuery.of(context).size.width /
                                      (MediaQuery.of(context).size.height / 4),
                              children: <Widget>[
                                GestureDetector(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(color: Colors.orange),
                                    ),
                                    padding: const EdgeInsets.all(8),
                                    child: const ListTile(
                                      title: Text("Al Fatihah"),
                                      subtitle: Text("The opener"),
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const MushafPage()));
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      CustomScrollView(
                        shrinkWrap: true,
                        primary: false,
                        slivers: <Widget>[
                          SliverPadding(
                            padding: const EdgeInsets.all(20),
                            sliver: SliverGrid.count(
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              crossAxisCount: 3,
                              childAspectRatio:
                                  MediaQuery.of(context).size.width /
                                      (MediaQuery.of(context).size.height / 4),
                              children: <Widget>[
                                GestureDetector(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(color: Colors.orange),
                                    ),
                                    padding: const EdgeInsets.all(8),
                                    child: const ListTile(
                                      title: Text("The cow"),
                                      subtitle: Text("The cow"),
                                    ),
                                  ),
                                  onTap: null,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
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
