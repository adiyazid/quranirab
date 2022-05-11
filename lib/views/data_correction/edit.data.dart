import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quranirab/provider/ayah.number.provider.dart';

import '../../provider/language.provider.dart';

class EditData extends StatefulWidget {
  final int wordId;

  const EditData(this.wordId, {Key? key}) : super(key: key);

  @override
  State<EditData> createState() => _EditDataState();
}

class _EditDataState extends State<EditData> {
  var i = 0;

  var _c1;
  var _c2;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AyaProvider>(builder: (context, aya, child) {
      var list = aya.wordName;
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orangeAccent,
          title: Consumer<AyaProvider>(builder: (context, no, child) {
            return Text(
                'Total word detail ${no.wordName.length} | WORD ID = ${aya.wordID}');
          }),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 500,
                  child: ListView.builder(
                    controller: _c1,
                    itemCount: list.length,
                    itemBuilder: (BuildContext context, int index) {
                      return aya.wordName[index].type != 'label'
                          ? Card(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 8),
                              child: ListTile(
                                  leading: Text(
                                    aya.wordName[index].categoryId.toString(),
                                  ),
                                  title: Text(
                                    aya.wordName[index].name!,
                                    style: TextStyle(
                                        fontFamily: 'MeQuran2', fontSize: 24),
                                  ),
                                  subtitle: Text(
                                      aya.wordName[index].type ?? 'Left-side'),
                                  trailing: aya.wordName[index].type != 'main'
                                      ? IconButton(
                                          icon: Icon(Icons.edit),
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  List<String> list = [];

                                                  aya.noCategory
                                                      .forEach((element) {
                                                    list.add(element.name!);
                                                  });
                                                  return SizedBox(
                                                    height: 300,
                                                    child: AlertDialog(
                                                      content: DropdownSearch<
                                                          String>(
                                                        dropdownSearchBaseStyle:
                                                            TextStyle(
                                                                fontFamily:
                                                                    'MeQuran2'),
                                                        showSearchBox: true,
                                                        mode: Mode.DIALOG,
                                                        showSelectedItems: true,
                                                        dropdownBuilder: _style,
                                                        popupItemBuilder:
                                                            _style1,
                                                        items: list,
                                                        dropdownSearchDecoration:
                                                            InputDecoration(
                                                          labelText:
                                                              "Word Detail",
                                                          hintText:
                                                              "word type detail",
                                                        ),
                                                        onChanged:
                                                            (String? value) {
                                                          aya.replace(
                                                              value,
                                                              index,
                                                              aya
                                                                  .wordName[
                                                                      index]
                                                                  .type,
                                                              aya
                                                                  .wordName[
                                                                      index]
                                                                  .id);
                                                        },
                                                        selectedItem: aya
                                                            .wordName[index]
                                                            .name,
                                                      ),
                                                    ),
                                                  );
                                                });
                                          })
                                      : null),
                            )
                          : Container();
                    },
                  ),
                ),
                SizedBox(
                  width: 500,
                  child: ListView.builder(
                    controller: _c2,
                    itemCount: list.length,
                    itemBuilder: (BuildContext context, int index) {
                      return aya.wordName[index].type == 'label'
                          ? Card(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 8),
                              child: ListTile(
                                leading: Text(
                                  aya.wordName[index].categoryId.toString(),
                                ),
                                title: Text(
                                  aya.wordName[index].name!,
                                  style: TextStyle(
                                      fontFamily: 'MeQuran2', fontSize: 24),
                                ),
                                subtitle: Text(
                                    aya.wordName[index].type ?? 'Left-side'),
                                trailing: aya.wordName[index].type != 'main'
                                    ? IconButton(
                                        icon: Icon(Icons.edit),
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                List<String> list = [];
                                                aya.noCategory
                                                    .forEach((element) {
                                                  list.add(element.name!);
                                                });
                                                return SizedBox(
                                                  height: 300,
                                                  child: AlertDialog(
                                                    content:
                                                        DropdownSearch<String>(
                                                      dropdownSearchBaseStyle:
                                                          TextStyle(
                                                              fontFamily:
                                                                  'MeQuran2'),
                                                      showSearchBox: true,
                                                      mode: Mode.DIALOG,
                                                      showSelectedItems: true,
                                                      dropdownBuilder: _style,
                                                      popupItemBuilder: _style1,
                                                      items: list,
                                                      dropdownSearchDecoration:
                                                          InputDecoration(
                                                        labelText:
                                                            "Word Detail",
                                                        hintText:
                                                            "word type detail",
                                                      ),
                                                      onChanged:
                                                          (String? value) {
                                                        aya.replace(
                                                            value,
                                                            index,
                                                            aya.wordName[index]
                                                                .type,
                                                            aya.wordName[index]
                                                                .id);
                                                      },
                                                      selectedItem: aya
                                                          .wordName[index].name,
                                                    ),
                                                  ),
                                                );
                                              });
                                        })
                                    : null,
                              ),
                            )
                          : Container();
                    },
                  ),
                ),
              ],
            ),
          ),
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
              color: isSelected ? Colors.cyanAccent : null,
              fontSize: 24),
        ),
      ),
    );
  }
}
