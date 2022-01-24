import 'package:flutter/material.dart';
import 'package:quranirab/widget/LanguagePopup.dart';
import 'package:quranirab/widget/SettingPopup.dart';
import 'package:quranirab/widget/menu.dart';

class LeaderBoardTable extends StatefulWidget {
  const LeaderBoardTable({Key? key}) : super(key: key);

  @override
  _LeaderBoardTableState createState() => _LeaderBoardTableState();
}

class _LeaderBoardTableState extends State<LeaderBoardTable> {
  var dataTable = [
    LeaderBoard(1, 'Fajar', 10, 100),
    LeaderBoard(2, 'Dania', 10, 90),
    LeaderBoard(3, 'Hakimi', 10, 80),
    LeaderBoard(4, 'Fang', 10, 70),
    LeaderBoard(5, 'Safuan', 10, 60),
    LeaderBoard(6, 'Mai', 10, 50),
    LeaderBoard(7, 'Sanjev', 10, 40),
    LeaderBoard(8, 'Ayu', 10, 30),
    LeaderBoard(9, 'Hanan', 10, 20),
    LeaderBoard(10, 'Adnin', 10, 10),
  ];
  bool _sortAscending = false;

  _onSortId(int index, bool ascending) {
    setState(() {
      _sortAscending = ascending;
      dataTable.sort((a, b) =>
          ascending ? a.score.compareTo(b.score) : b.score.compareTo(a.score));
    });
  }

