import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quranirab/provider/ayah.number.provider.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:tree_view/tree_view.dart';

import '../../models/word.detail.dart';
import '../../theme/theme_provider.dart';

class EditData extends StatefulWidget {
  final int wordId;

  const EditData(this.wordId, {Key? key, wordID}) : super(key: key);

  @override
  State<EditData> createState() => _EditDataState();
}

class _EditDataState extends State<EditData> {
  var i = 0;

  @override
  void initState() {
    // TODO: implement initState

    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AyaProvider>(builder: (context, aya, child) {
      List<WordDetail> parent = aya.getParent();
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orangeAccent,
          title: Consumer<AyaProvider>(builder: (context, no, child) {
            return Text(
                'Total word detail ${no.wordDetail.length} for word ID ${aya.wordID}');
          }),
          centerTitle: true,
        ),
        body: TreeView(startExpanded: true, children: _getChildList(parent)),
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

  Future<void> init() async {}

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
                  title: Text(document.name!),
                  subtitle: Text('ID: ${document.categoryId}'),
                  trailing: Text("${list.length} items")))
          : list.isNotEmpty
              ? Card(
                  color: Provider.of<ThemeProvider>(context, listen: false)
                          .isDarkMode
                      ? Color(0xff808BA1)
                      : Color(0xffFCD77A),
                  child: ListTile(
                      leading: Icon(Icons.arrow_right),
                      title: Text(document.name!),
                      subtitle: Text('ID: ${document.categoryId}'),
                      trailing: IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () async {
                          List<WordDetail> label =
                              await Provider.of<AyaProvider>(context,
                                      listen: false)
                                  .getList(document.parent ?? '');
                          popUp(document, label);
                        },
                      )),
                )
              : ListTile(
                  leading: Icon(Icons.remove),
                  title: Text(document.name!),
                  subtitle: Text('ID: ${document.categoryId}'),
                  trailing: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () async {
                      List<WordDetail> label =
                          await Provider.of<AyaProvider>(context, listen: false)
                              .getList(document.parent ?? '');
                      popUp(document, label);
                    },
                  ));

  Future<dynamic> popUp(WordDetail document, List<WordDetail> label) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          List<String> list = [];
          label.forEach((element) {
            list.add(element.name ?? '');
          });
          String? data = '';
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            child: AlertDialog(
              content: DropdownSearch<String>(
                dropdownSearchBaseStyle: TextStyle(fontFamily: 'MeQuran2'),
                showSearchBox: true,
                mode: Mode.DIALOG,
                showSelectedItems: true,
                dropdownBuilder: _style,
                popupItemBuilder: _style1,
                items: list,
                dropdownSearchDecoration: InputDecoration(
                  labelText:
                      "Word detail from parent ${document.parent!.split('/').last}",
                ),
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
                      for (var element in label){
                        if (data == element.name) {
                          await Provider.of<AyaProvider>(context, listen: false)
                              .replace(element, document.id);
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
}
