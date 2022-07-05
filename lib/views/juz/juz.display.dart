import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

import '../../theme/theme_provider.dart';
import 'juz.container.dart';

class JuzDisplay extends StatefulWidget {
  const JuzDisplay({required this.sura, Key? key}) : super(key: key);
  final List sura;

  @override
  State<JuzDisplay> createState() => _JuzDisplayState();
}

class _JuzDisplayState extends State<JuzDisplay> {
  final List _juz = [
    {"id": 1, "start": 0, "end": 1},
    {"id": 2, "start": 1, "end": 1},
    {"id": 3, "start": 1, "end": 2},
    {"id": 4, "start": 2, "end": 3},
    {"id": 5, "start": 3, "end": 3},
    {"id": 6, "start": 3, "end": 4},
    {"id": 7, "start": 4, "end": 5},
    {"id": 8, "start": 5, "end": 6},
    {"id": 9, "start": 6, "end": 7},
    {"id": 10, "start": 7, "end": 8},
    {"id": 11, "start": 8, "end": 10},
    {"id": 12, "start": 10, "end": 11},
    {"id": 13, "start": 11, "end": 13},
    {"id": 14, "start": 14, "end": 15},
    {"id": 15, "start": 16, "end": 17},
    {"id": 16, "start": 17, "end": 19},
    {"id": 17, "start": 20, "end": 21},
    {"id": 18, "start": 22, "end": 24},
    {"id": 19, "start": 24, "end": 26},
    {"id": 20, "start": 26, "end": 28},
    {"id": 21, "start": 28, "end": 32},
    {"id": 22, "start": 32, "end": 35},
    {"id": 23, "start": 35, "end": 38},
    {"id": 24, "start": 38, "end": 40},
    {"id": 25, "start": 40, "end": 44},
    {"id": 26, "start": 45, "end": 50},
    {"id": 27, "start": 50, "end": 56},
    {"id": 28, "start": 57, "end": 65},
    {"id": 29, "start": 66, "end": 76},
    {"id": 30, "start": 77, "end": 113}
  ];

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    return kIsWeb
        ? MasonryGridView.count(
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
                  ));
            })
        : ListView.builder(
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
                  ));
            },
          );
  }
}
