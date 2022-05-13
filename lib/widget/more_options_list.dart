import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quranirab/provider/ayah.number.provider.dart';
import 'package:skeleton_loader/skeleton_loader.dart';
import 'package:tree_view/tree_view.dart';

import '../models/word.detail.dart';
import '../provider/user.provider.dart';
import '../theme/theme_provider.dart';
import '../views/data_correction/edit.data.dart';

class MoreOptionsList extends StatefulWidget {
  final String surah;
  final String nukKalimah;
  final int wordId;

  const MoreOptionsList({
    Key? key,
    required this.wordId,
    required this.nukKalimah,
    required this.surah,
  }) : super(key: key);

  @override
  State<MoreOptionsList> createState() => _MoreOptionsListState();
}

class _MoreOptionsListState extends State<MoreOptionsList> {
  bool loaded = false;

  @override
  void initState() {
    // TODO: implement initState
    Provider.of<AppUser>(context, listen: false).getRole();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var role = Provider.of<AppUser>(context).role;

    return Consumer<AyaProvider>(builder: (context, aya, child) {
      List<WordDetail> parent = aya.getParent();
      aya.updateLoad();
      return aya.loadingCategory
          ? Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                  child: Row(
                    children: [
                      TextButton(
                          onPressed: () {
                            aya.set();
                          },
                          child: Text('Close')),
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
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: TreeView(
                    startExpanded: false,
                    children: _getChildList(parent),
                  ),
                ),
              ],
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
              : Column(
                  children: [
                    SkeletonLoader(
                        builder: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: IconButton(
                              onPressed: () {}, icon: Icon(Icons.clear)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Directionality(
                              textDirection: TextDirection.rtl,
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadiusDirectional.circular(16)),
                                height: 30,
                                width: 100,
                              )),
                        ),
                        const Divider(
                          thickness: 1,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadiusDirectional.circular(16)),
                                height: 30,
                                width: 100,
                              ),
                              Spacer(),
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadiusDirectional.circular(16)),
                                height: 30,
                                width: 100,
                              )
                            ],
                          ),
                        )
                      ],
                    )),
                    SkeletonLoader(
                      builder: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadiusDirectional.circular(
                                                16),
                                        color: Colors.white),
                                    width: double.infinity,
                                    height: 35,
                                  ),
                                ],
                              ),
                            ),
                            Spacer(),
                            Expanded(
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    width: double.infinity,
                                    height: 35,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadiusDirectional.circular(
                                                16),
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      items: 13,
                      period: Duration(seconds: 2),
                      highlightColor: Color(0xffaa9f9f),
                      direction: SkeletonDirection.rtl,
                    ),
                  ],
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
                title: Text(document.name!),
                trailing: Text("${list.length} items"),
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
                      title: Text(document.name!),
                      trailing: Text("${list.length} items")),
                )
              : ListTile(
                  leading: Icon(Icons.remove),
                  title: Text(document.name!),
                );
}
