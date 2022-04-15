import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/word.detail.dart';
import '../provider/ayah.number.provider.dart';
import '../theme/theme_provider.dart';

class ListItems extends StatefulWidget {
  final String text;

  const ListItems(this.text, {Key? key}) : super(key: key);

  @override
  State<ListItems> createState() => _ListItemsState();
}

class _ListItemsState extends State<ListItems> {
  bool loaded = false;

  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(Duration(seconds: 3), loading);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loaded
        ? Scrollbar(
            child: Consumer<AyaProvider>(builder: (context, aya, child) {
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
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Directionality(
                          textDirection: TextDirection.rtl,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadiusDirectional.circular(8),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  widget.text
                                      .replaceAll('ﲿ', '')
                                      .replaceAll('ﲹ', ''),
                                  style: TextStyle(
                                      color: checkColor(aya.category),
                                      fontSize: 24,
                                      fontFamily: 'MeQuran2'),
                                ),
                              ),
                            ),
                          )),
                    ],
                  ),
                  Divider(
                    thickness: 2,
                    color: Colors.black,
                  ),
                  SizedBox(
                    height: 300,
                    child: ListView.builder(
                      itemCount: name.last.type != "label"
                          ? name.length - 1
                          : name.length,
                      itemBuilder: (BuildContext context, int index) {
                        return name.isNotEmpty
                            ? Row(
                                children: [
                                  name[index + 1 < name.length
                                                      ? index + 1
                                                      : index]
                                                  .type !=
                                              'label' &&
                                          name[index + 1 < name.length
                                                      ? index + 1
                                                      : index]
                                                  .type !=
                                              'main-label'
                                      ? Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            height: 64,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadiusDirectional
                                                      .circular(8),
                                            ),
                                            child: Center(
                                              child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    "${index + 1 < name.length ? name[index + 1].name : ''}",
                                                    style: TextStyle(
                                                        fontFamily: 'MeQuran2',
                                                        fontSize: 20),
                                                    textAlign: TextAlign.center,
                                                  )),
                                            ),
                                          ),
                                        )
                                      : index == 0
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Container(
                                                height: 64,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadiusDirectional
                                                          .circular(8),
                                                ),
                                                child: Center(
                                                  child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        "${name[index].name}",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'MeQuran2',
                                                            fontSize: 20),
                                                        textAlign:
                                                            TextAlign.center,
                                                      )),
                                                ),
                                              ),
                                            )
                                          : Container(),
                                  Spacer(),
                                  index == 0
                                      ? Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadiusDirectional
                                                      .circular(8),
                                            ),
                                            height: 64,
                                            child: Center(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  'نوع الكلمة',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontFamily: 'MeQuran2',
                                                      fontSize: 20),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      : Container(),
                                  if (name[index].type == 'label' ||
                                      name[index].type == 'main-label')
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        height: 64,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadiusDirectional.circular(
                                                  8),
                                        ),
                                        child: Center(
                                          child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                "${name[index].name}",
                                                style: TextStyle(
                                                    fontSize: checkMainFontSize(
                                                        name[index].id),
                                                    fontFamily: 'MeQuran2',
                                                    color: checkMainColor(
                                                        name[index].id)),
                                                textAlign: TextAlign.center,
                                              )),
                                        ),
                                      ),
                                    )
                                ],
                              )
                            : Container();
                      },
                    ),
                  ),
                ],
              );
            }),
          )
        : Center(child: CircularProgressIndicator(
      color: Colors.orangeAccent,
    ));
  }

  void loading() {
    setState(() {
      loaded = true;
    });
  }

  checkColor(String category) {
    if (category == 'Ism') return Colors.blue;
    if (category == 'Harf') return Colors.red;
    if (category == 'Fi‘l') return Colors.green;
    return Colors.black;
  }

  checkMainColor(int? id) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    if (id == 3) {
      return Color(0xffFF6106);
    }
    if (id == 68) {
      return Color(0xffFF29DD);
    }

    return (themeProvider.isDarkMode) ? Colors.white : Colors.black;
  }

  checkMainFontSize(int? id) {
    if (id == 3 || id == 68) {
      return 24;
    }
    return 20;
  }
}
