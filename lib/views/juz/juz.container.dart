import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran/quran.dart';

import '../../provider/ayah.number.provider.dart';
import '../../theme/theme_provider.dart';
import '../surah.screen.dart';

class JuzContainer extends StatefulWidget {
  const JuzContainer({
    Key? key,
    required this.mainIndex,
    required this.themeProvider,
    required this.start,
    required this.end,
    required this.list,
  }) : super(key: key);
  final int start;
  final int end;
  final int mainIndex;
  final List list;
  final ThemeProvider themeProvider;

  @override
  State<JuzContainer> createState() => _JuzContainerState();
}

class _JuzContainerState extends State<JuzContainer> {
  List jusRange = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all()),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                width: 600,
                height: 30.0,
                decoration: BoxDecoration(
                    color: widget.themeProvider.isDarkMode
                        ? Color(0xff67748E)
                        : Color.fromRGBO(255, 255, 255, 1),
                    border: Border.all(
                      color: widget.themeProvider.isDarkMode
                          ? Color(0xffD2D6DA)
                          : Color.fromRGBO(231, 111, 0, 1),
                      width: 1,
                    )),
                child: Center(
                  child: Text(
                    'Juz ${widget.mainIndex + 1}',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontFamily: 'Open Sans',
                        fontSize: 24,
                        letterSpacing: -0.38723403215408325,
                        fontWeight: FontWeight.normal,
                        height: 1),
                  ),
                )),
            for (var i = widget.start; i <= widget.end; i++)
              ListTile(
                onTap: () async {
                  var name = widget.list[i]['tname'];
                  var detail = widget.list[i]['ename'];
                  var index = 0;
                  var allPages = await getJuzRange(i + 1);
                  Provider.of<AyaProvider>(context, listen: false)
                      .getPage(int.parse(allPages.first));
                  Provider.of<AyaProvider>(context, listen: false).setDefault();
                  Provider.of<AyaProvider>(context, listen: false)
                      .getStart(i + 1, int.parse(allPages.first));
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SurahScreen(
                              allPages, '${i + 1}', name, detail, index)));
                },
                title: Text('${widget.list[i]['tname']}'),
                subtitle: Text('${widget.list[i]['ename']}'),
                trailing: Text(
                  '${getPageNumber(i + 1, widget.mainIndex + 1)}',
                  textAlign: TextAlign.center,
                ),
              )
          ],
        ),
      ),
    );
  }

  Future<List> getJuzRange(int suraId) async {
    print('$suraId ${widget.mainIndex}');
    if (suraId == 11 && widget.mainIndex + 1 == 11) return ['221'];
    if (suraId == 84 && widget.mainIndex + 1 == 30) return ['589'];
    if (suraId == 88 && widget.mainIndex + 1 == 30) return ['592'];
    if (suraId == 90 && widget.mainIndex + 1 == 30) return ['594'];

    List list = [];
    if (suraId == 5 && widget.mainIndex + 1 == 6) {
      list.add('106');
    } else if (suraId == 11 && widget.mainIndex + 1 == 11) {
      list.add('221');
    } else if (suraId == 12 && widget.mainIndex + 1 == 12) {
      list.add('235');
    } else if (suraId == 14 && widget.mainIndex + 1 == 13) {
      list.add('255');
    } else if (suraId == 16 && widget.mainIndex + 1 == 14) {
      list.add('267');
    } else if (suraId == 18 && widget.mainIndex + 1 == 15) {
      list.add('293');
    } else if (suraId == 20 && widget.mainIndex + 1 == 16) {
      list.add('312');
    } else if (suraId == 25 && widget.mainIndex + 1 == 18) {
      list.add('359');
    } else if (suraId == 28 && widget.mainIndex + 1 == 20) {
      list.add('385');
    } else if (suraId == 29 && widget.mainIndex + 1 == 20) {
      list.add('396');
    } else if (suraId == 30 && widget.mainIndex + 1 == 21) {
      list.add('404');
    } else if (suraId == 35 && widget.mainIndex + 1 == 22) {
      list.add('434');
    } else if (suraId == 36 && widget.mainIndex + 1 == 22) {
      list.add('440');
    } else if (suraId == 39 && widget.mainIndex + 1 == 23) {
      list.add('458');
    } else if (suraId == 68 && widget.mainIndex + 1 == 29) {
      list.add('564');
    } else if (suraId == 69 && widget.mainIndex + 1 == 29) {
      list.add('566');
    } else if (suraId == 71 && widget.mainIndex + 1 == 29) {
      list.add('570');
    } else if (suraId == 74 && widget.mainIndex + 1 == 29) {
      list.add('575');
    } else if (suraId == 75 && widget.mainIndex + 1 == 29) {
      list.add('577');
    } else if (suraId == 76 && widget.mainIndex + 1 == 29) {
      list.add('578');
    } else if (suraId == 77 && widget.mainIndex + 1 == 29) {
      list.add('580');
    } else if (suraId == 79 && widget.mainIndex + 1 == 30) {
      list.add('583');
    } else if (suraId == 83 && widget.mainIndex + 1 == 30) {
      list.add('587');
    } else if (suraId == 84 && widget.mainIndex + 1 == 30) {
      list.add('589');
    } else if (suraId == 87 && widget.mainIndex + 1 == 30) {
      list.add('591');
    } else if (suraId == 88 && widget.mainIndex + 1 == 30) {
      list.add('592');
    } else if (suraId == 90 && widget.mainIndex + 1 == 30) {
      list.add('594');
    } else if (suraId == 92 && widget.mainIndex + 1 == 30) {
      list.add('595');
    } else if (suraId == 93 && widget.mainIndex + 1 == 30) {
      list.add('596');
    } else if (suraId == 94 && widget.mainIndex + 1 == 30) {
      list.add('596');
    } else if (suraId == 96 && widget.mainIndex + 1 == 30) {
      list.add('597');
    } else if (suraId == 98 && widget.mainIndex + 1 == 30) {
      list.add('598');
    } else if (suraId == 99 && widget.mainIndex + 1 == 30) {
      list.add('599');
    } else if (suraId == 100 && widget.mainIndex + 1 == 30) {
      list.add('599');
    } else if (suraId == 101 && widget.mainIndex + 1 == 30) {
      list.add('600');
    } else if (suraId == 102 && widget.mainIndex + 1 == 30) {
      list.add('600');
    } else if (suraId == 104 && widget.mainIndex + 1 == 30) {
      list.add('601');
    } else if (suraId == 105 && widget.mainIndex + 1 == 30) {
      list.add('601');
    } else if (suraId == 107 && widget.mainIndex + 1 == 30) {
      list.add('602');
    } else if (suraId == 108 && widget.mainIndex + 1 == 30) {
      list.add('602');
    } else if (suraId == 110 && widget.mainIndex + 1 == 30) {
      list.add('603');
    } else if (suraId == 111 && widget.mainIndex + 1 == 30) {
      list.add('603');
    } else if (suraId == 113 && widget.mainIndex + 1 == 30) {
      list.add('604');
    } else if (suraId == 114 && widget.mainIndex + 1 == 30) {
      list.add('604');
    }
    try {
      await FirebaseFirestore.instance
          .collection('medina_mushaf_pages')
          .where('juz_id', isEqualTo: '${widget.mainIndex + 1}')
          .orderBy('created_at')
          .get()
          .catchError((e) {
        print(e);
      }).then((QuerySnapshot querySnapshot) {
        for (var doc in querySnapshot.docs) {
          if (doc['sura_id'] == '$suraId') {
            setState(() {});
            list.add(doc['id']);
          }
        }
      });
      setState(() {});
      jusRange = list;
    } catch (e) {
      print('error');
    }

    return list;
  }

  getPageNumber(int sura, int juz) {
    var start = '';
    var a = getSurahAndVersesFromJuz(juz);
    a.forEach((key, value) {
      if (key == sura) {
        start = '${value.first} - ${value.last}';
      }
    });
    return start;
  }
}
