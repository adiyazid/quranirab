import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:quranirab/views/surah.screen.dart';

import '../../theme/theme_provider.dart';

class JuzDisplay extends StatefulWidget {
  const JuzDisplay({required this.sura, Key? key}) : super(key: key);
  final List sura;

  @override
  State<JuzDisplay> createState() => _JuzDisplayState();
}

class _JuzDisplayState extends State<JuzDisplay> {
  final List _juz = [
    {"id": 1, "start": 0, "end": 1},
    {"id": 1, "start": 3, "end": 4},
    {"id": 1, "start": 5, "end": 7},
    {"id": 1, "start": 8, "end": 20},
    {"id": 1, "start": 21, "end": 40},
    {"id": 1, "start": 41, "end": 50},
    {"id": 1, "start": 51, "end": 76},
    {"id": 1, "start": 77, "end": 113}
  ];

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    return MasonryGridView.count(
        controller: ScrollController(keepScrollOffset: false),
        crossAxisCount: MediaQuery.of(context).size.width < 1200 ? 2 : 3,
        crossAxisSpacing: 4.0,
        mainAxisSpacing: 4.0,
        shrinkWrap: false,
        itemCount: _juz.length,
        itemBuilder: (BuildContext context, int mainIndex) {
          return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: JuzContainer(
                themeProvider: themeProvider,
                mainIndex: mainIndex,
                start: _juz[mainIndex]['start'],
                end: _juz[mainIndex]['end'],
                list: widget.sura,
                allPages: getJuzRange(mainIndex),
              ));
        });
  }

  List getJuzRange(int mainIndex) {
    List list = ['1'];
    return list;
  }
}

class JuzContainer extends StatelessWidget {
  const JuzContainer({
    Key? key,
    required this.mainIndex,
    required this.themeProvider,
    required this.start,
    required this.end,
    required this.list,
    required this.allPages,
  }) : super(key: key);
  final int start;
  final int end;
  final int mainIndex;
  final List list;
  final ThemeProvider themeProvider;
  final List allPages;

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
                    color: themeProvider.isDarkMode
                        ? Color(0xff67748E)
                        : Color.fromRGBO(255, 255, 255, 1),
                    border: Border.all(
                      color: themeProvider.isDarkMode
                          ? Color(0xffD2D6DA)
                          : Color.fromRGBO(231, 111, 0, 1),
                      width: 1,
                    )),
                child: Center(
                  child: Text(
                    'Juz ${mainIndex + 1}',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontFamily: 'Open Sans',
                        fontSize: 24,
                        letterSpacing: -0.38723403215408325,
                        fontWeight: FontWeight.normal,
                        height: 1),
                  ),
                )),
            for (var i = start; i <= end; i++)
              ListTile(
                onTap: () async {
                  var name = '';
                  var detail = '';
                  var index = 0;
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SurahScreen(
                              allPages, '$i', name, detail, index)));
                },
                title: Text('${list[i]['tname']}'),
                subtitle: Text('${list[i]['ename']}'),
                trailing: Text('${allPages.first}-${allPages.last}'),
              )
          ],
        ),
      ),
    );
  }
}
