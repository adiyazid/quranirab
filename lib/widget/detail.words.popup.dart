import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/word.detail.dart';
import '../provider/ayah.number.provider.dart';
import '../provider/user.provider.dart';
import '../theme/theme_provider.dart';
import '../views/data_correction/edit.data.dart';

class ListItems extends StatefulWidget {
  final String text;
  final int wordId;

  const ListItems(this.text, this.wordId, {Key? key}) : super(key: key);

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
    Provider.of<AppUser>(context, listen: false).getRole();
    var role = Provider.of<AppUser>(context, listen: false).role;
    return Scrollbar(
      child: Consumer<AyaProvider>(builder: (context, aya, child) {
        List<WordDetail> word = aya.getWordTypeList() ?? <WordDetail>[];
        List<WordDetail> name = aya.getWordNameList() ?? <WordDetail>[];
        for (var item in name) {
          for (var element in word) {
            if (element.categoryId == item.categoryId) {
              item.type = element.type;
            }
          }
        }
        // name.sort((a, b) => a.categoryId!.compareTo(b.categoryId!));
        var newPosition;
        var newPosition2;
        WordDetail old;
        WordDetail old2;
        if (name.isNotEmpty) {
          for (int i = 0; i < name.length; i++) {
            if (name[i].categoryId == 68) {
              newPosition = i + 1;
            }
            if (name[i].categoryId == 429) {
              newPosition2 = i + 1;
            }
            if (name[i].categoryId == 495 && newPosition2 != null) {
              old2 = name[i];
              name.removeAt(i);
              name.insertAll(newPosition2, [old2]);
            }
            if (name[i].categoryId == 1426 && newPosition != null) {
              old = name[i];
              name.removeAt(i);
              name.insertAll(newPosition, [old]);
            }
          }
          aya.updateLoad();
        }
        return aya.loadingCategory
            ? SizedBox(
                height: MediaQuery.of(context).size.height * 0.25,
                child: Column(
                  children: [
                    if (role == 'tester')
                      Center(
                        child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          EditData(widget.wordId)));
                            },
                            child: Text('Edit')),
                      ),
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Text(
                                    widget.text
                                        .replaceAll('ﲿ', '')
                                        .replaceAll('ﲹ', '')
                                        .replaceAll('ﲬ', '')
                                        .replaceAll('ﲨ', ''),
                                    style: TextStyle(
                                        fontSize: 24, fontFamily: 'MeQuran2'),
                                  ),
                                ),
                              ),
                            )),
                      ],
                    ),
                    Divider(
                      thickness: 2,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.2,
                      child: ListView.builder(
                        itemCount: name.last.type != "label"
                            ? name.length - 1
                            : name.length,
                        itemBuilder: (BuildContext context, int index) {
                          return name.isNotEmpty
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                        ? Expanded(
                                            flex: 3,
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Container(
                                                  height: 64,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadiusDirectional
                                                            .circular(8),
                                                  ),
                                                  child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child:
                                                          SingleChildScrollView(
                                                        child: Text(
                                                          "${index + 1 < name.length ? name[index + 1].name : ''}",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'MeQuran2',
                                                              fontSize: 20),
                                                          textAlign:
                                                              TextAlign.left,
                                                        ),
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        reverse: true,
                                                      )),
                                                ),
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
                                                  child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        "${name[index].name}",
                                                        style: TextStyle(
                                                            color: checkColor(
                                                                aya.category),
                                                            fontFamily:
                                                                'MeQuran2',
                                                            fontSize: 20),
                                                        textAlign:
                                                            TextAlign.left,
                                                      )),
                                                ),
                                              )
                                            : Spacer(
                                                flex: 3,
                                              ),
                                    // Spacer(),
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
                                      Expanded(
                                        flex: 3,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            height: 64,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadiusDirectional
                                                      .circular(8),
                                            ),
                                            child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: SingleChildScrollView(
                                                  child: Text(
                                                    "${name[index].name}",
                                                    style: TextStyle(
                                                        fontSize:
                                                            checkMainFontSize(
                                                                name[index].id),
                                                        fontFamily: 'MeQuran2',
                                                        color: checkMainColor(
                                                            name[index].id)),
                                                    textAlign: TextAlign.end,
                                                  ),
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  reverse: true,
                                                )),
                                          ),
                                        ),
                                      ),
                                  ],
                                )
                              : Container();
                        },
                      ),
                    ),
                  ],
                ),
              )
            : Center(
                child: CircularProgressIndicator(
                color: Colors.orangeAccent,
              ));
      }),
    );
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
