import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quranirab/models/item.model.dart';
import 'package:quranirab/widget/more_options_list.dart';
import 'package:quranirab/provider/ayah.number.provider.dart';
import 'package:quranirab/theme/theme_provider.dart';

class TranslationPage extends StatefulWidget {
  final String sura_id;
  final String page_id;

  const TranslationPage(this.sura_id, this.page_id, {Key? key})
      : super(key: key);

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

  int? a = 1;

  Future<void> getData() async {
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await _collectionRef
        .where('translation_id', isEqualTo: "2")
        .where('sura_id', isEqualTo: widget.sura_id)
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
    if (a != 1) {
      _list.removeRange(0, a! - 1);
    }
  }

  final CollectionReference _collectionRefs =
      FirebaseFirestore.instance.collection('quran_texts');
  final CollectionReference _collectionRefss =
      FirebaseFirestore.instance.collection('medina_mushaf_pages');

  Future<void> getDatas() async {
    // Get docs from collection reference
    await _collectionRefs
        .where('medina_mushaf_page_id', isEqualTo: widget.page_id)
        .where('sura_id', isEqualTo: widget.sura_id)
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

  Future<void> getStartAyah() async {
    // Get docs from collection reference
    await _collectionRefss
        .where('id', isEqualTo: widget.page_id)
        .where('sura_id', isEqualTo: widget.sura_id)
        .orderBy('created_at')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        setState(() {
          a = int.parse(doc['aya']);
        });
      }
    });
  }

  @override
  void initState() {
    getStartAyah();
    getData();
    getDatas();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return StatefulBuilder(builder: (context, setState) {
      return Container(
        decoration: BoxDecoration(
          color: (themeProvider.isDarkMode)
              ? const Color(0xff666666)
              : const Color(0xFFffffff),
        ),
        child: _list.isNotEmpty && _lists.isNotEmpty
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 3,
                    child: Visibility(
                      visible: true,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.33,
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
                          nukKalimah: '',
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: ListView.builder(
                          itemCount: _lists.length,
                          itemBuilder: (BuildContext context, int index) {
                            final fontsize = Provider.of<AyaProvider>(context);
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
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color: (themeProvider.isDarkMode)
                                                ? const Color(0xff67748E)
                                                : const Color(0xffFFEEB0),
                                          ),
                                          width: 70,
                                          child: Center(
                                            child: Text(
                                              '${widget.sura_id}:${a! + index}',
                                              style: TextStyle(
                                                  fontSize: fontsize.value,
                                                  color: Theme.of(context)
                                                      .textSelectionColor),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        CustomPopupMenu(
                                          menuBuilder: () => ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            child: Container(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              child: IntrinsicWidth(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .stretch,
                                                  children: menuItems
                                                      .map(
                                                        (item) =>
                                                            GestureDetector(
                                                          behavior:
                                                              HitTestBehavior
                                                                  .translucent,
                                                          onTap: _controller
                                                              .hideMenu,
                                                          child: Container(
                                                            height: 40,
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        20),
                                                            child: Row(
                                                              children: <
                                                                  Widget>[
                                                                Icon(
                                                                  item.icon,
                                                                  size: 15,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .textSelectionColor,
                                                                ),
                                                                Expanded(
                                                                  child:
                                                                      Container(
                                                                    margin: const EdgeInsets
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
                                                                        color: Theme.of(context)
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
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 8),
                                    child: Container(
                                      color: themeProvider.isDarkMode
                                          ? const Color(0xffC4C4C4)
                                          : const Color(0xffFFF5EC),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                            child: Text(
                                              _list[index],
                                              textAlign: TextAlign.justify,
                                              style: TextStyle(
                                                fontSize: fontsize.value,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 16,
                                          ),
                                          Flexible(
                                            child: Text(
                                              _lists[index]
                                                  .trim()
                                                  .replaceAll('b', ''),
                                              textDirection: TextDirection.rtl,
                                              style: TextStyle(
                                                  fontSize: fontsize.value,
                                                  fontFamily: 'MeQuran2',
                                                  color: Colors.black),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : const Center(child: Text('Loading...')),
      );
    });
  }
}
