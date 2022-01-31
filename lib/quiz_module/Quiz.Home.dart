import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quranirab/facebook/screens/Appbar/appbar.dart';
import 'package:quranirab/quiz_module/LeaderBoard.Menu.dart';
import 'package:quranirab/widget/menu.dart';
import 'package:quranirab/widget/setting.dart';

class QuizHome extends StatefulWidget {
  const QuizHome({Key? key}) : super(key: key);

  @override
  _QuizHomeState createState() => _QuizHomeState();
}

class _QuizHomeState extends State<QuizHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Menu(),
      endDrawer: const Setting(),
      body: DefaultTabController(
        length: 3,
        child: Stack(
          children: [
            SizedBox(
              height: 115,
              child: CustomScrollView(
                slivers: [
                  const Appbar(),
                  SliverToBoxAdapter(
                    child: TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const LeaderBoardMenu()));
                        },
                        child: const Text('LeaderBoard')),
                  ),
                  SliverToBoxAdapter(
                    child: TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const QuizMenu()));
                        },
                        child: const Text('Quiz')),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class QuizMenu extends StatefulWidget {
  const QuizMenu({Key? key}) : super(key: key);

  @override
  _QuizMenuState createState() => _QuizMenuState();
}

class _QuizMenuState extends State<QuizMenu> {
  List _list = [];
  final CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('quran_texts');

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Center(
        child: Text(
          _list.isNotEmpty ? _list[0] : 'Loading...',
          style: const TextStyle(
              fontSize: 40, fontFamily: 'MeQuran2', color: Colors.white),
        ),
      ),
      Center(
        child: Text(
          _list.isNotEmpty ? _list[0].substring(15, 26) : 'Loading...',
          style: const TextStyle(
              fontSize: 40, fontFamily: 'MeQuran2', color: Colors.white),
        ),
      ),
      const Center(
        child: Text(
          'علامة الاسم',
          style: TextStyle(
              fontSize: 40, fontFamily: 'MeQuran2', color: Colors.white),
        ),
      ),
      const Center(
        child: Text(
          'الاسم',
          style: TextStyle(
              fontSize: 40, fontFamily: 'MeQuran2', color: Colors.white),
        ),
      ),
      const Center(
        child: Text(
          'الفعل',
          style: TextStyle(
              fontSize: 40, fontFamily: 'MeQuran2', color: Colors.white),
        ),
      ),
      const Center(
        child: Text(
          'الحرف',
          style: TextStyle(
              fontSize: 40, fontFamily: 'MeQuran2', color: Colors.white),
        ),
      ),
    ]));
  }

  Future<void> getData() async {
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await _collectionRef
        .where('sura_id', isEqualTo: "36")
        .where('aya', isEqualTo: "4")
        .get();

    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    setState(() {
      _list = allData;
    });
    //convert dynamic map list into string list
    var data = _list.map((e) => e["text"]).toList();
    setState(() {
      _list = data;
    });
  }
}
