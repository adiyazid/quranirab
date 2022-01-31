import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quranirab/theme/theme_provider.dart';
import 'package:quranirab/widget/LanguagePopup.dart';
import 'package:quranirab/widget/setting.popup.dart';
import 'package:quranirab/widget/menu.dart';

class LeaderBoardTable extends StatefulWidget {
  const LeaderBoardTable({Key? key}) : super(key: key);

  @override
  _LeaderBoardTableState createState() => _LeaderBoardTableState();
}

class _LeaderBoardTableState extends State<LeaderBoardTable> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  //
  // final usernameRef = FirebaseFirestore.instance.collection('quranIrabUsers');
  var dataTable = [];
  var userID = [];
  bool _sortAscending = false;

  _onSortId(int index, bool ascending) {
    setState(() {
      _sortAscending = ascending;
      dataTable.sort((a, b) => ascending
          ? a.score.compareTo(b['scores'])
          : b.score.compareTo(a['scores']));
    });
  }

  final leaderBoardRef = FirebaseFirestore.instance
      .collection('leaderboards')
      .doc('overall')
      .collection('scores');

  Future<void> init() async {
    List leaderboard = await leaderBoardRef
        .orderBy('scores', descending: true)
        .limit(10)
        .get()
        .then((snapshot) => snapshot.docs);
    setState(() {
      dataTable = leaderboard;
    });
    // await leaderBoardRef
    //     .where('category', isEqualTo: 'overall')
    //     .orderBy('score', descending: true)
    //     .limit(10)
    //     .get()
    //     .then((QuerySnapshot querySnapshot) {
    //   for (int i = 0; i < dataTable.length; i++) {
    //     setState(() {
    //       userID.add(querySnapshot.docs[i]['user-id']);
    //     });
    //   }
    //   getUserName(userID);
    // });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
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
                          padding: EdgeInsets.only(right: 20.0),
                          child: LangPopup()),
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
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                          width: 2.0,
                          color: themeProvider.isDarkMode
                              ? Colors.white
                              : const Color(0xffE86F00)),
                    ),
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
                                    Text(
                                      'All time',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: themeProvider.isDarkMode
                                              ? Colors.white
                                              : const Color.fromRGBO(
                                                  0, 0, 0, 1),
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
                                          color: themeProvider.isDarkMode
                                              ? Colors.white
                                              : const Color.fromRGBO(
                                                  0, 0, 0, 1),
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
                                    decoration: BoxDecoration(
                                        color: themeProvider.isDarkMode
                                            ? const Color(0xffD2D6DA)
                                            : const Color(0xffFFFAD0),
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
                                          headingRowColor: MaterialStateProperty
                                              .all(themeProvider.isDarkMode
                                                  ? const Color(0xff808BA1)
                                                  : const Color(0xFFFFEDAD)),
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
                                                    color:
                                                        themeProvider.isDarkMode
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
                                              .map((e) => DataRow(
                                                      selected: false,
                                                      cells: [
                                                        DataCell(
                                                          Text(
                                                            '${dataTable.indexOf(e) + 1}',
                                                            style:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .black),
                                                          ),
                                                        ),
                                                        DataCell(
                                                            Row(
                                                              children: [
                                                                const CircleAvatar(
                                                                  backgroundColor:
                                                                      Color(
                                                                          0xffBABABA),
                                                                  backgroundImage:
                                                                      AssetImage(
                                                                          'assets/Image3.png'),
                                                                ),
                                                                const SizedBox(
                                                                  width: 16,
                                                                ),
                                                                Text(
                                                                  "${e['name']}",
                                                                  style: const TextStyle(
                                                                      color: Colors
                                                                          .black),
                                                                ),
                                                                const Spacer(),
                                                              ],
                                                            ),
                                                            showEditIcon: false,
                                                            onTap: () {}),
                                                        DataCell(
                                                          Text(
                                                            "${e['total-quiz']}",
                                                            textAlign: TextAlign
                                                                .center,
                                                            style:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .black),
                                                          ),
                                                        ),
                                                        DataCell(
                                                          Text(
                                                            "${e['scores']}",
                                                            style:
                                                                const TextStyle(
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
                                          headingRowColor: MaterialStateProperty
                                              .all(themeProvider.isDarkMode
                                                  ? const Color(0xff808BA1)
                                                  : const Color(0xFFFFEDAD)),
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
                                                    color:
                                                        themeProvider.isDarkMode
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
                                              .map((e) => DataRow(
                                                      selected: false,
                                                      cells: [
                                                        DataCell(
                                                          Text(
                                                            '${dataTable.indexOf(e) + 1}',
                                                            style:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .black),
                                                          ),
                                                        ),
                                                        DataCell(
                                                            Row(
                                                              children: [
                                                                const CircleAvatar(
                                                                  backgroundColor:
                                                                      Color(
                                                                          0xffBABABA),
                                                                  backgroundImage:
                                                                      AssetImage(
                                                                          'assets/Image3.png'),
                                                                ),
                                                                const SizedBox(
                                                                  width: 16,
                                                                ),
                                                                Text(
                                                                  "${e['name']}",
                                                                  style: const TextStyle(
                                                                      color: Colors
                                                                          .black),
                                                                ),
                                                                const Spacer(),
                                                              ],
                                                            ),
                                                            showEditIcon: false,
                                                            onTap: () {}),
                                                        DataCell(
                                                          Text(
                                                            "${e['total-quiz']}",
                                                            textAlign: TextAlign
                                                                .center,
                                                            style:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .black),
                                                          ),
                                                        ),
                                                        DataCell(
                                                          Text(
                                                            "${e['scores']}",
                                                            style:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .black),
                                                          ),
                                                        ),
                                                      ]))
                                              .toList()),
                                    )),
                              ),
                              // Padding(
                              //   padding: const EdgeInsets.all(8.0),
                              //   child: Container(
                              //       decoration: BoxDecoration(
                              //           color: themeProvider.isDarkMode
                              //               ? const Color(0xffD2D6DA)
                              //               : const Color(0xffFFFAD0),
                              //           shape: BoxShape.rectangle),
                              //       child: Theme(
                              //         data: Theme.of(context).copyWith(
                              //             dividerColor:
                              //                 const Color(0xffBABABA)),
                              //         child: DataTable(
                              //             sortColumnIndex: 3,
                              //             sortAscending: _sortAscending,
                              //             headingRowHeight: 80,
                              //             dataRowHeight: 80,
                              //             headingTextStyle: const TextStyle(
                              //                 color: Colors.black,
                              //                 fontSize: 32,
                              //                 fontWeight: FontWeight.bold),
                              //             dataTextStyle: const TextStyle(
                              //                 color: Colors.black,
                              //                 fontSize: 32),
                              //             decoration: BoxDecoration(
                              //                 borderRadius:
                              //                     BorderRadius.circular(20)),
                              //             headingRowColor:
                              //                 MaterialStateProperty.all(
                              //                     themeProvider.isDarkMode
                              //                         ? const Color(
                              //                             0xff808BA1)
                              //                         : const Color(
                              //                             0xFFFFEDAD)),
                              //             columnSpacing: 20,
                              //             columns: [
                              //               DataColumn(
                              //                   label: Text(
                              //                     'Rank',
                              //                     style: TextStyle(
                              //                         color: themeProvider
                              //                                 .isDarkMode
                              //                             ? Colors.white
                              //                             : Colors.black),
                              //                   ),
                              //                   numeric: false,
                              //                   onSort: null),
                              //               DataColumn(
                              //                 label: Text(
                              //                   'Name',
                              //                   style: TextStyle(
                              //                       color: themeProvider
                              //                               .isDarkMode
                              //                           ? Colors.white
                              //                           : Colors.black),
                              //                 ),
                              //               ),
                              //               DataColumn(
                              //                   label: Text(
                              //                     'Total Pages',
                              //                     style: TextStyle(
                              //                         color: themeProvider
                              //                                 .isDarkMode
                              //                             ? Colors.white
                              //                             : Colors.black),
                              //                   ),
                              //                   numeric: false,
                              //                   onSort: null),
                              //               DataColumn(
                              //                   label: Text(
                              //                     'Score',
                              //                     style: TextStyle(
                              //                         color: themeProvider
                              //                                 .isDarkMode
                              //                             ? Colors.white
                              //                             : Colors.black),
                              //                   ),
                              //                   numeric: false,
                              //                   onSort: _onSortId),
                              //             ],
                              //             rows: dataTable
                              //                 .map(
                              //                     (e) => DataRow(
                              //                             selected: false,
                              //                             cells: [
                              //                               DataCell(
                              //                                 Text(
                              //                                   '${e.rank}',
                              //                                   style: const TextStyle(
                              //                                       color: Colors
                              //                                           .black),
                              //                                 ),
                              //                               ),
                              //                               DataCell(
                              //                                   Row(
                              //                                     children: [
                              //                                       const CircleAvatar(
                              //                                         backgroundColor:
                              //                                             Color(0xffBABABA),
                              //                                         backgroundImage:
                              //                                             AssetImage('assets/Image3.png'),
                              //                                       ),
                              //                                       const SizedBox(
                              //                                         width:
                              //                                             16,
                              //                                       ),
                              //                                       Text(
                              //                                         e.name,
                              //                                         style: const TextStyle(
                              //                                             color:
                              //                                                 Colors.black),
                              //                                       ),
                              //                                       const Spacer(),
                              //                                     ],
                              //                                   ),
                              //                                   showEditIcon:
                              //                                       false,
                              //                                   onTap: () {}),
                              //                               DataCell(
                              //                                 Text(
                              //                                   "${e.chapterCompleted}",
                              //                                   textAlign:
                              //                                       TextAlign
                              //                                           .center,
                              //                                   style: const TextStyle(
                              //                                       color: Colors
                              //                                           .black),
                              //                                 ),
                              //                               ),
                              //                               DataCell(
                              //                                 Text(
                              //                                   "${e.score}",
                              //                                   style: const TextStyle(
                              //                                       color: Colors
                              //                                           .black),
                              //                                 ),
                              //                               ),
                              //                             ]))
                              //                 .toList()),
                              //       )),
                              // ),
                            ]),
                          )),
                        ]),
                  )))),
    );
  }
}
//   Future<void> getUserName(List<dynamic> userID) async {
//     for (int i = 0; i < userID.length; i++) {
//       await usernameRef.doc(userID[i]).get().then((value) {
//         setState(() {
//           _userName.add('${value['first_name']} ${value['last_name']}');
//         });
//       });
//     }
//   }
// }

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
