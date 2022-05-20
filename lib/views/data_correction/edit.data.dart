import 'package:dropdown_search/dropdown_search.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';
import 'package:group_radio_button/group_radio_button.dart';
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

class _EditDataState extends State<EditData>
    with SingleTickerProviderStateMixin {
  var i = 0;
  late Animation<double> _animation;
  late AnimationController _animationController;

  final _option = ['Add New', 'Use existing category'];

  String _inputType = 'Add New';

  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  String? _inputParent;
  String? _inputParent2;
  String? _inputCat;
  String? _inputCat2;
  String? _inputChildType;
  String? _inputChildType2;
  String? _inputWordType;
  String? _inputWordType2;
  List<String> childType = ['unique', 'all', 'multiple', 'none'];

  List<String> wordType = ['none', 'label', 'main', 'main-label'];

  int? _catID;
  int? _catID2;

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
              return Text('Word detail for word ID ${aya.wordID}');
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
                              height: MediaQuery.of(context).size.height * 0.7,
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
                                      dropdownSearchBaseStyle:
                                          TextStyle(fontFamily: 'MeQuran2'),
                                      showSearchBox: true,
                                      mode: Mode.DIALOG,
                                      showSelectedItems: true,
                                      dropdownBuilder: _style,
                                      popupItemBuilder: _style1,
                                      items: list,
                                      dropdownSearchDecoration: InputDecoration(
                                        labelText: "Parent Ancestry",
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
                                                  .getList(_inputParent ?? '');
                                          label.forEach((element) {
                                            if (_inputParent ==
                                                element.parent) {
                                              if (newList
                                                      .contains(element.name) ==
                                                  false) {
                                                newList.add(element.name!);
                                              }
                                            }
                                          });
                                        });
                                      },
                                      selectedItem: 'Choose parent',
                                    ),
                                    RadioGroup<String>.builder(
                                      groupValue: newList.isEmpty
                                          ? "Add New"
                                          : _inputType,
                                      onChanged: (value) => setState(() {
                                        _inputType = value!;
                                      }),
                                      items: _option,
                                      itemBuilder: (item) => RadioButtonBuilder(
                                        item,
                                      ),
                                    ),
                                    if (_inputType == 'Add New' ||
                                        newList.isEmpty)
                                      TextFormField(
                                        decoration: InputDecoration(
                                            label: Text('New Category Name')),
                                        onChanged: (value) {
                                          setState(() {
                                            _inputCat = value;
                                            _catID = null;
                                          });
                                        },
                                        validator: (value) {
                                          if (_inputType == 'Add New' &&
                                                  value == null ||
                                              value!.isEmpty &&
                                                  _inputType == 'Add New') {
                                            return 'Please enter some text';
                                          }
                                          return null;
                                        },
                                      ),
                                    if (_inputType != 'Add New' &&
                                        newList.isNotEmpty)
                                      DropdownSearch<String>(
                                          validator: (value) {
                                            if (value ==
                                                'Choose child category') {
                                              return 'Please choose one child category';
                                            }
                                            return null;
                                          },
                                          dropdownSearchBaseStyle:
                                              TextStyle(fontFamily: 'MeQuran2'),
                                          showSearchBox: true,
                                          mode: Mode.DIALOG,
                                          showSelectedItems: true,
                                          dropdownBuilder: _style,
                                          popupItemBuilder: _style1,
                                          items: newList,
                                          dropdownSearchDecoration:
                                              InputDecoration(
                                            labelText: "Child Category",
                                          ),
                                          onChanged: (String? value) async {
                                            setState(() {
                                              _inputCat = value;
                                            });
                                            label.forEach((element) {
                                              if (element.name == value) {
                                                _catID = element.categoryId;
                                              }
                                            });
                                          },
                                          selectedItem:
                                              'Choose child category'),
                                    DropdownSearch<String>(
                                        validator: (value) {
                                          if (value == 'Choose child type') {
                                            return 'Please choose one child type';
                                          }
                                          return null;
                                        },
                                        dropdownSearchBaseStyle:
                                            TextStyle(fontFamily: 'MeQuran2'),
                                        showSearchBox: true,
                                        mode: Mode.DIALOG,
                                        showSelectedItems: true,
                                        dropdownBuilder: _style,
                                        popupItemBuilder: _style1,
                                        items: childType,
                                        dropdownSearchDecoration:
                                            InputDecoration(
                                          labelText: "Child Type",
                                        ),
                                        onChanged: (String? value) {
                                          setState(() {
                                            _inputChildType = value;
                                          });
                                        },
                                        selectedItem: 'Choose child type'),
                                    DropdownSearch<String>(
                                        validator: (value) {
                                          if (value == 'Choose word type') {
                                            return 'Please choose one word type';
                                          }
                                          return null;
                                        },
                                        dropdownSearchBaseStyle:
                                            TextStyle(fontFamily: 'MeQuran2'),
                                        showSearchBox: true,
                                        mode: Mode.DIALOG,
                                        showSelectedItems: true,
                                        dropdownBuilder: _style,
                                        popupItemBuilder: _style1,
                                        items: wordType,
                                        dropdownSearchDecoration:
                                            InputDecoration(
                                          labelText: "Word Type",
                                        ),
                                        onChanged: (String? value) {
                                          setState(() {
                                            _inputWordType = value;
                                          });
                                        },
                                        selectedItem: 'Choose word type'),
                                    Text(
                                        "Parent Ancestry ${_inputParent ?? "No data"}"),
                                    Text(
                                        "Category Name ${_inputCat ?? "No data"}"),
                                    Text("Category ID ${_catID ?? "No data"}"),
                                    Text(
                                        "Child Type ${_inputChildType ?? "No data"}"),
                                    Text(
                                        "Word Type ${_inputWordType ?? "No data"}"),
                                    ElevatedButton(
                                        onPressed: () async {
                                          // Validate returns true if the form is valid, or false otherwise.
                                          if (_formKey.currentState!
                                              .validate()) {
                                            await addData(
                                                categoryId: "$_catID",
                                                parent: _inputParent!,
                                                wordType: _inputWordType!,
                                                name: _inputCat!,
                                                childType: _inputChildType!,
                                                newCat: _inputType == 'Add New'
                                                    ? true
                                                    : false,
                                                newRel: true);
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
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
              Bubble(
                title: "Add Word Category",
                iconColor: Colors.white,
                bubbleColor: themeProvider.isDarkMode
                    ? Colors.blueGrey
                    : Colors.orangeAccent,
                icon: Icons.category,
                titleStyle: TextStyle(fontSize: 16, color: Colors.white),
                onPress: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return StatefulBuilder(builder: (context, setState) {
                          return AlertDialog(
                            title: Text('Add New Word Category'),
                            content: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.7,
                              child: Form(
                                key: _formKey2,
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
                                      dropdownSearchBaseStyle:
                                          TextStyle(fontFamily: 'MeQuran2'),
                                      showSearchBox: true,
                                      mode: Mode.DIALOG,
                                      showSelectedItems: true,
                                      dropdownBuilder: _style,
                                      popupItemBuilder: _style1,
                                      items: list,
                                      dropdownSearchDecoration: InputDecoration(
                                        labelText: "Parent Ancestry",
                                      ),
                                      onChanged: (String? value) {
                                        aya.wordDetail.forEach((element) async {
                                          if (element.name == value) {
                                            setState(() {
                                              _inputParent2 =
                                                  "${element.parent}/${element.categoryId}";
                                            });
                                          }
                                          newList.clear();

                                          label =
                                              await Provider.of<AyaProvider>(
                                                      context,
                                                      listen: false)
                                                  .getList(_inputParent ?? '');
                                          label.forEach((element) {
                                            if (_inputParent2 ==
                                                element.parent) {
                                              if (newList
                                                      .contains(element.name) ==
                                                  false) {
                                                newList.add(element.name!);
                                              }
                                            }
                                          });
                                        });
                                      },
                                      selectedItem: 'Choose parent',
                                    ),
                                    TextFormField(
                                      decoration: InputDecoration(
                                          label: Text('New Category Name')),
                                      onChanged: (value) {
                                        setState(() {
                                          _inputCat2 = value;
                                          _catID2 = null;
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
                                        dropdownSearchBaseStyle:
                                            TextStyle(fontFamily: 'MeQuran2'),
                                        showSearchBox: true,
                                        mode: Mode.DIALOG,
                                        showSelectedItems: true,
                                        dropdownBuilder: _style,
                                        popupItemBuilder: _style1,
                                        items: childType,
                                        dropdownSearchDecoration:
                                            InputDecoration(
                                          labelText: "Child Type",
                                        ),
                                        onChanged: (String? value) {
                                          setState(() {
                                            _inputChildType2 = value;
                                          });
                                        },
                                        selectedItem: 'Choose child type'),
                                    DropdownSearch<String>(
                                        validator: (value) {
                                          if (value == 'Choose word type') {
                                            return 'Please choose one word type';
                                          }
                                          return null;
                                        },
                                        dropdownSearchBaseStyle:
                                            TextStyle(fontFamily: 'MeQuran2'),
                                        showSearchBox: true,
                                        mode: Mode.DIALOG,
                                        showSelectedItems: true,
                                        dropdownBuilder: _style,
                                        popupItemBuilder: _style1,
                                        items: wordType,
                                        dropdownSearchDecoration:
                                            InputDecoration(
                                          labelText: "Word Type",
                                        ),
                                        onChanged: (String? value) {
                                          setState(() {
                                            _inputWordType2 = value;
                                          });
                                        },
                                        selectedItem: 'Choose word type'),
                                    Text(
                                        "Parent Ancestry ${_inputParent2 ?? "No data"}"),
                                    Text(
                                        "Category Name ${_inputCat2 ?? "No data"}"),
                                    Text("Category ID ${_catID2 ?? "No data"}"),
                                    Text(
                                        "Child Type ${_inputChildType2 ?? "No data"}"),
                                    Text(
                                        "Word Type ${_inputWordType2 ?? "No data"}"),
                                    ElevatedButton(
                                        onPressed: () async {
                                          // Validate returns true if the form is valid, or false otherwise.
                                          if (_formKey2.currentState!
                                              .validate()) {
                                            await addData(
                                                categoryId: "$_catID2",
                                                parent: _inputParent2!,
                                                wordType: _inputWordType2!,
                                                name: _inputCat2!,
                                                childType: _inputChildType2!,
                                                newCat: true,
                                                newRel: false);
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
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
                onPress: () {showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return StatefulBuilder(builder: (context, setState) {
                        return AlertDialog(
                          title: Text('Add New Word Category'),
                          content: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.7,
                            child: Form(
                              key: _formKey2,
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
                                    dropdownSearchBaseStyle:
                                    TextStyle(fontFamily: 'MeQuran2'),
                                    showSearchBox: true,
                                    mode: Mode.DIALOG,
                                    showSelectedItems: true,
                                    dropdownBuilder: _style,
                                    popupItemBuilder: _style1,
                                    items: list,
                                    dropdownSearchDecoration: InputDecoration(
                                      labelText: "Parent Ancestry",
                                    ),
                                    onChanged: (String? value) {
                                      aya.wordDetail.forEach((element) async {
                                        if (element.name == value) {
                                          setState(() {
                                            _inputParent2 =
                                            "${element.parent}/${element.categoryId}";
                                          });
                                        }
                                        newList.clear();

                                        label =
                                        await Provider.of<AyaProvider>(
                                            context,
                                            listen: false)
                                            .getList(_inputParent ?? '');
                                        label.forEach((element) {
                                          if (_inputParent2 ==
                                              element.parent) {
                                            if (newList
                                                .contains(element.name) ==
                                                false) {
                                              newList.add(element.name!);
                                            }
                                          }
                                        });
                                      });
                                    },
                                    selectedItem: 'Choose parent',
                                  ),
                                  TextFormField(
                                    decoration: InputDecoration(
                                        label: Text('New Category Name')),
                                    onChanged: (value) {
                                      setState(() {
                                        _inputCat2 = value;
                                        _catID2 = null;
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
                                      dropdownSearchBaseStyle:
                                      TextStyle(fontFamily: 'MeQuran2'),
                                      showSearchBox: true,
                                      mode: Mode.DIALOG,
                                      showSelectedItems: true,
                                      dropdownBuilder: _style,
                                      popupItemBuilder: _style1,
                                      items: childType,
                                      dropdownSearchDecoration:
                                      InputDecoration(
                                        labelText: "Child Type",
                                      ),
                                      onChanged: (String? value) {
                                        setState(() {
                                          _inputChildType2 = value;
                                        });
                                      },
                                      selectedItem: 'Choose child type'),
                                  DropdownSearch<String>(
                                      validator: (value) {
                                        if (value == 'Choose word type') {
                                          return 'Please choose one word type';
                                        }
                                        return null;
                                      },
                                      dropdownSearchBaseStyle:
                                      TextStyle(fontFamily: 'MeQuran2'),
                                      showSearchBox: true,
                                      mode: Mode.DIALOG,
                                      showSelectedItems: true,
                                      dropdownBuilder: _style,
                                      popupItemBuilder: _style1,
                                      items: wordType,
                                      dropdownSearchDecoration:
                                      InputDecoration(
                                        labelText: "Word Type",
                                      ),
                                      onChanged: (String? value) {
                                        setState(() {
                                          _inputWordType2 = value;
                                        });
                                      },
                                      selectedItem: 'Choose word type'),
                                  Text(
                                      "Parent Ancestry ${_inputParent2 ?? "No data"}"),
                                  Text(
                                      "Category Name ${_inputCat2 ?? "No data"}"),
                                  Text("Category ID ${_catID2 ?? "No data"}"),
                                  Text(
                                      "Child Type ${_inputChildType2 ?? "No data"}"),
                                  Text(
                                      "Word Type ${_inputWordType2 ?? "No data"}"),
                                  ElevatedButton(
                                      onPressed: () async {
                                        // Validate returns true if the form is valid, or false otherwise.
                                        if (_formKey2.currentState!
                                            .validate()) {
                                          await addData(
                                              categoryId: "$_catID2",
                                              parent: _inputParent2!,
                                              wordType: _inputWordType2!,
                                              name: _inputCat2!,
                                              childType: _inputChildType2!,
                                              newCat: true,
                                              newRel: false);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
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
                  subtitle: Text(
                      'ID: ${document.categoryId}, Type: ${document.type}, Child: ${document.childType}'),
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
                      subtitle: Text(
                          'ID: ${document.categoryId}, Type: ${document.type ?? "None"}, Child: ${document.childType}'),
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
                  subtitle: Text(
                      'ID: ${document.categoryId}, Type: ${document.type ?? "None"}, Child: ${document.childType}'),
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
    required String name,
    required String childType,
    String? categoryId,
    required bool newCat,
    required bool newRel,
  }) async {
    var id = await Provider.of<AyaProvider>(context, listen: false)
        .getLastRelationshipId();
    var catID;
    if (newCat) {
      setState(() {});
      catID = await Provider.of<AyaProvider>(context, listen: false)
          .getLastCategoryId();
      await Provider.of<AyaProvider>(context, listen: false).addNewCategory(
          categoryID: int.parse(catID),
          parent: parent,
          name: name,
          childType: childType,
          wordType: wordType);
    } else {
      setState(() {
        catID = categoryId;
      });
    }
    if (newRel) {
      await Provider.of<AyaProvider>(context, listen: false).addNewRelationship(
          relationshipID: int.parse(id),
          wordID: widget.wordId,
          categoryID: int.parse(catID));
    }
    print('data added');
  }
}