  @override
  Widget build(BuildContext context) {
    // Figma Flutter Generator Desktop2Widget - FRAME
    return Scaffold(
      drawer: const Menu(),
      body: DefaultTabController(
          length: 2,
          child: NestedScrollView(
              headerSliverBuilder: (context, value) {
                return [
                  SliverAppBar(
                    iconTheme: Theme.of(context).iconTheme,
                    leading: IconButton(
                      icon: const Icon(
                        Icons.menu,
                      ),
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                    ),
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    title: const CircleAvatar(
                      backgroundImage: AssetImage('assets/quranirab.png'),
                      radius: 18.0,
                    ),
                    centerTitle: false,
                    floating: true,
                    actions: [
                      Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.search,
                              size: 26.0,
                            )),
                      ),
                      const Padding(
                          padding: EdgeInsets.only(right: 20.0), child: LangPopup()),
                      const Padding(
                          padding: EdgeInsets.only(right: 20.0),
                          child: SettingPopup()),
                    ],
                  ),
                ];
              },
              body: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(255, 237, 173, 1),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Padding(
                            padding: EdgeInsets.all(40.0),
                            child: Text(
                              'Leaderboards',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Color.fromRGBO(0, 0, 0, 1),
                                  fontFamily: 'Source Serif Pro',
                                  fontSize: 72,
                                  letterSpacing:
                                      0 /*percentages not used in flutter. defaulting to zero*/,
                                  fontWeight: FontWeight.normal,
                                  height: 1),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 40.0),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: TabBar(
                                  indicator: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      // Creates border
                                      color: const Color(0xffFFFAD0)),
                                  tabs: const [
                                    Text(
                                      'All time',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Color.fromRGBO(0, 0, 0, 1),
                                          fontFamily: 'Source Serif Pro',
                                          fontSize: 36,
                                          letterSpacing:
                                              0 /*percentages not used in flutter. defaulting to zero*/,
                                          fontWeight: FontWeight.normal,
                                          height: 1),
                                    ),
                                    Text(
                                      'Last 30 days',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Color.fromRGBO(0, 0, 0, 1),
                                          fontFamily: 'Source Serif Pro',
                                          fontSize: 36,
                                          letterSpacing:
                                              0 /*percentages not used in flutter. defaulting to zero*/,
                                          fontWeight: FontWeight.normal,
                                          height: 1),
                                    ),
                                  ]),
                            ),
                          ),
                          const Divider(
                              color: Color.fromRGBO(0, 0, 0, 1), thickness: 1),
                          Center(
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.7,
                              height: MediaQuery.of(context).size.height * 0.82,
                              child: TabBarView(children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                      decoration: const BoxDecoration(
                                          color: Color(0xffFFFAD0),
                                          shape: BoxShape.rectangle),
                                      child: Theme(
                                        data: Theme.of(context).copyWith(
                                            dividerColor:
                                                const Color(0xffBABABA)),
                                        child: DataTable(
                                            sortColumnIndex: 3,
                                            sortAscending: _sortAscending,
                                            headingRowHeight: 80,
                                            dataRowHeight: 80,
                                            headingTextStyle: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 32,
                                                fontWeight: FontWeight.bold),
                                            dataTextStyle: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 32),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            headingRowColor:
                                                MaterialStateProperty.all(
                                                    const Color(0xFFFFEDAD)),
                                            columnSpacing: 20,
                                            columns: [
                                              const DataColumn(
                                                  label: Text(
                                                    'Rank',
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                  numeric: false,
                                                  onSort: null),
                                              const DataColumn(
                                                label: Text(
                                                  'Name',
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ),
                                              ),
                                              const DataColumn(
                                                  label: Text(
                                                    'Pages\nCompleted',
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                  numeric: false,
                                                  onSort: null),
                                              DataColumn(
                                                  label: const Text(
                                                    'Score',
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                  numeric: false,
                                                  onSort: _onSortId),
                                            ],
                                            rows: dataTable
                                                .map((e) => DataRow(
                                                        selected: false,
                                                        cells: [
                                                          DataCell(
                                                            Text(
                                                              '${e.rank}',
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                          ),
                                                          DataCell(
                                                              Text(
                                                                e.name,
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .black),
                                                              ),
                                                              showEditIcon:
                                                                  false,
                                                              onTap: () {}),
                                                          DataCell(
                                                            Text(
                                                              "${e.chapterCompleted}",
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
                                                              "${e.score}",
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
                                      decoration: const BoxDecoration(
                                          color: Color(0xffFFFAD0),
                                          shape: BoxShape.rectangle),
                                      child: Theme(
                                        data: Theme.of(context).copyWith(
                                            dividerColor:
                                                const Color(0xffBABABA)),
                                        child: DataTable(
                                            dataRowHeight: 80,
                                            headingRowHeight: 80,
                                            headingTextStyle: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 32,
                                                fontWeight: FontWeight.bold),
                                            dataTextStyle: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 32),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            headingRowColor:
                                                MaterialStateProperty.all(
                                                    const Color(0xFFFFEDAD)),
                                            columnSpacing: 20,
                                            sortColumnIndex: 3,
                                            sortAscending: _sortAscending,
                                            columns: [
                                              const DataColumn(
                                                  label: Text(
                                                    'Rank',
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                  numeric: false,
                                                  onSort: null),
                                              const DataColumn(
                                                label: Text(
                                                  'Name',
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ),
                                              ),
                                              const DataColumn(
                                                  label: Text(
                                                    'Chapters\nCompleted',
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                  numeric: false,
                                                  onSort: null),
                                              DataColumn(
                                                  label: const Text(
                                                    'Score',
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                  numeric: false,
                                                  onSort: _onSortId),
                                            ],
                                            rows: dataTable
                                                .map((e) => DataRow(
                                                        selected: false,
                                                        cells: [
                                                          DataCell(
                                                            Text(
                                                              '${e.rank}',
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                          ),
                                                          DataCell(
                                                              Text(
                                                                e.name,
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .black),
                                                              ),
                                                              showEditIcon:
                                                                  false,
                                                              onTap: () {}),
                                                          DataCell(
                                                            Text(
                                                              '${e.chapterCompleted}',
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
                                                              "${e.score}",
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
                            ),
                          ),
                        ]),
                  )))),
    );
  }
}

class LeaderBoard {
  final int rank;
  final String name;
  final int chapterCompleted;
  final int score;

  LeaderBoard(this.rank, this.name, this.chapterCompleted, this.score);

  @override
  String toString() {
    return 'LeaderBoard{rank: $rank, name: $name, chapters completed: $chapterCompleted, score: $score}';
  }
}
