import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TestSplit extends StatefulWidget {
  const TestSplit({Key? key}) : super(key: key);

  @override
  State<TestSplit> createState() => _TestSplitState();
}

class _TestSplitState extends State<TestSplit> {
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('raw_quran_texts')
      .where('id', isEqualTo: '1')
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: _usersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }

          return Directionality(
            textDirection: TextDirection.rtl,
            child: ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                var text = Characters(data['text']);
                return Padding(
                  padding: const EdgeInsets.only(top: 80.0),
                  child: Column(
                    children: [
                      Container(
                          alignment: Alignment.center,
                          child: Center(
                              child: Text(
                                data['text'],
                                textDirection: TextDirection.rtl,
                                style: TextStyle(
                                    fontFamily: 'MeQuran2', fontSize: 30),
                              ))),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          for (int i = 0;
                              i < data['text'].split(' ').length;
                              i++)
                            Container(
                                alignment: Alignment.center,
                                child: Center(
                                    child: Text(
                                  data['text'].split(' ')[i],
                                  textDirection: TextDirection.rtl,
                                  style: TextStyle(
                                      fontFamily: 'MeQuran2', fontSize: 30),
                                ))),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          for (int i = 0; i < text.length; i++)
                            Container(
                                alignment: Alignment.center,
                                child: Center(
                                    child: Text(
                                  text.elementAt(i),
                                  textDirection: TextDirection.rtl,
                                  style: TextStyle(
                                      fontFamily: 'MeQuran2', fontSize: 30),
                                ))),
                        ],
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
