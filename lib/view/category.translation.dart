import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:multiquranirab/providers/db.list.providers.dart';
import 'package:provider/provider.dart';

import '../Routes/route.dart';
import '../theme/theme_provider.dart';

class GetWordTranslation extends StatefulWidget {
  final String documentId;

  const GetWordTranslation(this.documentId, {Key? key}) : super(key: key);

  @override
  State<GetWordTranslation> createState() => _GetWordTranslationState();
}

class _GetWordTranslationState extends State<GetWordTranslation> {
  List _list = [];
  late String _language;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final _name = TextEditingController();

  List cols = [
    {"title": 'Id', 'widthFactor': 0.1, 'key': 'id'},
    {"title": 'Language Name', 'widthFactor': 0.2, 'key': 'name'},
  ];
  List rows = [
    {
      "id": '1',
      "name": 'Arabic',
    },
    {
      "id": '2',
      "name": 'English',
    },
    {
      "id": '3',
      "name": 'Malay',
    },
    {
      "id": '4',
      "name": 'Chinese',
    },
    {
      "id": '5',
      "name": 'French',
    },
    {
      "id": '6',
      "name": 'Spanish',
    },
    {
      "id": '7',
      "name": 'Benggali',
    },
  ];

  @override
  initState() {
    getTranslationCategory();
    super.initState();
    _language = '';
  }

  _saveForm() async {
    if (formKey.currentState!.validate()) {
      var duplicate =
          _list.any((element) => element['language_id'] == _language);
      if (duplicate) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('This language already in database')));
      } else if (_language == '') {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Select Language')));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Adding data...')));
        await addLanguage(_name.text, _language).then((value) {
          Navigator.pop(context);
          Navigator.pushReplacementNamed(context, RoutesName.homePage);
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please insert all field')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Word category id ${widget.documentId}'),
      ),
      body: _list.isEmpty
          ? Center(
              child: LoadingAnimationWidget.fourRotatingDots(
                size: 200,
                color: theme.isDarkMode ? Colors.blueGrey : Colors.orangeAccent,
              ),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Flexible(
                    child: Table(
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                      defaultColumnWidth: const FixedColumnWidth(120.0),
                      border: TableBorder.all(
                          color: Colors.black,
                          style: BorderStyle.solid,
                          width: 2),
                      children: [
                        TableRow(children: [
                          Column(children: const [
                            Text('Id', style: TextStyle(fontSize: 18))
                          ]),
                          Column(children: const [
                            Text('Language Name',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 18))
                          ]),
                        ]),
                        TableRow(children: [
                          Column(children: const [Text('1')]),
                          Column(children: const [Text('Arabic')]),
                        ]),
                        TableRow(children: [
                          Column(children: const [Text('2')]),
                          Column(children: const [Text('English')]),
                        ]),
                        TableRow(children: [
                          Column(children: const [Text('3')]),
                          Column(children: const [Text('Malay')]),
                        ]),
                        TableRow(children: [
                          Column(children: const [Text('4')]),
                          Column(children: const [Text('Chinese')]),
                        ]),
                        TableRow(children: [
                          Column(children: const [Text('5')]),
                          Column(children: const [Text('French')]),
                        ]),
                        TableRow(children: [
                          Column(children: const [Text('6')]),
                          Column(children: const [Text('Spanish')]),
                        ]),
                        TableRow(children: [
                          Column(children: const [Text('7')]),
                          Column(children: const [Text('Bengali')]),
                        ]),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 400,
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: ListView.builder(
                      itemCount: _list.length,
                      itemBuilder: (BuildContext context, int index) {
                        _list.sort((a, b) =>
                            a['language_id'].compareTo(b['language_id']));
                        return Card(
                          child: ListTile(
                            title: Text(
                              _list[index]['name'],
                              style: const TextStyle(fontFamily: 'MeQuran2'),
                            ),
                            subtitle: Text(_list[index]['language_id']),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            await showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return Form(
                  key: formKey,
                  child: AlertDialog(
                    title: DropDownTextField(
                      clearOption: false,
                      listSpace: 20,
                      listPadding: ListPadding(top: 20),
                      enableSearch: false,
                      validator: (value) {
                        if (value == null) {
                          return "Required field";
                        } else {
                          return null;
                        }
                      },
                      dropDownList: const [
                        DropDownValueModel(name: 'Chinese', value: "4"),
                        DropDownValueModel(name: 'French', value: "5"),
                        DropDownValueModel(name: 'Spanish', value: "6"),
                        DropDownValueModel(name: 'Benggali', value: "7"),
                      ],
                      listTextStyle: const TextStyle(color: Colors.red),
                      dropDownItemCount: 4,
                      onChanged: (val) {
                        setState(() {});
                        _language = val.value;
                      },
                    ),
                    content: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please insert name';
                        } else {
                          return null;
                        }
                      },
                      controller: _name,
                      decoration:
                          const InputDecoration(hintText: 'Insert text'),
                    ),
                    actions: [
                      IconButton(
                          onPressed: () {
                            setState(() {});
                            _name.clear();
                            _language = '';
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.close)),
                      IconButton(
                          onPressed: _saveForm, icon: const Icon(Icons.check))
                    ],
                  ),
                );
              },
            );
          },
          icon: const Icon(Icons.add),
          label: const Text('Add new translation')),
    );
  }

  Future<void> getTranslationCategory() async {
    await FirebaseFirestore.instance
        .collection('category_translations')
        .where('word_category_id', isEqualTo: widget.documentId)
        .get()
        .then((value) => setState(() {
              _list = value.docs;
            }));
  }

  Future<void> addLanguage(String text, String language) async {
    int? id;

    await FirebaseFirestore.instance
        .collection('category_translations')
        .orderBy('created_at', descending: true)
        .limit(1)
        .get()
        .then((QuerySnapshot snapshot) {
      for (var item in snapshot.docs) {
        setState(() {});
        id = int.parse(item['id']) + 1;
        Provider.of<DbListProvider>(context, listen: false)
            .add(widget.documentId, text, language, '$id');
      }
    });
    await FirebaseFirestore.instance
        .collection('category_translations')
        .doc('$id')
        .set({
      "created_at": DateTime.now().toString(),
      "id": "$id",
      "language_id": language,
      "name": text,
      "updated_at": DateTime.now().toString(),
      "word_category_id": widget.documentId
    });
  }
}
