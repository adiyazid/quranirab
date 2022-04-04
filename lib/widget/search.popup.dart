import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quranirab/theme/theme_provider.dart';

import '../views/surah.screen.dart';

class SearchPopup extends StatefulWidget {
  const SearchPopup({Key? key}) : super(key: key);

  @override
  State<SearchPopup> createState() => _SearchPopupState();
}

class _SearchPopupState extends State<SearchPopup>
    with TickerProviderStateMixin {
  final padding = const EdgeInsets.symmetric(horizontal: 10);

  int no = 0;

  var visible = true;

  TextEditingController myController = TextEditingController();
  List pop = [
    {
      'start_line': 'الملك',
      "tname": "Al-Mulk",
      "end_page": "564",
      "ename": "The Sovereignty",
      "updated_at": "2014-11-17 19:59:20.76326",
      'revelation_order': "77",
      "id": "67",
      "created_at": "2014-03-28 06:24:58.222375",
      "start_page": "562",
      "total_rukus": "2",
      "total_ayas": "30",
      "revelation_type": "Meccan"
    },
    {
      "ename": "The Cave",
      "revelation_order": "69",
      "start_page": "293",
      "revelation_type": "Meccan",
      "id": "18",
      "tname": "Al-Kahf",
      "total_rukus": "12",
      "updated_at": "2014-11-17 19:59:20.55515",
      "end_page": "304",
      "created_at": "2014-03-28 06:24:57.976623",
      "start_line": " الكهف",
      "total_ayas": "110"
    },
    {
      "start_page": "440",
      "updated_at": "2014-11-17 19:59:20.627192",
      "revelation_order": "41",
      "ename": "Yaseen",
      "start_line": " يس",
      "end_page": "445",
      "id": "36",
      "revelation_type": "Meccan",
      "total_ayas": "83",
      "tname": "Yaseen",
      "total_rukus": "5",
      "created_at": "2014-03-28 06:24:58.044456"
    }
  ];
  List all = [];
  List _list = [];
  late AsyncMemoizer _memoizer;

  final CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('suras');

  @override
  void initState() {
    _memoizer = AsyncMemoizer();
    init();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return CustomPopupMenu(
      child: const Icon(Icons.search),
      pressType: PressType.singleClick,
      showArrow: false,
      horizontalMargin: 10,
      menuBuilder: () {
        return StatefulBuilder(builder: (context, setState) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Container(
              decoration: BoxDecoration(
                  color: themeProvider.isDarkMode
                      ? const Color(0xFF67748E)
                      : const Color(0xFFFFC692),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(12.0),
                  ),
                  border: Border.all(
                    color: Theme.of(context).dividerColor,
                    width: 1,
                  )),
              child: SizedBox(
                height: 320,
                width: 500,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24.0, vertical: 8),
                      child: TextField(
                        cursorColor: themeProvider.isDarkMode
                            ? Colors.white
                            : Colors.black,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          suffixIcon: IconButton(
                            icon: Icon(
                              Icons.clear,
                              color: themeProvider.isDarkMode
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            onPressed: () {
                              myController.clear();

                              setState(() {
                                visible = true;
                                _list = all;
                              });
                            },
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: themeProvider.isDarkMode
                                ? Colors.white
                                : Colors.black,
                          ),
                          hintText: 'Search',
                        ),
                        controller: myController,
                        onChanged: _search,
                      ),
                    ),
                    Flexible(
                        flex: 1,
                        child: Visibility(
                          visible: visible,
                          child: Text('Popular Searches'),
                        )),
                    Expanded(
                      flex: 4,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24.0, vertical: 8),
                        child: ListView.builder(
                          itemCount: visible ? pop.length : _list.length,
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                              onTap: () async {
                                var a = await getTotalPage(_list[index]["id"]);
                                var b = await getTotalPage(pop[index]["id"]);
                                visible
                                    ? Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => SurahScreen(
                                                  b,
                                                  pop[index]["id"],
                                                  pop[index]["tname"],
                                                  pop[index]["ename"],
                                                )))
                                    : Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => SurahScreen(
                                                  a,
                                                  _list[index]["id"],
                                                  _list[index]["tname"],
                                                  _list[index]["ename"],
                                                )));
                              },
                              child: ListTile(
                                title: Text(visible
                                    ? pop[index]['tname']
                                    : _list[index]['tname']),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
      },
    );
  }

  Future<void> _search(String query) async {
    if (query != '') {
      final suggestions = _list.where((book) {
        final bookTitle = book['tname'].toLowerCase();

        final input = query.toLowerCase();
        return bookTitle.contains(input);
      }).toList();
      setState(() {
        visible = false;
        if (suggestions.isNotEmpty) {
          _list = suggestions;
        }
      });
    } else {
      setState(() {
        _list = all;
      });
      visible = false;
    }
  }

  Future<void> init() => _memoizer.runOnce(() async {
        // Get docs from collection reference
        QuerySnapshot querySnapshot =
            await _collectionRef.orderBy('created_at').get();

        // Get data from docs and convert map to List
        final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
        setState(() {
          _list = allData;
          all = allData;
        });
      });

  Future<List> getTotalPage(String id) async {
    List _total = [];
    final CollectionReference _collectionSura =
        FirebaseFirestore.instance.collection('sura_relationships');
    QuerySnapshot querySnapshot = await _collectionSura
        .where('sura_id', isEqualTo: id)
        .orderBy('created_at')
        .get();
    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    setState(() {
      _total = allData;
    });
    var data = _total.map((e) => e["medina_mushaf_page_id"]).toList();
    return data;
  }
}

Widget buildMenuItem({
  required String text,
  required IconData icon,
}) {
  const color = Colors.black;

  return ListTile(
    leading: Icon(icon, color: color),
    title: Text(text, style: const TextStyle(color: color)),
    onTap: () {},
  );
}

void SelectedItem(BuildContext context, int index) {
  Navigator.of(context).pop();
}

class CurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    int curveHeight = 40;
    Offset controlPoint = Offset(size.width / 2, size.height + curveHeight);
    Offset endPoint = Offset(size.width, size.height - curveHeight);

    Path path = Path()
      ..lineTo(0, size.height - curveHeight)
      ..quadraticBezierTo(
          controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy)
      ..lineTo(size.width, 0)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
