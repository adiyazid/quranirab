import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:quranirab/models/word.detail.dart';
import 'package:quranirab/provider/ayah.number.provider.dart';
import 'package:skeleton_loader/skeleton_loader.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:tree_view/tree_view.dart';

import '../models/word.detail.dart';
import '../provider/user.provider.dart';
import '../theme/theme_provider.dart';

class MoreOptionsList extends StatefulWidget {
  final String surah;
  final int wordId;

  const MoreOptionsList({
    Key? key,
    required this.wordId,
    required this.surah,
  }) : super(key: key);

  @override
  State<MoreOptionsList> createState() => _MoreOptionsListState();
}

class _MoreOptionsListState extends State<MoreOptionsList> {
  bool loaded = false;

  @override
  void initState() {
    Provider.of<AppUser>(context, listen: false).getRole();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AyaProvider>(builder: (context, aya, child) {
      List<WordDetail> parent = aya.getParent();

      return aya.loadingCategory
          ? SingleChildScrollView(
              primary: true,
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                        onPressed: () {
                          setState(() {
                            Navigator.pop(context);
                            aya.set();
                            aya.defaultSelect();
                          });
                        },
                        icon: Icon(Icons.clear)),
                  ),
                  Text(
                    aya.words ?? '',
                    style: TextStyle(
                      fontFamily: 'MeQuran2',
                      fontSize: aya.value,
                    ),
                  ),
                  const Divider(
                    thickness: 1,
                  ),
                  if (aya.wordDetail.isNotEmpty)
                    FutureBuilder<WordDetail>(
                      future: aya.getFirst(getParent(), aya.getLangID(context)),
                      builder: (
                        BuildContext context,
                        AsyncSnapshot<WordDetail> snapshot,
                      ) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator(
                            color: Colors.orangeAccent,
                          );
                        } else if (snapshot.connectionState ==
                                ConnectionState.active ||
                            snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasError) {
                            return const Text('Waiting..');
                          } else if (snapshot.hasData) {
                            return Card(
                              color: Provider.of<ThemeProvider>(context,
                                          listen: false)
                                      .isDarkMode
                                  ? Colors.blueGrey
                                  : Colors.amber,
                              child: ListTile(
                                leading: Icon(Icons.list),
                                title: Text(snapshot.data!.name ?? '',
                                    style: TextStyle(fontFamily: 'MeQuran2')),
                                subtitle: Text(snapshot.data!.childType ?? ''),
                                trailing: Text(
                                    "${aya.wordDetail.length} ${AppLocalizations.of(context)!.items}"),
                              ),
                            );
                          } else {
                            return const Text('Empty data');
                          }
                        } else {
                          return Text('State: ${snapshot.connectionState}');
                        }
                      },
                    ),
                  SizedBox(
                    height: context.height(),
                    child: TreeView(
                      startExpanded: true,
                      children: _getChildList(parent),
                    ),
                  ),
                ],
              ),
            )
          : aya.nodata
              ? Column(
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                          onPressed: aya.visible == true
                              ? () {
                                  setState(() {
                                    aya.set();
                                    aya.defaultSelect();
                                  });
                                }
                              : null,
                          icon: Icon(Icons.clear)),
                    ),
                    Spacer(),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: Text('No data')),
                    Spacer(),
                  ],
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      SkeletonLoader(
                        builder: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 15),
                              child: Container(
                                width: double.infinity,
                                height: 40,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadiusDirectional.circular(16),
                                    color: Colors.white),
                              ),
                            ),
                            const Divider(
                              thickness: 1,
                            ),
                          ],
                        ),
                        period: Duration(seconds: 2),
                        highlightColor: Color(0xffaa9f9f),
                      ),
                      SkeletonLoader(
                        builder: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          child: Container(
                            width: double.infinity,
                            height: 40,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadiusDirectional.circular(16),
                                color: Colors.white),
                          ),
                        ),
                        items: 10,
                        period: Duration(seconds: 2),
                        highlightColor: Color(0xffaa9f9f),
                        direction: SkeletonDirection.rtl,
                      ),
                    ],
                  ),
                );
    });
  }

  checkColor(String category) {
    if (category == 'Ism') return Colors.blue;
    if (category == 'Harf') return Colors.red;
    if (category == 'Fi‘l') return Colors.green;
    return Colors.black;
  }

  List<Widget> _getChildList(
    List<WordDetail> childDocuments,
  ) {
    return childDocuments.map((document) {
      if (document.isparent! || document.hasChild!) {
        return Container(
          margin: EdgeInsets.only(left: 8),
          child: TreeViewChild(
            startExpanded: document.hasChild! ? false : true,
            parent: _getDocumentWidget(
                document: document,
                list: Provider.of<AyaProvider>(context, listen: false)
                    .getSubList(document.categoryId!, document.parent!)),
            children: _getChildList(
              Provider.of<AyaProvider>(context, listen: false)
                  .getSubList(document.categoryId!, document.parent!),
            ),
          ),
        );
      }
      return Container(
        margin: const EdgeInsets.only(left: 4.0),
        child: _getDocumentWidget(document: document, list: []),
      );
    }).toList();
  }

  Widget _getDocumentWidget(
          {required WordDetail document, required List<WordDetail> list}) =>
      document.isparent!
          ? Card(
              color:
                  Provider.of<ThemeProvider>(context, listen: false).isDarkMode
                      ? Color(0xff4C6A7A)
                      : Color(0xffE0BD61),
              child: ListTile(
                leading: Icon(Icons.navigate_next),
                title: Text(
                  '(${document.parent})' + document.name!,
                  style: TextStyle(fontFamily: 'MeQuran2'),
                ),
                subtitle: Text(document.childType!),
                trailing: Provider.of<AppUser>(context, listen: false).role ==
                        'tester'
                    ? IconButton(
                        onPressed: () async {
                          List<WordDetail> categories = [];
                          final wordCategories = FirebaseFirestore.instance
                              .collection("word_categories");
                          await wordCategories
                              .where('ancestry',
                                  isEqualTo: document.childType == 'all'
                                      ? '${document.parent}'
                                      : '${document.parent}' +
                                          '/${document.categoryId}')
                              .get()
                              .then((QuerySnapshot querySnapshot) async {
                            for (var doc in querySnapshot.docs) {
                              var name = await Provider.of<AyaProvider>(context,
                                      listen: false)
                                  .getCategoryNameTranslation(
                                      doc['id'],
                                      Provider.of<AyaProvider>(context,
                                              listen: false)
                                          .getLangID(context));
                              categories.add(WordDetail(
                                  childType: doc["child_type"],
                                  parent: doc["ancestry"] ?? '',
                                  name: name,
                                  word_type: doc['word_type'] ?? 'None',
                                  categoryId: int.parse(doc['id'])));
                            }
                          });

                          await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Center(
                                    child: Text(
                                  'Type: ' + document.childType!,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    decoration: TextDecoration.underline,
                                  ),
                                )),
                                content:
                                    alertDialogContent(document, categories),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text("Cancel"),
                                  ),
                                  ElevatedButton(
                                      onPressed: () async {
                                        await showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text('Confirm Changes?'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text("No"),
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text("Yes"),
                                                  ),
                                                ],
                                              );
                                            });
                                      },
                                      child: Text('Save')),
                                ],
                              );
                            },
                          );
                        },
                        icon: Icon(
                          Icons.edit,
                          color: Colors.white70,
                        ),
                      )
                    : Text(
                        "${list.length} ${AppLocalizations.of(context)!.items}"),
              ),
            )
          : list.isNotEmpty
              ? Card(
                  color: Provider.of<ThemeProvider>(context, listen: false)
                          .isDarkMode
                      ? Color(0xff808BA1)
                      : Color(0xffFCD77A),
                  child: ListTile(
                    leading: Icon(Icons.arrow_right),
                    title: Text(
                      '(${document.parent}) ${document.name} ',
                      style: TextStyle(fontFamily: 'MeQuran2'),
                    ),
                    subtitle: Text(document.childType!),
                    trailing: Provider.of<AppUser>(context, listen: false)
                                .role ==
                            'tester'
                        ? IconButton(
                            onPressed: () async {
                              List<WordDetail> categories = [];
                              final wordCategories = FirebaseFirestore.instance
                                  .collection("word_categories");
                              await wordCategories
                                  .where('ancestry',
                                      isEqualTo: document.childType == 'all'
                                          ? '${document.parent}'
                                          : '${document.parent}' +
                                              '/${document.categoryId}')
                                  .get()
                                  .then((QuerySnapshot querySnapshot) async {
                                for (var doc in querySnapshot.docs) {
                                  var name = await Provider.of<AyaProvider>(
                                          context,
                                          listen: false)
                                      .getCategoryNameTranslation(
                                          doc['id'],
                                          Provider.of<AyaProvider>(context,
                                                  listen: false)
                                              .getLangID(context));
                                  categories.add(WordDetail(
                                      childType: doc["child_type"],
                                      parent: doc["ancestry"] ?? '',
                                      name: name,
                                      word_type: doc['word_type'] ?? 'None',
                                      categoryId: int.parse(doc['id'])));
                                }
                              });

                              _childAlertDialog(document, categories);
                            },
                            icon: Icon(
                              document.hasChild! ? Icons.edit : Icons.remove,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            "${list.length} ${AppLocalizations.of(context)!.items}"),
                  ),
                )
              : ListTile(
                  leading: Icon(Icons.east),
                  title: Text(document.name!,
                      style: TextStyle(fontFamily: 'MeQuran2')),
                  subtitle: Text(document.childType!),
                  trailing: IconButton(
                    onPressed: () async {
                      await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Confirm Delete?'),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('No')),
                                ElevatedButton(
                                    onPressed: () async {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Yes')),
                              ],
                            );
                          });
                    },
                    icon: Icon(Icons.remove),
                  ));

  getParent() {
    var parent = "";
    List<WordDetail> _list =
        Provider.of<AyaProvider>(context, listen: false).wordDetail;
    for (var element in _list) {
      if (element.categoryId == 2 ||
          element.categoryId == 328 ||
          element.categoryId == 426) {
        parent = element.parent ?? '';
      }
    }
    return parent;
  }

  _childAlertDialog(WordDetail document, List<WordDetail> categories) async {
    if (document.hasChild!) {
      await showDialog(
          context: context,
          builder: (BuildContext context) {
            return StatefulBuilder(builder: (context, setState) {
              return AlertDialog(
                title: Center(
                    child: Text(
                  'Type: ' + document.childType!,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    decoration: TextDecoration.underline,
                  ),
                )),
                content: alertDialogContent(document, categories),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel')),
                  ElevatedButton(
                    onPressed: () async {
                      await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Confirm Changes?'),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('No')),
                                ElevatedButton(
                                    onPressed: () async {
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Yes')),
                              ],
                            );
                          });
                    },
                    child: Text('Save'),
                  ),
                ],
              );
            });
          });
    } else {
      await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Confirm Delete?'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('No')),
                ElevatedButton(
                    onPressed: () async {
                      Navigator.pop(context);
                    },
                    child: const Text('Yes')),
              ],
            );
          });
    }
  }

  Widget alertDialogContent(WordDetail data, List<WordDetail> categories) {
    if (data.childType == 'all') {
      List<String> list = [];
      for (var element in categories) {
        list.add(element.name ?? '');
      }
      return DropdownSearch<String>(
        popupProps: PopupProps.dialog(
          showSelectedItems: true,
          itemBuilder: _style1,
          dialogProps: DialogProps(
            contentTextStyle: TextStyle(fontFamily: 'MeQuran2', fontSize: 24),
          ),
          showSearchBox: true,
          textStyle: TextStyle(fontFamily: 'MeQuran2', fontSize: 24),
        ),
        dropdownBuilder: _style,
        dropdownDecoratorProps: DropDownDecoratorProps(
          dropdownSearchDecoration: InputDecoration(
            labelText:
                "Word detail from parent ${data.parent!.split('/').last}",
          ),
        ),
        items: list,
        onChanged: (String? value) {
          print(value);
        },
        selectedItem: data.name,
      );
    } else if (data.childType == 'multiple') {
      List<bool> value = [];
      List<WordDetail> data =
          Provider.of<AyaProvider>(context, listen: false).wordDetail;
      categories.forEach((element) {
        if (data.any((elements) =>
            elements.name!.toLowerCase() == element.name!.toLowerCase())) {
          value.add(true);
        } else {
          value.add(false);
        }
      });
      return StatefulBuilder(
        builder: (context, setState) {
          return SizedBox(
            height: 300.0,
            width: 300.0,
            child: Consumer<AyaProvider>(builder: (context, aya, child) {
              return ListView.builder(
                itemCount: categories.length,
                itemBuilder: (BuildContext context, int index) {
                  return CheckboxListTile(
                    onChanged: (v) {
                      setState(() {
                        value[index] = v!;
                      });
                    },
                    value: value[index],
                    title: Text(categories[index].name!),
                  );
                },
              );
            }),
          );

          ///
          // return Column(
          //   children: [
          //     for (int i = 0; i < _value.length; i++)
          //       Row(
          //         mainAxisAlignment: MainAxisAlignment.center,
          //         children: [
          //           Flexible(
          //             child: Text(
          //               categories[i]['tname'],
          //               style: const TextStyle(fontSize: 17.0),
          //             ),
          //           ),
          //           const SizedBox(width: 10),
          //           Checkbox(
          //               value: _value[i],
          //               onChanged: (bool? value) {
          //                 setState(() {
          //                   _value[i] = value!;
          //                 });
          //               }),
          //         ],
          //       ),
          //   ],
          // );
          ///
        },
      );
    } else if (data.childType == 'unique') {
      var gvalue;
      List<bool> value = [];
      List<WordDetail> data =
          Provider.of<AyaProvider>(context, listen: false).wordDetail;
      categories.forEach((element) {
        if (data.any((elements) =>
            elements.name!.toLowerCase() == element.name!.toLowerCase())) {
          value.add(false);
        } else {
          value.add(true);
        }
      });

      return StatefulBuilder(builder: (context, setState) {
        return SizedBox(
          height: 300.0,
          width: 300.0,
          child: Consumer<AyaProvider>(builder: (context, aya, child) {
            return ListView.builder(
              itemCount: categories.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(categories[index].name!),
                  trailing: Radio(
                    value: categories[index],
                    onChanged: (v) {
                      print(v);
                      setState(() {
                        gvalue = v;
                      });
                    },
                    groupValue: gvalue,
                  ),
                );
              },
            );
          }),
        );
      });
    } else {
      return SizedBox(
        height: 100.0,
        width: 100.0,
      );
    }
  }

  Future<dynamic> popUp(WordDetail document, List<WordDetail> label) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          List<String> list = [];
          for (var element in label) {
            list.add(element.name ?? '');
          }
          String? data = '';
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            child: AlertDialog(
              content: DropdownSearch<String>(
                popupProps: PopupProps.dialog(
                  showSelectedItems: true,
                  itemBuilder: _style1,
                  dialogProps: DialogProps(
                    contentTextStyle:
                        TextStyle(fontFamily: 'MeQuran2', fontSize: 24),
                  ),
                  showSearchBox: true,
                  textStyle: TextStyle(fontFamily: 'MeQuran2', fontSize: 24),
                ),
                dropdownBuilder: _style,
                dropdownDecoratorProps: DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    labelText:
                        "Word detail from parent ${document.parent!.split('/').last}",
                  ),
                ),
                items: list,
                onChanged: (String? value) {
                  setState(() {
                    data = value;
                  });
                },
                selectedItem: document.name,
              ),
              actions: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.clear)),
                IconButton(
                    onPressed: () async {
                      for (var element in label) {
                        if (data == element.name) {
                          if (element.childType == "all") {
                            Provider.of<AyaProvider>(context, listen: false)
                                .removeAll();
                            Provider.of<AyaProvider>(context, listen: false)
                                .addDetail(element);
                            print(element.categoryId);
                            await Provider.of<AyaProvider>(context,
                                    listen: false)
                                .replace(element, document.id);
                            List<WordDetail> child =
                                await Provider.of<AyaProvider>(
                                        context,
                                        listen: false)
                                    .getChild(
                                        element.categoryId!,
                                        element.parent!,
                                        Provider.of<AyaProvider>(context,
                                                listen: false)
                                            .getLangID(context));

                            /*Provider.of<AyaProvider>(context,
                                 listen: false)
                                 .getParent();*/
                            //PopUpData(id: widget.id,
                            // child: child,);
                            print(child);
                          } else {
                            throw UnimplementedError();
                          }
                        }
                      }
                      showTopSnackBar(
                        context,
                        const CustomSnackBar.success(
                          message: 'Data updated',
                        ),
                      );
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.check))
              ],
            ),
          );
        });
  }

  Widget _style(BuildContext context, String? selectedItem) {
    return Text(
      selectedItem!,
      style: TextStyle(fontFamily: 'MeQuran2'),
    );
  }

  Widget _style1(BuildContext context, String? item, bool isSelected) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          item!,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontFamily: 'MeQuran2',
              color: isSelected ? Colors.cyanAccent : Colors.amber,
              fontSize: 24),
        ),
      ),
    );
  }
}
