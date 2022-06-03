import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quranirab/models/category.dart';
import 'package:quranirab/theme/theme_provider.dart';
import 'package:quranirab/widget/menu.dart';
import '../widget/appbar.widget.dart';

class LeaderBoardTable extends StatefulWidget {
  const LeaderBoardTable({Key? key}) : super(key: key);

  @override
  _LeaderBoardTableState createState() => _LeaderBoardTableState();
}

class _LeaderBoardTableState extends State<LeaderBoardTable> {
  @override
  void initState() {
    super.initState();
    init();
  }

  var dataTable = [];
  var oldDataTable = [];
  bool _sortAscending = false;

  _onSortId(int index, bool ascending) {
    setState(() {
      _sortAscending = ascending;
      for (var element in dataTable) {
        if (kDebugMode) {
          print(element['scores']);
        }
      }
      oldDataTable.sort((a, b) => ascending
          ? a['scores'].compareTo(b['scores'])
          : b['scores'].compareTo(a['scores']));
      dataTable.sort((a, b) => ascending
          ? a['scores'].compareTo(b['scores'])
          : b['scores'].compareTo(a['scores']));
    });
  }

  final leaderBoardRef = FirebaseFirestore.instance
      .collection('leaderboards')
      .doc(catData.category)
      .collection('scores');
  final oldLeaderBoardRef = FirebaseFirestore.instance
      .collection('leaderboards')
      .doc(catData.category)
      .collection('oldScores');

