import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/ayah.number.provider.dart';
import '../provider/bookmark.provider.dart';
import '../theme/theme_provider.dart';
import '../views/surah.screen.dart';

class Translation extends StatelessWidget {
  const Translation({
    Key? key,
    required this.themeProvider,
    required List list,
    required List translate,
    required this.widget,
    required this.start,
    required this.menuItems,
    required this.widget1,
    required this.i,
    required this.widget2,
    required this.widget3,
    required this.widget4,
    required this.widget5,
  })  : _list = list,
        _translate = translate,
        super(key: key);

  final ThemeProvider themeProvider;
  final List _list;
  final List _translate;
  final SurahScreen widget;
  final int? start;
  final List menuItems;
  final SurahScreen widget1;
  final int i;
  final SurahScreen widget2;
  final SurahScreen widget3;
  final SurahScreen widget4;
  final SurahScreen widget5;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.8,
            decoration: BoxDecoration(
              color: (themeProvider.isDarkMode)
                  ? const Color(0xff666666)
                  : const Color(0xFFffffff),
            ),
            child: _list.isNotEmpty && _translate.isNotEmpty
                ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: ListView.builder(
                  itemCount: _list.length,
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
                                      '${widget.sura_id}:${start! + index}',
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
                                      color:
                                      Theme.of(context).primaryColor,
                                      child: IntrinsicWidth(
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                          children: menuItems
                                              .map(
                                                (item) => Container(
                                              height: 40,
                                              padding:
                                              const EdgeInsets
                                                  .symmetric(
                                                  horizontal: 20),
                                              child: Row(
                                                children: <Widget>[
                                                  Icon(
                                                    item.icon,
                                                    size: 16,
                                                    color: Theme.of(
                                                        context)
                                                        .textSelectionColor,
                                                  ),
                                                  Expanded(
                                                    child: InkWell(
                                                      onTap:
                                                          () async {
                                                        // Obtain shared preferences.
                                                        if (item.text ==
                                                            'Bookmark') {
                                                          List pages =
                                                              widget
                                                                  .allpages;
                                                          if (i !=
                                                              0) {
                                                            pages.removeRange(
                                                                0, i);
                                                          }
                                                          String
                                                          ayahNo =
                                                              "${widget.sura_id}:${start! + index}";
                                                          await Provider.of<BookMarkProvider>(context, listen: false).addtoBookmark(
                                                              context,
                                                              ayahNo,
                                                              widget
                                                                  .sura_id,
                                                              widget
                                                                  .name,
                                                              widget
                                                                  .detail,
                                                              pages);
                                                        }
                                                      },
                                                      child:
                                                      Container(
                                                        margin: const EdgeInsets
                                                            .only(
                                                            left: 10),
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
                                                            14,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
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
                                    child: Center(
                                      child: Padding(
                                        padding:
                                        const EdgeInsets.all(4.0),
                                        child: Icon(
                                          Icons.more_horiz,
                                          size: fontsize.value,
                                          color: Theme.of(context)
                                              .textSelectionColor,
                                        ),
                                      ),
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
                                      _translate[index],
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
                                      _list[index]
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
            )
                : const Center(child: Text('Loading...')),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
          )
        ],
      ),
    );
  }
}