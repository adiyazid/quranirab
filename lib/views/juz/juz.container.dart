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
