import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/ayah.number.provider.dart';
import '../../provider/bookmark.provider.dart';
import '../../theme/theme_provider.dart';
import '../juz.screen.dart';
import '../surah.screen.dart';

class TranslationJuz extends StatefulWidget {
  const TranslationJuz({
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
  final JuzScreen widget;
  final int? start;
  final List menuItems;
  final JuzScreen widget1;
  final int i;
  final JuzScreen widget2;
  final JuzScreen widget3;
  final JuzScreen widget4;
  final JuzScreen widget5;

  @override
  State<TranslationJuz> createState() => _TranslationJuzState();
}

class _TranslationJuzState extends State<TranslationJuz> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
      const EdgeInsets.only(bottom: 56.0, top: 16, left: 16, right: 16),
      child: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: (widget.themeProvider.isDarkMode)
              ? const Color(0xff666666)
              : const Color(0xFFffffff),
        ),
        child: widget._list.isNotEmpty && widget._translate.isNotEmpty
            ? Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Align(
            alignment: Alignment.topLeft,
            child: ListView.builder(
              itemCount: widget._list.length,
              itemBuilder: (BuildContext context, int index) {
                final fontsize = Provider.of<AyaProvider>(context);
                return Padding(
                  padding: index == widget._list.length - 1
                      ? EdgeInsets.only(
                      bottom: MediaQuery.of(context).size.height * .1)
                      : EdgeInsets.all(0.0),
                  child: Card(
                    semanticContainer: true,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 5,
                    color: (widget.themeProvider.isDarkMode)
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
                                  color: (widget.themeProvider.isDarkMode)
                                      ? const Color(0xff67748E)
                                      : const Color(0xffFFEEB0),
                                ),
                                width: 70,
                                child: Center(
                                  child: Text(
                                    '${widget.widget.sura_id}:${widget.start! + index}',
                                    style: TextStyle(
                                      fontSize: fontsize.value,
                                      color: Theme.of(
                                          context)
                                          .textSelectionTheme.selectionColor,),
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
                                        children: widget.menuItems
                                            .map(
                                              (item) => Container(
                                            height: 40,
                                            padding: const EdgeInsets
                                                .symmetric(
                                                horizontal: 20),
                                            child: Row(
                                              children: <Widget>[
                                                Icon(
                                                  item.icon,
                                                  size: 16,
                                                  color: Theme.of(
                                                      context)
                                                      .textSelectionTheme
                                                      .selectionColor,
                                                ),
                                                Expanded(
                                                  child: InkWell(
                                                    onTap: () async {
                                                      // Obtain shared preferences.
                                                      if (item.text ==
                                                          'Bookmark') {
                                                        List pages = widget
                                                            .widget
                                                            .allpages;
                                                        if (widget
                                                            .i !=
                                                            0) {
                                                          pages.removeRange(
                                                              0,
                                                              widget
                                                                  .i);
                                                        }
                                                        String
                                                        ayahNo =
                                                            "${widget.widget.sura_id}:${widget.start! + index}";
                                                        await Provider.of<BookMarkProvider>(context, listen: false).addtoBookmark(
                                                            context,
                                                            ayahNo,
                                                            widget
                                                                .widget
                                                                .sura_id,
                                                            widget
                                                                .widget
                                                                .name!,
                                                            widget
                                                                .widget
                                                                .detail!,
                                                            pages);
                                                      }
                                                    },
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
                                                              .textSelectionTheme
                                                              .selectionColor,
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
                                    color:
                                    (widget.themeProvider.isDarkMode)
                                        ? const Color(0xff67748E)
                                        : const Color(0xffFFEEB0),
                                  ),
                                  width: 40,
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Icon(
                                        Icons.more_horiz,
                                        size: fontsize.value,
                                        color: Theme.of(context)
                                            .textSelectionTheme
                                            .selectionColor,
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
                            color: widget.themeProvider.isDarkMode
                                ? const Color(0xffC4C4C4)
                                : const Color(0xffFFF5EC),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                    widget._translate[index],
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
                                    widget._list[index]
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
                  ),
                );
              },
            ),
          ),
        )
            : const Center(child: Text('Loading...')),
      ),
    );
  }
}
