import 'package:dropdown_search/dropdown_search.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quranirab/provider/ayah.number.provider.dart';
import 'package:quranirab/provider/delete.provider.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:tree_view/tree_view.dart';

import '../../models/word.detail.dart';
import '../../theme/theme_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditData extends StatefulWidget {
  final int wordId;

  const EditData(this.wordId, {Key? key, wordID}) : super(key: key);

  @override
  State<EditData> createState() => _EditDataState();
}

class _EditDataState extends State<EditData>
    with SingleTickerProviderStateMixin {
  var i = 0;
  late Animation<double> _animation;
  late AnimationController _animationController;

  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  String? _inputParent;
  String? _inputEngCat;
  String? _inputEngCat3;
  String? _inputChildType;
  String? _inputChildType3;
  String? _inputWordType;
  String? _inputWordType3;
  List<String> childType = ['unique', 'all', 'multiple', 'none'];

  List<String> wordType = ['none', 'label', 'main', 'main-label'];
  final snackBar = SnackBar(
    content: const Text('Delete Success'),
  );
  int? _catID;
  int? _catID3;

  var _inputMalayCat;
  var _inputMalayCat3;
  var _inputArabCat;
  var _inputArabCat3;

  @override
  void initState() {
    // TODO: implement initState
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 260),
    );

    final curvedAnimation =
        CurvedAnimation(curve: Curves.easeInOut, parent: _animationController);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Consumer<AyaProvider>(builder: (context, aya, child) {
      List<String> list = [];
      List<String> newList = [];

      aya.wordDetail.forEach((element) {
        list.add(element.name!);
      });
      List<WordDetail> label = [];
      List<WordDetail> parent = aya.getParent();
      return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.orangeAccent,
            title: Consumer<AyaProvider>(builder: (context, no, child) {
              return Text(
                  '${AppLocalizations.of(context)!.wordDetail} ID ${aya.wordID}');
            }),
            centerTitle: true,
          ),
          body: TreeView(startExpanded: true, children: _getChildList(parent)),

          //Init Floating Action Bubble
          floatingActionButton: FloatingActionBubble(
            // Menu items
            items: <Bubble>[
              Bubble(
                title: "Add Word Relationship",
                iconColor: Colors.white,
                bubbleColor: themeProvider.isDarkMode
                    ? Colors.blueGrey
                    : Colors.orangeAccent,
                icon: Icons.account_tree_rounded,
                titleStyle: TextStyle(fontSize: 16, color: Colors.white),
                onPress: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return StatefulBuilder(builder: (context, setState) {
                          return AlertDialog(
                            title: Text('Add New Word Relationship'),
                            content: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.5,
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    DropdownSearch<String>(
                                      validator: (value) {
                                        if (value == 'Choose parent') {
                                          return 'Please choose one parent ancestry';
                                        }
                                        return null;
                                      },
                                      popupProps: PopupProps.dialog(
                                        showSelectedItems: true,
                                        itemBuilder: _style1,
                                        dialogProps: DialogProps(
                                          contentTextStyle: TextStyle(
                                              fontFamily: 'MeQuran2',
                                              fontSize: 24),
                                        ),
                                        showSearchBox: true,
                                        textStyle: TextStyle(
                                            fontFamily: 'MeQuran2',
                                            fontSize: 24),
                                      ),
                                      dropdownBuilder: _style,
                                      items: list,
                                      dropdownDecoratorProps:
                                          const DropDownDecoratorProps(
                                        dropdownSearchDecoration:
                                            InputDecoration(
                                          labelText: "Parent Ancestry",
                                        ),
                                      ),
                                      onChanged: (String? value) {
                                        aya.wordDetail.forEach((element) async {
                                          if (element.name == value) {
                                            setState(() {
                                              _inputParent =
                                                  "${element.parent}/${element.categoryId}";
                                            });
                                          }
                                          newList.clear();

                                          label =
                                              await Provider.of<AyaProvider>(
                                                      context,
                                                      listen: false)
                                                  .getList(
                                                      _inputParent ?? '',
                                                      Provider.of<AyaProvider>(
                                                              context,
                                                              listen: false)
                                                          .getLangID(context));
                                          label.forEach((element) {
                                            if (_inputParent ==
                                                element.parent) {
                                              if (newList
                                                      .contains(element.name) ==
                                                  false) {
                                                setState(() {
                                                  newList.add(element.name!);
                                                });
                                              }
                                            }
                                          });
                                        });
                                      },
                                      selectedItem: 'Choose parent',
                                    ),
                                    if (newList.isEmpty)
                                      Text('Getting child from parent data...'),
                                    if (newList.isNotEmpty)
                                      DropdownSearch<String>(
                                          validator: (value) {
                                            if (value ==
                                                'Choose child category') {
                                              return 'Please choose one child category';
                                            }
                                            return null;
                                          },
                                          popupProps: PopupProps.dialog(
                                            showSelectedItems: true,
                                            itemBuilder: _style1,
                                            dialogProps: DialogProps(
                                              contentTextStyle: TextStyle(
                                                  fontFamily: 'MeQuran2',
                                                  fontSize: 24),
                                            ),
                                            showSearchBox: true,
                                            textStyle: TextStyle(
                                                fontFamily: 'MeQuran2',
                                                fontSize: 24),
                                          ),
                                          dropdownBuilder: _style,
                                          dropdownDecoratorProps:
                                              const DropDownDecoratorProps(
                                            dropdownSearchDecoration:
                                                InputDecoration(
                                              labelText: "Child Category",
                                            ),
                                          ),
                                          items: newList,
                                          onChanged: (String? value) async {
                                            setState(() {
                                              _inputEngCat = value;
                                              _inputMalayCat = value;
                                              _inputArabCat = value;
                                            });
                                            label.forEach((element) {
                                              if (element.name == value) {
                                                _catID = element.categoryId;
                                              }
                                            });
                                          },
                                          selectedItem:
                                              'Choose child category'),
                                    if (newList.isNotEmpty)
                                      DropdownSearch<String>(
                                          validator: (value) {
                                            if (value == 'Choose child type') {
                                              return 'Please choose one child type';
                                            }
                                            return null;
                                          },
                                          popupProps: PopupProps.dialog(
                                            showSelectedItems: true,
                                            itemBuilder: _style1,
                                            dialogProps: DialogProps(
                                              contentTextStyle: TextStyle(
                                                  fontFamily: 'MeQuran2',
                                                  fontSize: 24),
                                            ),
                                            showSearchBox: true,
                                            textStyle: TextStyle(
                                                fontFamily: 'MeQuran2',
                                                fontSize: 24),
                                          ),
                                          dropdownBuilder: _style,
                                          dropdownDecoratorProps:
                                              const DropDownDecoratorProps(
                                            dropdownSearchDecoration:
                                                InputDecoration(
                                              labelText: "Child Type",
                                            ),
                                          ),
                                          items: childType,
                                          onChanged: (String? value) {
                                            setState(() {
                                              _inputChildType = value;
                                            });
                                          },
                                          selectedItem: 'Choose child type'),
                                    if (newList.isNotEmpty)
                                      DropdownSearch<String>(
                                          validator: (value) {
                                            if (value == 'Choose word type') {
                                              return 'Please choose one word type';
                                            }
                                            return null;
                                          },
                                          popupProps: PopupProps.dialog(
                                            showSelectedItems: true,
                                            itemBuilder: _style1,
                                            dialogProps: DialogProps(
                                              contentTextStyle: TextStyle(
                                                  fontFamily: 'MeQuran2',
                                                  fontSize: 24),
                                            ),
                                            showSearchBox: true,
                                            textStyle: TextStyle(
                                                fontFamily: 'MeQuran2',
                                                fontSize: 24),
                                          ),
                                          dropdownBuilder: _style,
                                          dropdownDecoratorProps:
                                              const DropDownDecoratorProps(
                                            dropdownSearchDecoration:
                                                InputDecoration(
                                              labelText: "Word Type",
                                            ),
                                          ),
                                          items: wordType,
                                          onChanged: (String? value) {
                                            setState(() {
                                              _inputWordType = value;
                                            });
                                          },
                                          selectedItem: 'Choose word type'),
                                    ElevatedButton(
                                        onPressed: () async {
                                          // Validate returns true if the form is valid, or false otherwise.
                                          if (_formKey.currentState!
                                              .validate()) {
                                            await addData(
                                                categoryId: "$_catID",
                                                parent: _inputParent!,
                                                wordType: _inputWordType!,
                                                childType: _inputChildType!,
                                                newRel: true,
                                                engName: _inputEngCat!,
                                                malayName: _inputMalayCat!,
                                                arabName: _inputArabCat!);
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                  backgroundColor:
                                                      Colors.cyanAccent,
                                                  content:
                                                      Text('Adding Data...')),
                                            );
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                          }
                                        },
                                        child: Text('Submit'))
                                  ],
                                ),
                              ),
                            ),
                          );
                        });
                      });
                  _animationController.reverse();
                },
              ),
              // Floating action menu item
              Bubble(
                title: "Edit Word Category",
                iconColor: Colors.white,
                bubbleColor: themeProvider.isDarkMode
                    ? Colors.blueGrey
                    : Colors.orangeAccent,
                icon: Icons.edit,
                titleStyle: TextStyle(fontSize: 16, color: Colors.white),
                onPress: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return StatefulBuilder(builder: (context, setState) {
                          return AlertDialog(
                            title: Text('Add New Word Category'),
                            content: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.87,
                              child: Form(
                                key: _formKey2,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    DropdownSearch<String>(
                                      validator: (value) {
                                        if (value == 'Choose Word Category') {
                                          return 'Please choose one word category';
                                        }
                                        return null;
                                      },
                                      popupProps: PopupProps.dialog(
                                        showSelectedItems: true,
                                        itemBuilder: _style1,
                                        dialogProps: DialogProps(
                                          contentTextStyle: TextStyle(
                                              fontFamily: 'MeQuran2',
                                              fontSize: 24),
                                        ),
                                        showSearchBox: true,
                                        textStyle: TextStyle(
                                            fontFamily: 'MeQuran2',
                                            fontSize: 24),
                                      ),
                                      dropdownBuilder: _style,
                                      dropdownDecoratorProps:
                                          const DropDownDecoratorProps(
                                        dropdownSearchDecoration:
                                            InputDecoration(
                                          labelText: "Select Word Category",
                                        ),
                                      ),
                                      items: list,
                                      onChanged: (String? value) {
                                        aya.wordDetail.forEach((element) async {
                                          if (element.name == value) {
                                            setState(() {
                                              _inputEngCat3 = value;
                                              _catID3 = element.categoryId;
                                              _inputWordType3 = element.type;
                                              _inputChildType3 =
                                                  element.childType;
                                            });
                                          }
                                        });
                                      },
                                      selectedItem: 'Choose Word Category',
                                    ),
                                    TextFormField(
                                      initialValue: _inputEngCat3,
                                      decoration: InputDecoration(
                                          label: Text(
                                              'New English Category Name')),
                                      onChanged: (value) {
                                        setState(() {
                                          _inputEngCat3 = value;
                                        });
                                      },
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter some text';
                                        }
                                        return null;
                                      },
                                    ),
                                    TextFormField(
                                      initialValue: _inputEngCat3,
                                      decoration: InputDecoration(
                                          label:
                                              Text('New Arab Category Name')),
                                      onChanged: (value) {
                                        setState(() {
                                          _inputArabCat3 = value;
                                        });
                                      },
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter some text';
                                        }
                                        return null;
                                      },
                                    ),
                                    TextFormField(
                                      initialValue: _inputEngCat3,
                                      decoration: InputDecoration(
                                          label:
                                              Text('New Malay Category Name')),
                                      onChanged: (value) {
                                        setState(() {
                                          _inputMalayCat3 = value;
                                        });
                                      },
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter some text';
                                        }
                                        return null;
                                      },
                                    ),
                                    DropdownSearch<String>(
                                        validator: (value) {
                                          if (value == 'Choose child type') {
                                            return 'Please choose one child type';
                                          }
                                          return null;
                                        },
                                        popupProps: PopupProps.dialog(
                                          showSelectedItems: true,
                                          itemBuilder: _style1,
                                          dialogProps: DialogProps(
                                            contentTextStyle: TextStyle(
                                                fontFamily: 'MeQuran2',
                                                fontSize: 24),
                                          ),
                                          showSearchBox: true,
                                          textStyle: TextStyle(
                                              fontFamily: 'MeQuran2',
                                              fontSize: 24),
                                        ),
                                        dropdownBuilder: _style,
                                        dropdownDecoratorProps:
                                            const DropDownDecoratorProps(
                                          dropdownSearchDecoration:
                                              InputDecoration(
                                            labelText: "Child Type",
                                          ),
                                        ),
                                        items: childType,
                                        onChanged: (String? value) {
                                          setState(() {
                                            _inputChildType3 = value;
                                          });
                                        },
                                        selectedItem: _inputChildType3 ??
                                            'Choose child type'),
                                    DropdownSearch<String>(
                                        validator: (value) {
                                          if (value == 'Choose word type') {
                                            return 'Please choose one word type';
                                          }
                                          return null;
                                        },
                                        popupProps: PopupProps.dialog(
                                          showSelectedItems: true,
                                          itemBuilder: _style1,
                                          dialogProps: DialogProps(
                                            contentTextStyle: TextStyle(
                                                fontFamily: 'MeQuran2',
                                                fontSize: 24),
                                          ),
                                          showSearchBox: true,
                                          textStyle: TextStyle(
                                              fontFamily: 'MeQuran2',
                                              fontSize: 24),
                                        ),
                                        dropdownBuilder: _style,
                                        dropdownDecoratorProps:
                                            const DropDownDecoratorProps(
                                          dropdownSearchDecoration:
                                              InputDecoration(
                                            labelText: "Word Type",
                                          ),
                                        ),
                                        items: wordType,
                                        onChanged: (String? value) {
                                          setState(() {
                                            _inputWordType3 = value;
                                          });
                                        },
                                        selectedItem: _inputWordType3 ??
                                            'Choose word type'),
                                    ElevatedButton(
                                        onPressed: () async {
                                          // Validate returns true if the form is valid, or false otherwise.
                                          if (_formKey2.currentState!
                                              .validate()) {
                                            await Provider.of<AyaProvider>(
                                                    context,
                                                    listen: false)
                                                .updateCategory(
                                                    _inputEngCat3!,
                                                    _inputArabCat3!,
                                                    _inputMalayCat3!,
                                                    _inputChildType3!,
                                                    _inputWordType3!,
                                                    '$_catID3');
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                  backgroundColor:
                                                      Colors.cyanAccent,
                                                  content:
                                                      Text('Updating Data...')),
                                            );
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                          }
                                        },
                                        child: Text('Save Changes'))
                                  ],
                                ),
                              ),
                            ),
                          );
                        });
                      });
                  _animationController.reverse();
                },
              ),
              // Floating action menu item

              //Floating action menu item
            ],

            // animation controller
            animation: _animation,

            // On pressed change animation state
            onPress: () => _animationController.isCompleted
                ? _animationController.reverse()
                : _animationController.forward(),

            // Floating Action button Icon color
            iconColor: themeProvider.isDarkMode ? Colors.white : Colors.black,

            // Flaoting Action button Icon
            iconData: Icons.add,
            backGroundColor: themeProvider.isDarkMode
                ? Colors.blueGrey
                : Colors.orangeAccent,
          ));
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
                  title: Text(document.name!,
                      style: TextStyle(fontFamily: 'MeQuran2')),
                  subtitle: Text(
                    'ID: ${document.categoryId}, Type: ${document.type}, Child: ${document.childType}',
                  ),
                  trailing: SizedBox(
                    width: 100,
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () async {
                            List<WordDetail> label =
                                await Provider.of<AyaProvider>(
                                        context,
                                        listen: false)
                                    .getList(
                                        document.parent ?? '',
                                        Provider.of<AyaProvider>(context,
                                                listen: false)
                                            .getLangID(context));
                            popUp(document, label);
                          },
                        ),
                        Spacer(),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () async {
                            showModalBottomSheet<void>(
                              context: context,
                              builder: (BuildContext context) {
                                return Container(
                                  height: 100,
                                  color: Colors.amber,
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              primary: Colors.redAccent,
                                              elevation: 2,
                                              minimumSize: const Size(200, 40),
                                              shape:
                                                  const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(8),
                                                ),
                                              ),
                                            ),
                                            child: const Text('Confirm Delete'),
                                            onPressed: () {
                                              print(document.id);
                                              Provider.of<DeleteProvider>(
                                                      context,
                                                      listen: false)
                                                  .deleteRelationship(
                                                      document.id);
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(snackBar);
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                            }),
                                        TextButton(
                                          child: Text(
                                            'Cancel',
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .backgroundColor),
                                          ),
                                          onPressed: () =>
                                              Navigator.pop(context),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  )))
          : list.isNotEmpty
              ? Card(
                  color: Provider.of<ThemeProvider>(context, listen: false)
                          .isDarkMode
                      ? Color(0xff808BA1)
                      : Color(0xffFCD77A),
                  child: ListTile(
                      leading: Icon(Icons.arrow_right),
                      title: Text(document.name!,
                          style: TextStyle(fontFamily: 'MeQuran2')),
                      subtitle: Text(
                          'ID: ${document.categoryId}, Type: ${document.type ?? "None"}, Child: ${document.childType}'),
                      trailing: SizedBox(
                        width: 100,
                        child: Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () async {
                                List<WordDetail> label =
                                    await Provider.of<AyaProvider>(context,
                                            listen: false)
                                        .getList(
                                            document.parent ?? '',
                                            Provider.of<AyaProvider>(context,
                                                    listen: false)
                                                .getLangID(context));
                                popUp(document, label);
                              },
                            ),
                            Spacer(),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () async {
                                showModalBottomSheet<void>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Container(
                                      height: 100,
                                      color: Colors.amber,
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  primary: Colors.redAccent,
                                                  elevation: 2,
                                                  minimumSize:
                                                      const Size(200, 40),
                                                  shape:
                                                      const RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(8),
                                                    ),
                                                  ),
                                                ),
                                                child: const Text(
                                                    'Confirm Delete'),
                                                onPressed: () {
                                                  print(document.id);
                                                  Provider.of<DeleteProvider>(
                                                          context,
                                                          listen: false)
                                                      .deleteRelationship(
                                                          document.id);
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(snackBar);
                                                  Navigator.pop(context);
                                                  Navigator.pop(context);
                                                  Navigator.pop(context);
                                                }),
                                            TextButton(
                                              child: Text(
                                                'Cancel',
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .backgroundColor),
                                              ),
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      )),
                )
              : ListTile(
                  leading: Icon(Icons.remove),
                  title: Text(document.name!,
                      style: TextStyle(fontFamily: 'MeQuran2')),
                  subtitle: Text(
                      'ID: ${document.categoryId}, Type: ${document.type ?? "None"}, Child: ${document.childType}'),
                  trailing: SizedBox(
                    width: 100,
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () async {
                            List<WordDetail> label =
                                await Provider.of<AyaProvider>(
                                        context,
                                        listen: false)
                                    .getList(
                                        document.parent ?? '',
                                        Provider.of<AyaProvider>(context,
                                                listen: false)
                                            .getLangID(context));
                            popUp(document, label);
                          },
                        ),
                        Spacer(),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () async {
                            showModalBottomSheet<void>(
                              context: context,
                              builder: (BuildContext context) {
                                return Container(
                                  height: 100,
                                  color: Colors.amber,
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              primary: Colors.redAccent,
                                              elevation: 2,
                                              minimumSize: const Size(200, 40),
                                              shape:
                                                  const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(8),
                                                ),
                                              ),
                                            ),
                                            child: const Text('Confirm Delete'),
                                            onPressed: () {
                                              print(document.id);
                                              Provider.of<DeleteProvider>(
                                                      context,
                                                      listen: false)
                                                  .deleteRelationship(
                                                      document.id);
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(snackBar);
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                            }),
                                        TextButton(
                                          child: Text(
                                            'Cancel',
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .backgroundColor),
                                          ),
                                          onPressed: () =>
                                              Navigator.pop(context),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
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

  Future<void> addData({
    required String parent,
    required String wordType,
    required String engName,
    required String? malayName,
    required String? arabName,
    required String childType,
    required String? categoryId,
    required bool newRel,
  }) async {
    var id = await Provider.of<AyaProvider>(context, listen: false)
        .getLastRelationshipId();
    var catID;
    setState(() {
      catID = categoryId;
    });
    if (newRel) {
      await Provider.of<AyaProvider>(context, listen: false).addNewRelationship(
        relationshipID: int.parse(id),
        wordID: widget.wordId,
        categoryID: int.parse(catID),
      );
    }
    print('data added');
  }
}
