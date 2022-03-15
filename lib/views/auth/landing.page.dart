
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quranirab/provider/user.provider.dart';
import 'package:quranirab/views/quran.words.dart';
import 'package:quranirab/views/slice/slice2.dart';

import '../slice/test.slice.dart';
import 'login.screen.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appUser = Provider.of<AppUser>(context);

    if (appUser.user != null) {
      print('Logged in');
      // return const DataFromFirestore();
      return const DummyPage();
    } else {
      print('Not logged in');
      return const SigninWidget();
    }
  }
}

class DummyPage extends StatelessWidget {
  const DummyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                     TestSplit()));
                      },
                      child: const Text('Surah screen')),
                  const SizedBox(
                    height: 8,
                  ),
                  // ElevatedButton(
                  //     onPressed: () {
                  //       Navigator.push(
                  //           context,
                  //           MaterialPageRoute(
                  //               builder: (context) =>
                  //                   const FacebookHomeScreen2()));
                  //     },
                  //     child: const Text('Surah screen2')),
                  // const SizedBox(
                  //   height: 8,
                  // ),
                  // ElevatedButton(
                  //     onPressed: () {
                  //       Navigator.push(
                  //           context,
                  //           MaterialPageRoute(
                  //               builder: (context) =>
                  //                   const FacebookHomeScreen3()));
                  //     },
                  //     child: const Text('Surah screen3')),
                  // ElevatedButton(
                  //     onPressed: () {
                  //       Navigator.push(
                  //           context,
                  //           MaterialPageRoute(
                  //               builder: (context) => const Slice()));
                  //     },
                  //     child: const Text('Flutter Slice')),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Slice2()));
                      },
                      child: const Text('Flutter Slice')),
                  // ElevatedButton(
                  //     onPressed: () {
                  //       Navigator.push(
                  //           context,
                  //           MaterialPageRoute(
                  //               builder: (context) => const LandingPage()));
                  //     },
                  //     child: const Text('Firebase integration')),
                  // const SizedBox(
                  //   height: 8,
                  // ),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Words()));
                      },
                      child: const Text('Alfatihah slice')),
                  // ElevatedButton(
                  //     onPressed: () {
                  //       Navigator.push(
                  //           context,
                  //           MaterialPageRoute(
                  //               builder: (context) => const QuizHome()));
                  //     },
                  //     child: const Text('Quiz')),
                ]),
          )),
    );
  }
}


// class Slice extends StatefulWidget {
//   const Slice({Key? key}) : super(key: key);
//
//   @override
//   _SliceState createState() => _SliceState();
// }
//
// class _SliceState extends State<Slice> {
//   CollectionReference quranText =
//       FirebaseFirestore.instance.collection('quran_texts');
//   CollectionReference rawText =
//       FirebaseFirestore.instance.collection('raw_quran_texts');
//   CollectionReference sliceData =
//       FirebaseFirestore.instance.collection('medina_mushaf_pages');
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     // getData();
//     super.initState();
//   }
//
//   final Stream<QuerySnapshot> _textsStream = FirebaseFirestore.instance
//       .collection('quran_texts')
//       .where('medina_mushaf_page_id', isEqualTo: '1')
//       .snapshots();
//
//   @override
//   Widget build(BuildContext context) {
//     final themeProvider = Provider.of<ThemeProvider>(context);
//     return Scaffold(
//       appBar: AppBar(),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: _textsStream,
//         builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (snapshot.hasError) {
//             return Center(child: Text('Something went wrong'));
//           }
//
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: Text("Loading"));
//           }
//
//           return ListView(
//             children: snapshot.data!.docs.map((DocumentSnapshot document) {
//               Map<String, dynamic> data =
//                   document.data()! as Map<String, dynamic>;
//               return ListTile(
//                 title: Container(
//                   color: themeProvider.isDarkMode ? Colors.white : Colors.white,
//                   child: Text(
//                     data['text'].substring(2, 6),
//                     textDirection: TextDirection.rtl,
//                     textAlign: TextAlign.center,
//                     style: TextStyle(fontFamily: 'MeQuran2', fontSize: 30),
//                   ),
//                 ),
//                 // subtitle: Text(
//                 //   data['text1'].trim().replaceAll('b', '\n'),
//                 //   textAlign: TextAlign.center,
//                 //   style: TextStyle(fontFamily: 'MeQuran2', fontSize: 30),
//                 // ),
//               );
//             }).toList(),
//           );
//         },
//       ),
//     );
//   }
//
// // void getData() {
// //   FirebaseFirestore.instance
// //       .collection('quran_texts')
// //       .where('medina_mushaf_page_id', isEqualTo: '1')
// //       .get()
// //       .then((QuerySnapshot querySnapshot) {
// //     querySnapshot.docs.forEach((doc) {
// //       print(doc["text"]);
// //     });
// //   });
// // }
// }

