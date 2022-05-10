import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quranirab/models/word.detail.dart';
import 'package:quranirab/provider/ayah.number.provider.dart';

class EditData extends StatefulWidget {
  const EditData({Key? key}) : super(key: key);

  @override
  State<EditData> createState() => _EditDataState();
}

class _EditDataState extends State<EditData> {
  var i = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer<AyaProvider>(builder: (context, aya, child) {
      var list = aya.wordName;
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orangeAccent,
          title: Consumer<AyaProvider>(builder: (context, no, child) {
            return Text('No of word detail ${no.wordName.length}');
          }),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            children: [
              Spacer(),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
                height: MediaQuery.of(context).size.height * 0.55,
                child: ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      margin: EdgeInsets.all(16),
                      child: ListTile(
                        leading: Text(
                          aya.wordName[index].categoryId.toString(),
                        ),
                        title: Text(
                          aya.wordName[index].name!,
                          style:
                              TextStyle(fontFamily: 'MeQuran2', fontSize: 24),
                        ),
                        trailing: SizedBox(
                          width: 80,
                          child: Row(
                            children: [
                              IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          List<String> list = [];
                                          aya.allCategory.forEach((element) {
                                            list.add(element.name!);
                                          });
                                          return SizedBox(
                                            height: 300,
                                            child: AlertDialog(
                                              content: DropdownSearch<String>(
                                                dropdownSearchBaseStyle:
                                                    TextStyle(
                                                        fontFamily: 'MeQuran2'),
                                                showSearchBox: true,
                                                mode: Mode.DIALOG,
                                                showSelectedItems: true,
                                                dropdownBuilder: _style,
                                                popupItemBuilder: _style1,
                                                items: list,
                                                dropdownSearchDecoration:
                                                    InputDecoration(
                                                  labelText: "Word Detail",
                                                  hintText: "word type detail",
                                                ),
                                                onChanged: (String? value) {
                                                  aya.replace(value, index);
                                                },
                                                selectedItem:
                                                    aya.wordName[index].name,
                                              ),
                                              actions: [
                                                ElevatedButton(
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                  child: Text('Back'),
                                                ),
                                              ],
                                            ),
                                          );
                                        });
                                  }),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  if (aya.wordName.length > 1) {
                                    aya.removeDetail(index);
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                  child: IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  aya.addDetail(WordDetail(
                      name: aya.allCategory[i].name,
                      type: aya.allCategory[i].type,
                      categoryId: aya.allCategory[i].categoryId));
                  i++;
                },
              ))
            ],
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
