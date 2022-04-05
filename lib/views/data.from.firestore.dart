import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quranirab/models/font.size.dart';
import 'package:quranirab/widget/menu.dart';
import 'package:quranirab/widget/search.popup.dart';
import 'package:quranirab/widget/setting.popup.dart';
import 'package:quranirab/views/surah.screen.dart';
import 'package:quranirab/widget/LanguagePopup.dart';
import '../provider/ayah.number.provider.dart';
import 'package:quranirab/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DataFromFirestore extends StatefulWidget {
  const DataFromFirestore({Key? key}) : super(key: key);

  @override
  _DataFromFirestoreState createState() => _DataFromFirestoreState();
}

class _DataFromFirestoreState extends State<DataFromFirestore> {
  late AsyncMemoizer _memoizer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _memoizer = AsyncMemoizer();
    getData();
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

  Future<void> getData() => _memoizer.runOnce(() async {
        // Get docs from collection reference
        QuerySnapshot querySnapshot =
            await _collectionRef.orderBy('created_at').get();

        // Get data from docs and convert map to List
        final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
        setState(() {
          _list = allData;
        });
      });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final fontsize = Provider.of<AyaProvider>(context);

    return Scaffold(
      backgroundColor:
          themeProvider.isDarkMode ? const Color(0xff666666) : Colors.white,
      drawer: const Menu(),
      body: NestedScrollView(
        physics: const BouncingScrollPhysics(),
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
                    padding: EdgeInsets.only(right: 20.0), child: LangPopup()),
                Padding(
                    padding: EdgeInsets.only(right: 20.0),
                    child: SettingPopup()),
              ],
            ),
          ];
        },
        body: Center(
          child: SingleChildScrollView(
            child: _list.isEmpty
                ? Text('Loading...')
                : Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GridView(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            crossAxisSpacing: 5.0,
                            mainAxisSpacing: 5.0,
                          ),
                          children: _list
                              .map((data) => Card(
                                    child: InkWell(
                                      onTap: () async {
                                        var a = await getTotalPage(data["id"]);
                                        fontData.allpages = a;
                                        fontData.sura_id = data["id"];
                                        fontData.name = data["tname"];
                                        fontData.detail = data["ename"];
                                        Provider.of<AyaProvider>(context,
                                                listen: false)
                                            .getPage(int.parse(a.first));
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    SurahScreen(
                                                      a,
                                                      data["id"],
                                                      data["tname"],
                                                      data["ename"],
                                                    )));
                                      },
                                      child: ListTile(
                                        title: Text(
                                          '${data["start_line"]} (${data["tname"]})',
                                          style: TextStyle(
                                              fontSize: fontsize.value,
                                              fontFamily: 'MeQuran2',
                                              color: Colors.white),
                                        ),
                                        subtitle: Text(
                                          '${data["ename"]}',
                                          style: TextStyle(
                                              fontSize: fontsize.value,
                                              fontFamily: 'MeQuran2',
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ))
                              .toList(),
                        ),
                      )
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