  Future<void> init() async {
    await leaderBoardRef
        .orderBy('scores', descending: true)
        .limit(10)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        var now = DateTime.now();
        var time = DateTime.parse(doc['last-updated'].toDate().toString());
        setState(() {
          var diff = now.difference(time).inDays;
          if (diff < 30 && doc['scores'] != 0) {
            dataTable.add(doc);
          }
        });
      }
    });

    List leaderboards = await oldLeaderBoardRef
        .orderBy('scores', descending: true)
        .limit(10)
        .get()
        .then((snapshot) => snapshot.docs);
    setState(() {
      oldDataTable = leaderboards;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    // Figma Flutter Generator Desktop2Widget - FRAME
    return Scaffold(
      drawer: const Menu(),
      body: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                        width: 2.0,
                        color: themeProvider.isDarkMode
                            ? Colors.white
                            : const Color(0xffE86F00)),
                  ),
                ),
                height: 57,
                child: CustomScrollView(
                  slivers: [Appbar()],
                ),
              ),
              Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height - 57,
                  decoration: BoxDecoration(
                    color: themeProvider.isDarkMode
                        ? const Color(0xff808BA1)
                        : const Color.fromRGBO(255, 237, 173, 1),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(40.0),
                            child: Text(
                              'Leaderboards',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: themeProvider.isDarkMode
                                      ? Colors.white
                                      : const Color.fromRGBO(0, 0, 0, 1),
                                  fontFamily: 'Source Serif Pro',
                                  fontSize:
                                      MediaQuery.of(context).size.width > 600
                                          ? 64
                                          : 40,
                                  letterSpacing:
                                      0 /*percentages not used in flutter. defaulting to zero*/,
                                  fontWeight: FontWeight.normal,
                                  height: 1),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width > 600
                                  ? MediaQuery.of(context).size.width * 0.35
                                  : 400,
                              child: TabBar(
                                  unselectedLabelColor: themeProvider.isDarkMode
                                      ? const Color(0xffD2D6DA)
                                      : const Color(0xffFFFAD0),
                                  indicator: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      // Creates border
                                      color: themeProvider.isDarkMode
                                          ? const Color(0xffBABABA)
                                          : const Color(0xffFFFAD0)),
                                  tabs: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'All time',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: themeProvider.isDarkMode
                                                ? Colors.white
                                                : const Color.fromRGBO(
                                                    0, 0, 0, 1),
                                            fontFamily: 'Source Serif Pro',
                                            fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width >
                                                    600
                                                ? 36
                                                : 24,
                                            letterSpacing:
                                                0 /*percentages not used in flutter. defaulting to zero*/,
                                            fontWeight: FontWeight.normal,
                                            height: 1),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'Last 30 days',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: themeProvider.isDarkMode
                                                ? Colors.white
                                                : const Color.fromRGBO(
                                                    0, 0, 0, 1),
                                            fontFamily: 'Source Serif Pro',
                                            fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width >
                                                    600
                                                ? 36
                                                : 24,
                                            letterSpacing:
                                                0 /*percentages not used in flutter. defaulting to zero*/,
                                            fontWeight: FontWeight.normal,
                                            height: 1),
                                      ),
                                    ),
                                  ]),
                            ),
                          ),
                          const Divider(
                              color: Color.fromRGBO(0, 0, 0, 1), thickness: 1),
                          Center(
                              child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.9,
                            height: MediaQuery.of(context).size.height * 0.82,
                            child: TabBarView(children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                    decoration: BoxDecoration(
                                        color: themeProvider.isDarkMode
                                            ? const Color(0xffD2D6DA)
                                            : const Color(0xffFFFAD0),
                                        shape: BoxShape.rectangle),
                                    child: Theme(
                                      data: Theme.of(context).copyWith(
                                          dividerColor:
                                              const Color(0xffBABABA)),
                                      child: oldDataTable.isEmpty
                                          ? Center(
                                              child: Text(
                                              'No data',
                                              style: TextStyle(fontSize: 40),
                                            ))
                                          : DataTable(
                                              sortColumnIndex: 3,
                                              sortAscending: _sortAscending,
                                              headingRowHeight: 80,
                                              dataRowHeight: 80,
                                              headingTextStyle: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold),
                                              dataTextStyle: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 24),
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius
                                                      .circular(20)),
                                              headingRowColor:
                                                  MaterialStateProperty.all(
                                                      themeProvider.isDarkMode
                                                          ? const Color(
                                                              0xff808BA1)
                                                          : const Color(
                                                              0xFFFFEDAD)),
                                              columnSpacing: 20,
                                              columns: [
                                                DataColumn(
                                                    label: Text(
                                                      'Rank',
                                                      style: TextStyle(
                                                          color: themeProvider
                                                                  .isDarkMode
                                                              ? Colors.white
                                                              : Colors.black),
                                                    ),
                                                    numeric: false,
                                                    onSort: null),
                                                DataColumn(
                                                  label: Text(
                                                    'Name',
                                                    style: TextStyle(
                                                        color: themeProvider
                                                                .isDarkMode
                                                            ? Colors.white
                                                            : Colors.black),
                                                  ),
                                                ),
                                                DataColumn(
                                                    label: Text(
                                                      'Total Quizzes',
                                                      style: TextStyle(
                                                          color: themeProvider
                                                                  .isDarkMode
                                                              ? Colors.white
                                                              : Colors.black),
                                                    ),
                                                    numeric: false,
                                                    onSort: null),
                                                DataColumn(
                                                    label: Text(
                                                      'Score',
                                                      style: TextStyle(
                                                          color: themeProvider
                                                                  .isDarkMode
                                                              ? Colors.white
                                                              : Colors.black),
                                                    ),
                                                    numeric: true,
                                                    onSort: _onSortId),
                                              ],
                                              rows: oldDataTable
                                                  .map(
                                                      (e) => DataRow(
                                                              selected: false,
                                                              cells: [
                                                                DataCell(
                                                                  Text(
                                                                    '${oldDataTable.indexOf(e) + 1}',
                                                                    style: const TextStyle(
                                                                        color: Colors
                                                                            .black),
                                                                  ),
                                                                ),
                                                                DataCell(
                                                                    Row(
                                                                      children: [
                                                                        const CircleAvatar(
                                                                          backgroundColor:
                                                                              Color(0xffBABABA),
                                                                          backgroundImage:
                                                                              AssetImage('assets/Image3.png'),
                                                                        ),
                                                                        const SizedBox(
                                                                          width:
                                                                              16,
                                                                        ),
                                                                        Text(
                                                                          "${e['name']}",
                                                                          style:
                                                                              const TextStyle(color: Colors.black),
                                                                        ),
                                                                        const Spacer(),
                                                                      ],
                                                                    ),
                                                                    showEditIcon:
                                                                        false,
                                                                    onTap:
                                                                        () {}),
                                                                DataCell(
                                                                  Text(
                                                                    "${e['total-quiz']}",
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style: const TextStyle(
                                                                        color: Colors
                                                                            .black),
                                                                  ),
                                                                ),
                                                                DataCell(
                                                                  Text(
                                                                    "${e['scores']}",
                                                                    style: const TextStyle(
                                                                        color: Colors
                                                                            .black),
                                                                  ),
                                                                ),
                                                              ]))
                                                  .toList()),
                                    )),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                    decoration: BoxDecoration(
                                        color: themeProvider.isDarkMode
                                            ? const Color(0xffD2D6DA)
                                            : const Color(0xffFFFAD0),
                                        shape: BoxShape.rectangle),
                                    child: Theme(
                                      data: Theme.of(context).copyWith(
                                          dividerColor:
                                              const Color(0xffBABABA)),
                                      child: dataTable.isEmpty
                                          ? Center(
                                              child: Text(
                                              'No data',
                                              style: TextStyle(fontSize: 40),
                                            ))
                                          : DataTable(
                                              sortColumnIndex: 3,
                                              sortAscending: _sortAscending,
                                              headingRowHeight: 80,
                                              dataRowHeight: 80,
                                              headingTextStyle: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold),
                                              dataTextStyle: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 24),
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius
                                                      .circular(20)),
                                              headingRowColor:
                                                  MaterialStateProperty.all(
                                                      themeProvider.isDarkMode
                                                          ? const Color(
                                                              0xff808BA1)
                                                          : const Color(
                                                              0xFFFFEDAD)),
                                              columnSpacing: 20,
                                              columns: [
                                                DataColumn(
                                                    label: Text(
                                                      'Rank',
                                                      style: TextStyle(
                                                          color: themeProvider
                                                                  .isDarkMode
                                                              ? Colors.white
                                                              : Colors.black),
                                                    ),
                                                    numeric: false,
                                                    onSort: null),
                                                DataColumn(
                                                  label: Text(
                                                    'Name',
                                                    style: TextStyle(
                                                        color: themeProvider
                                                                .isDarkMode
                                                            ? Colors.white
                                                            : Colors.black),
                                                  ),
                                                ),
                                                DataColumn(
                                                    label: Text(
                                                      'Total Quizzes',
                                                      style: TextStyle(
                                                          color: themeProvider
                                                                  .isDarkMode
                                                              ? Colors.white
                                                              : Colors.black),
                                                    ),
                                                    numeric: false,
                                                    onSort: null),
                                                DataColumn(
                                                    label: Text(
                                                      'Score',
                                                      style: TextStyle(
                                                          color: themeProvider
                                                                  .isDarkMode
                                                              ? Colors.white
                                                              : Colors.black),
                                                    ),
                                                    numeric: false,
                                                    onSort: _onSortId),
                                              ],
                                              rows: dataTable
                                                  .map(
                                                      (e) => DataRow(
                                                              selected: false,
                                                              cells: [
                                                                DataCell(
                                                                  Text(
                                                                    '${dataTable.indexOf(e) + 1}',
                                                                    style: const TextStyle(
                                                                        color: Colors
                                                                            .black),
                                                                  ),
                                                                ),
                                                                DataCell(
                                                                    Row(
                                                                      children: [
                                                                        const CircleAvatar(
                                                                          backgroundColor:
                                                                              Color(0xffBABABA),
                                                                          backgroundImage:
                                                                              AssetImage('assets/Image3.png'),
                                                                        ),
                                                                        const SizedBox(
                                                                          width:
                                                                              16,
                                                                        ),
                                                                        Text(
                                                                          "${e['name']}",
                                                                          style:
                                                                              const TextStyle(color: Colors.black),
                                                                        ),
                                                                        const Spacer(),
                                                                      ],
                                                                    ),
                                                                    showEditIcon:
                                                                        false,
                                                                    onTap:
                                                                        () {}),
                                                                DataCell(
                                                                  Text(
                                                                    "${e['total-quiz']}",
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style: const TextStyle(
                                                                        color: Colors
                                                                            .black),
                                                                  ),
                                                                ),
                                                                DataCell(
                                                                  Text(
                                                                    "${e['scores']}",
                                                                    style: const TextStyle(
                                                                        color: Colors
                                                                            .black),
                                                                  ),
                                                                ),
                                                              ]))
                                                  .toList()),
                                    )),
                              ),
                            ]),
                          )),
                        ]),
                  )),
            ],
          )),
    );
  }
}
