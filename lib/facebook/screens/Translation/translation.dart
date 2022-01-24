import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quranirab/facebook/widgets/more_options_list.dart';
import 'package:quranirab/theme/theme_provider.dart';

import '../home_screen.dart';

class TranslationPage extends StatefulWidget {
  const TranslationPage({Key? key}) : super(key: key);

  @override
  _TranslationPageState createState() => _TranslationPageState();
}

class _TranslationPageState extends State<TranslationPage> {
  List _list = [];
  final List _lists = [];
  final CollectionReference _collectionRef =
  FirebaseFirestore.instance.collection('quran_translations');

  List menuItems = [
    ItemModel('Share', Icons.share),
    ItemModel('Bookmark', Icons.bookmarks),
  ];
  final CustomPopupMenuController _controller = CustomPopupMenuController();

  Future<void> getData() async {
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await _collectionRef
        .where('translation_id', isEqualTo: "2")
        .where('sura_id', isEqualTo: "1")
        .get();

    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    setState(() {
      _list = allData;
    });
    //convert dynamic map list into string list
    var data = _list.map((e) => e["text"]).toList();
    setState(() {
      _list = data;
    });
  }

  final CollectionReference _collectionRefs =
  FirebaseFirestore.instance.collection('quran_texts');

  Future<void> getDatas() async {
    // Get docs from collection reference
    await _collectionRefs
        .where('medina_mushaf_page_id', isEqualTo: '1')
        .where('sura_id', isEqualTo: '1')
        .orderBy('created_at')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        setState(() {
          _lists.add(doc['text1']);
        });
      }
    });
    _lists.any((e) => e.contains('b'));
  }

  @override
  void initState() {
    getData();
    getDatas();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Container(
      decoration: BoxDecoration(
        color: (themeProvider.isDarkMode)
            ? const Color(0xff666666)
            : const Color(0xFFffffff),
      ),
      child: Row(
        children: [
          Visibility(
            visible: true,
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
                child:  const MoreOptionsList(
                  surah: 'Straight', nukKalimah: '',
                ),
              ),
            ),
          ),
          const Spacer(),
          _list.isNotEmpty && _lists.isNotEmpty
              ? SizedBox(
            width: MediaQuery.of(context).size.width*0.7,
            child: Align(
              alignment: Alignment.topLeft,
              child: ListView.builder(
                itemCount: _list.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    semanticContainer: true,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 5,
                    color: (themeProvider.isDarkMode)
                        ? const Color(0xffC4C4C4)
                        : const Color(0xffFFF5EC),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: (themeProvider.isDarkMode)
                                      ? const Color(0xff67748E)
                                      : const Color(0xffFFEEB0),
                                ),
                                width: 40,
                                child: Center(
                                  child: Text(
                                    '1:${index + 1}',
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Theme.of(context)
                                            .textSelectionColor),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              CustomPopupMenu(
                                menuBuilder: () => ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: Container(
                                    color: Theme.of(context).primaryColor,
                                    child: IntrinsicWidth(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                        children: menuItems
                                            .map(
                                              (item) => GestureDetector(
                                            behavior: HitTestBehavior
                                                .translucent,
                                            onTap:
                                            _controller.hideMenu,
                                            child: Container(
                                              height: 40,
                                              padding:
                                              const EdgeInsets
                                                  .symmetric(
                                                  horizontal: 20),
                                              child: Row(
                                                children: <Widget>[
                                                  Icon(
                                                    item.icon,
                                                    size: 15,
                                                    color: Theme.of(
                                                        context)
                                                        .textSelectionColor,
                                                  ),
                                                  Expanded(
                                                    child: Container(
                                                      margin:
                                                      const EdgeInsets
                                                          .only(
                                                          left:
                                                          10),
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical:
                                                          10),
                                                      child: Text(
                                                        item.text,
                                                        style:
                                                        TextStyle(
                                                          color: Theme.of(
                                                              context)
                                                              .textSelectionColor,
                                                          fontSize:
                                                          12,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                            .toList(),
                                      ),
                                    ),
                                  ),
                                ),
                                pressType: PressType.singleClick,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.circular(8),
                                    color: (themeProvider.isDarkMode)
                                        ? const Color(0xff67748E)
                                        : const Color(0xffFFEEB0),
                                  ),
                                  width: 40,
                                  child: Icon(
                                    Icons.more_horiz,
                                    color: Theme.of(context)
                                        .textSelectionColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Center(
                            child: ListTile(
                              title: Container(
                                color: themeProvider.isDarkMode
                                    ? const Color(0xffC4C4C4)
                                    : const Color(0xffFFF5EC),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        _list[index],
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 16,
                                    ),
                                    Padding(
                                      padding:
                                      const EdgeInsets.only(right: 8.0),
                                      child: Directionality(
                                        textDirection: TextDirection.rtl,
                                        child: Text(
                                          _lists[index]
                                              .trim()
                                              .replaceAll('b', ''),
                                          style: const TextStyle(
                                              fontSize: 26,
                                              fontFamily: 'MeQuran2',
                                              color: Colors.black),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )),
                      ],
                    ),
                  );
                },
              ),
            ),
          )
              : const Center(child: Text('Loading...')),
          const Spacer(),
        ],
      ),
    );
  }
}