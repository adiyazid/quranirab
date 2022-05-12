import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quranirab/provider/ayah.number.provider.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class EditData extends StatefulWidget {
  final int wordId;

  const EditData(this.wordId, {Key? key, wordID}) : super(key: key);

  @override
  State<EditData> createState() => _EditDataState();
}

class _EditDataState extends State<EditData> {
  var i = 0;

  final _c1 = ScrollController();
  final _c2 = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AyaProvider>(builder: (context, aya, child) {
      var list = aya.wordDetail;
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orangeAccent,
          title: Consumer<AyaProvider>(builder: (context, no, child) {
            return Text(
                'Total word detail ${no.wordName.length} for word ID ${aya.wordID}');
          }),
          centerTitle: true,
        ),
        body: aya.parent.isEmpty
            ? Center(
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                      'Loading data ${((aya.labelCategory.length / 37.0) * 100.0).toStringAsFixed(2)} %')
                ],
              ))
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.35,
                        child: ListView.builder(
                          controller: _c1,
                          itemCount: list.length,
                          itemBuilder: (BuildContext context, int index) {
                            return aya.wordDetail[index].type != 'label' &&
                                    aya.wordDetail[index].type != 'main-label'
                                ? Card(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 8),
                                    child: ListTile(
                                        leading: Text(
                                          aya.wordDetail[index].categoryId
                                              .toString(),
                                        ),
                                        title: Text(
                                          aya.wordDetail[index].name!,
                                          style: TextStyle(
                                              fontFamily: 'MeQuran2',
                                              fontSize: 24),
                                        ),
                                        subtitle: Text(
                                            aya.wordDetail[index].type ??
                                                'Left-side'),
                                        trailing: aya.wordDetail[index].type !=
                                                'main'
                                            ? IconButton(
                                                icon: Icon(Icons.edit),
                                                onPressed: () {
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        List<String> list = [];

                                                        if (aya
                                                                .wordDetail[
                                                                    index]
                                                                .type ==
                                                            'label') {
                                                          aya.labelCategory
                                                              .forEach(
                                                                  (element) {
                                                            list.add(
                                                                element.name!);
                                                          });
                                                        } else if (aya
                                                                .wordDetail[
                                                                    index]
                                                                .type ==
                                                            'main-label') {
                                                          aya.mainCategory
                                                              .forEach(
                                                                  (element) {
                                                            list.add(
                                                                element.name!);
                                                          });
                                                        } else {
                                                          aya.noCategory
                                                              .forEach(
                                                                  (element) {
                                                            list.add(
                                                                element.name!);
                                                          });
                                                        }
                                                        String? data = '';
                                                        return SizedBox(
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.4,
                                                          child: AlertDialog(
                                                            content:
                                                                DropdownSearch<
                                                                    String>(
                                                              dropdownSearchBaseStyle:
                                                                  TextStyle(
                                                                      fontFamily:
                                                                          'MeQuran2'),
                                                              showSearchBox:
                                                                  true,
                                                              mode: Mode.DIALOG,
                                                              showSelectedItems:
                                                                  true,
                                                              dropdownBuilder:
                                                                  _style,
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
                                                                  (String?
                                                                      value) {
                                                                setState(() {
                                                                  data = value;
                                                                });
                                                              },
                                                              selectedItem: aya
                                                                  .wordDetail[
                                                                      index]
                                                                  .name,
                                                            ),
                                                            actions: [
                                                              Center(
                                                                child:
                                                                    ElevatedButton(
                                                                        onPressed:
                                                                            () {
                                                                          aya.replace(
                                                                              data,
                                                                              index,
                                                                              aya.wordDetail[index].type,
                                                                              aya.wordDetail[index].id,
                                                                              context);
                                                                          Navigator.pop(
                                                                              context);
                                                                          if (aya
                                                                              .success) {
                                                                            showTopSnackBar(
                                                                              context,
                                                                              CustomSnackBar.success(
                                                                                message: 'Update Success',
                                                                              ),
                                                                            );
                                                                          }
                                                                        },
                                                                        child: Text(
                                                                            'Confirm Changes')),
                                                              )
                                                            ],
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
                        width: MediaQuery.of(context).size.width * 0.35,
                        child: ListView.builder(
                          controller: _c2,
                          itemCount: list.length,
                          itemBuilder: (BuildContext context, int index) {
                            if (index == 0) {
                              return Card(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 8),
                                child: ListTile(
                                  leading: Text('0'),
                                  title: Text(
                                    'نوع الكلمة',
                                    style: TextStyle(
                                        fontFamily: 'MeQuran2', fontSize: 24),
                                  ),
                                  subtitle: Text('fixed value'),
                                ),
                              );
                            }
                            return aya.wordDetail[index].type == 'label' ||
                                    aya.wordDetail[index].type == 'main-label'
                                ? Card(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 8),
                                    child: ListTile(
                                      leading: Text(
                                        aya.wordDetail[index].categoryId
                                            .toString(),
                                      ),
                                      title: Text(
                                        aya.wordDetail[index].name!,
                                        style: TextStyle(
                                            fontFamily: 'MeQuran2',
                                            fontSize: 24),
                                      ),
                                      subtitle: Text(
                                          aya.wordDetail[index].type ??
                                              'Left-side'),
                                      trailing: aya.wordDetail[index].type !=
                                              'main'
                                          ? IconButton(
                                              icon: Icon(Icons.edit),
                                              onPressed: () {
                                                showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      List<String> list = [];
                                                      if (aya.wordDetail[index]
                                                              .type ==
                                                          'label') {
                                                        aya.labelCategory
                                                            .forEach((element) {
                                                          list.add(
                                                              element.name!);
                                                        });
                                                      } else if (aya
                                                              .wordDetail[index]
                                                              .type ==
                                                          'main-label') {
                                                        aya.mainCategory
                                                            .forEach((element) {
                                                          list.add(
                                                              element.name!);
                                                        });
                                                      } else {
                                                        aya.noCategory
                                                            .forEach((element) {
                                                          list.add(
                                                              element.name!);
                                                        });
                                                      }
                                                      String? data = '';
                                                      return SizedBox(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.4,
                                                        child: AlertDialog(
                                                          content:
                                                              DropdownSearch<
                                                                  String>(
                                                            dropdownSearchBaseStyle:
                                                                TextStyle(
                                                                    fontFamily:
                                                                        'MeQuran2'),
                                                            showSearchBox: true,
                                                            mode: Mode.DIALOG,
                                                            showSelectedItems:
                                                                true,
                                                            dropdownBuilder:
                                                                _style,
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
                                                            onChanged: (String?
                                                                value) {
                                                              setState(() {
                                                                data = value;
                                                              });
                                                            },
                                                            selectedItem: aya
                                                                .wordDetail[
                                                                    index]
                                                                .name,
                                                          ),
                                                          actions: [
                                                            Center(
                                                              child:
                                                                  ElevatedButton(
                                                                      onPressed:
                                                                          () {
                                                                        aya.replace(
                                                                            data,
                                                                            index,
                                                                            aya.wordDetail[index].type,
                                                                            aya.wordDetail[index].id,
                                                                            context);
                                                                        Navigator.pop(
                                                                            context);
                                                                        if (aya
                                                                            .success) {
                                                                          showTopSnackBar(
                                                                            context,
                                                                            CustomSnackBar.success(
                                                                              message: 'Update Success',
                                                                            ),
                                                                          );
                                                                        }
                                                                      },
                                                                      child: Text(
                                                                          'Confirm Changes')),
                                                            )
                                                          ],
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

  Future<void> init() async {
    await Provider.of<AyaProvider>(context, listen: false).getAllLabel();
  }
}
