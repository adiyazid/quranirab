import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quranirab/provider/ayah.number.provider.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../models/word.detail.dart';

class EditData extends StatefulWidget {
  final int id;
  const EditData({required this.id, Key? key}) : super(key: key);

  @override
  State<EditData> createState() => _EditDataState();
}

class _EditDataState extends State<EditData> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Id ${widget.id}'),
        ),
        body: Consumer<AyaProvider>(builder: (context, aya, child) {
          return ListView.builder(
            itemCount: aya.wordDetail.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                onTap: () async {

                  List<WordDetail> label =
                  await Provider.of<AyaProvider>(context,
                      listen: false)
                      .getList(
                      aya.wordDetail[index].parent ?? '',
                      Provider.of<AyaProvider>(context,
                          listen: false)
                          .getLangID(context));
                              popUp(aya.wordDetail[index],label,);
                },
                title: Text('${aya.wordDetail[index].name}'),
                subtitle: Text('${aya.wordDetail[index].childType}'),
              );
            },
          );
        }));
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
                        if (data == element.name ) {
                          if(element.childType == "all"){
                             Provider.of<AyaProvider>(context, listen: false)
                                .removeAll();
                             Provider.of<AyaProvider>(context, listen: false)
                                 .addDetail(element);
                             print(element.categoryId);
                          await Provider.of<AyaProvider>(context, listen: false)
                          .replace(element, document.id);
                             List<WordDetail> child =
                             await Provider.of<AyaProvider>(context,
                                 listen: false)
                                 .getChild(
                                 element.categoryId!, element.parent!,
                                 Provider.of<AyaProvider>(context,
                                     listen: false)
                                     .getLangID(context));
                              /*Provider.of<AyaProvider>(context,
                                 listen: false)
                                 .getParent();*/
                             //PopUpData(id: widget.id,
                              // child: child,);
                             print(child);
                        }
                        else{throw UnimplementedError();}}
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
