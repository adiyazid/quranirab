import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quranirab/provider/ayah.number.provider.dart';

import '../../models/word.detail.dart';

class MoreOptionsList extends StatefulWidget {
  final String surah;
  final String nukKalimah;

  const MoreOptionsList({
    Key? key,
    required this.nukKalimah,
    required this.surah,
  }) : super(key: key);

  @override
  State<MoreOptionsList> createState() => _MoreOptionsListState();
}

class _MoreOptionsListState extends State<MoreOptionsList> {
  final ScrollController _controller = ScrollController();

  bool loaded = false;

  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(Duration(seconds: 5), loading);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loaded
        ? Consumer<AyaProvider>(builder: (context, aya, child) {
            List<WordDetail> word = aya.getWordTypeList() ?? <WordDetail>[];
            List<WordDetail> name = aya.getWordNameList() ?? <WordDetail>[];

            for (var item in name) {
              for (var element in word) {
                if (element.categoryId == item.categoryId) {
                  if (item.categoryId == 68) {}
                  item.type = element.type;
                }
              }
            }
            name.sort((a, b) => a.categoryId!.compareTo(b.categoryId!));
            var newPosition;
            var newPosition2;
            WordDetail old;
            WordDetail old2;
            for (int i = 0; i < name.length; i++) {
              if (name[i].categoryId == 68) {
                newPosition = i + 1;
              }
              if (name[i].categoryId == 429) {
                newPosition2 = i + 1;
              }
              if (name[i].categoryId == 495) {
                old2 = name[i];
                name.removeAt(i);
                name.insertAll(newPosition2, [old2]);
              }
              if (name[i].id == 1426) {
                old = name[i];
                name.removeAt(i);
                name.insertAll(newPosition, [old]);
              }
            }
            return ListView.builder(
              controller: _controller,
              physics: const NeverScrollableScrollPhysics(),
              itemCount:
                  name.last.type != "label" ? name.length - 1 : name.length,
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  final fontsize = Provider.of<AyaProvider>(context);
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                            onPressed: aya.visible == true
                                ? () {
                                    setState(() {
                                      aya.set();
                                    });
                                  }
                                : null,
                            icon: Icon(Icons.clear)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: Text(
                              widget.surah,
                              style: TextStyle(
                                fontFamily: 'MeQuran2',
                                fontSize: fontsize.value,
                                color: Theme.of(context).textSelectionColor,
                              ),
                            )),
                      ),
                      const Divider(
                        thickness: 1,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          children: [
                            Text(
                              name[index].name!,
                              style: TextStyle(
                                fontFamily: 'MeQuran2',
                                fontSize: 24,
                                color: checkColor(aya.category),
                              ),
                            ),
                            Spacer(),
                            Text(
                              'نوع الكلمة',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: 'MeQuran2',
                                  color: Theme.of(context).textSelectionColor,
                                  fontSize: 20),
                            ),
                          ],
                        ),
                      )
                    ],
                  );
                }
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      name[index + 1 < name.length ? index + 1 : index].type !=
                                  'label' &&
                              name[index + 1 < name.length ? index + 1 : index]
                                      .type !=
                                  'main-label'
                          ? Container(
                              height: aya.wordName.length < 35 ? 56 : 120,
                              padding: const EdgeInsets.only(
                                bottom: 0.2, // space between underline and text
                              ),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                color: Theme.of(context)
                                    .textSelectionColor, // Text colour here
                                width: 1, // Underline width
                              ))),
                              child: Text(
                                "${index + 1 < name.length ? name[index + 1].name : ''}",
                                maxLines: 2,
                                style: TextStyle(
                                  fontFamily: 'MeQuran2',
                                  fontSize: 20,
                                  color: Theme.of(context)
                                      .textSelectionColor, // Text colour here
                                ),
                              ),
                            )
                          : Container(),
                      Spacer(),
                      if (name[index].type == 'label' ||
                          name[index].type == 'main-label')
                        Directionality(
                            textDirection: TextDirection.rtl,
                            child: Text(
                              "${name[index].name}",
                              style: TextStyle(
                                fontFamily: 'MeQuran2',
                                fontSize:
                                    name[index].type == 'main-label' ? 24 : 20,
                                color: name[index].type == 'main-label'
                                    ? checkMainColor(name[index].id)
                                    : Theme.of(context).textSelectionColor,
                              ),
                            ))
                    ],
                  ),
                );
              },
            );
          })
        : Center(child: Text('loading'));
  }

  void loading() {
    setState(() {
      loaded = true;
    });
  }

  checkMainColor(int? id) {
    if (id == 3) {
      return Color(0xffFF6106);
    }
    if (id == 68) {
      return Color(0xffFF29DD);
    }
    return Colors.black;
  }

  checkMainFontSize(int? id) {
    if (id == 3 || id == 68) {
      return 24;
    }
    return 20;
  }

  checkColor(String category) {
    if (category == 'Ism') return Colors.blue;
    if (category == 'Harf') return Colors.red;
    if (category == 'Fi‘l') return Colors.green;
    return Colors.black;
  }
}
