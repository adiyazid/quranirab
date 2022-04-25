import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';

// import 'package:flutter_js/flutter_js.dart';
import 'package:flutter/material.dart';
import 'package:quranirab/views/nav.draw.dart';
import 'package:quranirab/widget/text.widget.dart';

import '../views/surah_model.dart';

class Surah extends StatefulWidget {
  const Surah({Key? key}) : super(key: key);

  @override
  _SurahState createState() => _SurahState();
}

class _SurahState extends State<Surah> {
  Color textColor = Colors.black;
  Color textColor1 = Colors.black;
  bool isHover = false;
  bool isExit = true;

  SurahModel? surahModel;

  void changeColor(PointerEvent details) {
    setState(() {
      isHover = true;
      isExit = false;
      textColor = Colors.blue;
    });
  }

  void changeColor1(PointerEvent details) {
    setState(() {
      isHover = true;
      isExit = false;
      textColor1 = Colors.red;
    });
  }

  void changeEx(PointerEvent details) {
    setState(() {
      textColor = Colors.black;
      textColor1 = Colors.black;
      isHover = false;
      isExit = true;
    });
  }

  String datas = '';

  fetchFileData() async {
    String responseText;
    responseText =
        await rootBundle.loadString('assets/data/tajweed_waw_android.txt');

    setState(() {
      datas = responseText;
    });
  }

  @override
  void initState() {
    fetchFileData();
    super.initState();
  }

  Future<SurahModel> readJsonData() async {
    String jsonData = await rootBundle.loadString("assets/data/page.json");
    jsonData = jsonData.replaceAll("&lt;br /&gt;", "");
    surahModel = SurahModel.fromJson(json.decode(jsonData));

    return surahModel!;
  }

  @override
  Widget build(BuildContext context) {
    final Color background = Colors.redAccent;
    final Color fill = Colors.blueAccent;
    const Color background2 = Color(0xff4dd865);
    final List<Color> gradient = [
      background,
      background,
      fill,
      fill,
    ];
    final List<Color> gradient2 = [
      background2,
      background2,
      fill,
      fill,
    ];
    // fills for container from left
    const double fillPercent = 88.23;
    const double fillPercent2 = 72.23;
    const double fillPercent3 = 81;
    const double fillPercent4 = 25;
    const double fillPercent5 = 42.5;
    const double fillPercent6 = 48.3;
    const double fillPercent7 = 50.4;

    const double fillStop = (100 - fillPercent) / 100;
    const double fillStop2 = (100 - fillPercent2) / 100;
    const double fillStop3 = (100 - fillPercent3) / 100;
    const double fillStop4 = (100 - fillPercent4) / 100;
    const double fillStop5 = (100 - fillPercent5) / 100;
    const double fillStop6 = (100 - fillPercent6) / 100;
    const double fillStop7 = (100 - fillPercent7) / 100;

    final List<double> stop1 = [0.0, fillStop, fillStop, 1.0];
    final List<double> stop2 = [0.0, fillStop2, fillStop2, 1.0];
    final List<double> stop3 = [0.0, fillStop3, fillStop3, 1.0];
    final List<double> stop4 = [0.0, fillStop4, fillStop4, 1.0];
    final List<double> stop5 = [0.0, fillStop5, fillStop5, 1.0];
    final List<double> stop6 = [0.0, fillStop6, fillStop6, 1.0];
    final List<double> stop7 = [0.0, fillStop7, fillStop7, 1.0];

    return Scaffold(
        drawer: navDrawer(),
        appBar: AppBar(
          backgroundColor: Colors.orange[700],
          elevation: 0,
          actions: [],
        ),
        body: SafeArea(
          child: Padding(
              padding: const EdgeInsets.all(50.0),
              child: FutureBuilder(
                future: readJsonData(),
                builder: (context, data) {
                  if (data.hasData) {
                    List<String>? surah = surahModel?.plist?.dictparent
                        ?.arrayparent?.dictchild?.ayahArray?[1].ayah;

                    ///1st verse
                    String? Ostart = surah![0].substring(0, 1);
                    String? Oend = surah[0].substring(1, 4);
                    String? Ostop = surah[0].substring(4);

                    ///verse two
                    String? Tstart = surah[1].substring(0, 1);
                    String? Tmid = surah[1].substring(1, 2);
                    String? Tend = surah[1].substring(2, 4);
                    String? Tstop = surah[1].substring(4);

                    ///verse three
                    String? THstart = surah[2].substring(0, 2);
                    String? THstop = surah[2].substring(2);

                    ///verse four
                    String? Fstart = surah[3].substring(0, 3);
                    String? Fstop = surah[3].substring(3);

                    ///verse five
                    String? FIstart = surah[4].substring(0, 1);
                    String? FImid1 = surah[4].substring(1, 2);
                    String? FImid2 = surah[4].substring(2, 3);
                    String? FIend = surah[4].substring(3, 4);
                    String? FIstop = surah[4].substring(4);

                    ///verse six
                    String? Sstart = surah[5].substring(0, 1);
                    String? Smid = surah[5].substring(1, 2);
                    String? Send = surah[5].substring(2, 3);
                    String? Sstop = surah[5].substring(3);

                    ///verse seven
                    String? SEstart = surah[6].substring(0, 2);
                    String? SEmid1 = surah[6].substring(2, 3);
                    String? SEmid2 = surah[6].substring(3, 4);
                    String? SEmid3 = surah[6].substring(4, 6);
                    String? SEmid4 = surah[6].substring(6, 7);
                    String? SEmid5 = surah[6].substring(7, 8);
                    String? SEend = surah[6].substring(8, 9);
                    String? SEstop = surah[6].substring(9);
//-------------------------------NEW FONT-------------------------------------//
                    ///verse one
                    String ba = datas.substring(0, 1);
                    String ayat1 = datas.substring(1, 36);
                    String end1 = datas.substring(36, 40);

                    ///verse two
                    String ayat2 = datas.substring(41, 51);
                    String lam = datas.substring(51, 53);
                    String mid2 = datas.substring(53, 78);
                    String end2 = datas.substring(78, 81);

                    //verse three
                    String ayat3 = datas.substring(81, 105);
                    String end3 = datas.substring(105, 109);

                    ///verse four
                    String ayat4 = datas.substring(111, 136);
                    String end4 = datas.substring(136, 140);

                    //verse five
                    String awal5 = datas.substring(141, 148);
                    String nakbud = datas.substring(148, 158);
                    String wa = datas.substring(158, 161);
                    String mid5 = datas.substring(161, 169);
                    String nastain = datas.substring(169, 180);
                    String end5 = datas.substring(180, 184);

                    //Verse six
                    String awal6 = datas.substring(184, 191);
                    String mid6 = datas.substring(191, 220);
                    String end6 = datas.substring(220, 224);

                    //verse seven
                    String awal7 = datas.substring(224, 242);
                    String anaam = datas.substring(242, 251);
                    String ta = datas.substring(251, 253);
                    String alai = datas.substring(253, 260);
                    String mid7 = datas.substring(260, 285);
                    String alai2 = datas.substring(285, 291);
                    String him = datas.substring(291, 295);
                    String wala = datas.substring(295, 302);
                    String dolin = datas.substring(302, 315);
                    String end7 = datas.substring(315, 319);

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                MeorText(
                                    text: Ostop,
                                    size: 54,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.grey.shade900,
                                    wordSpacing: 0),
                                MeorText(
                                    text: Oend,
                                    size: 54,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.blueAccent,
                                    wordSpacing: 0),
                                const SizedBox(
                                  width: 8,
                                ),
                                Container(
                                  width: 75,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: gradient,
                                      stops: stop1,
                                      end: Alignment.centerLeft,
                                      begin: Alignment.centerRight,
                                    ),
                                  ),
                                  child: CustomPaint(
                                    painter: CutOutTextPainter(
                                      text: Ostart,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                MeorText(
                                    text: Tstop,
                                    size: 54,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.grey.shade900,
                                    wordSpacing: 0),
                                MeorText(
                                    text: Tend,
                                    size: 54,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.blueAccent,
                                    wordSpacing: 0),
                                const SizedBox(
                                  width: 8,
                                ),
                                Container(
                                  width: 35,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: gradient,
                                      stops: stop2,
                                      end: Alignment.centerLeft,
                                      begin: Alignment.centerRight,
                                    ),
                                  ),
                                  child: CustomPaint(
                                    painter: CutOutTextPainter(
                                      text: Tmid,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                MeorText(
                                    text: Tstart,
                                    size: 54,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.blueAccent,
                                    wordSpacing: 0),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                MeorText(
                                    text: Fstop,
                                    size: 54,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.grey.shade900,
                                    wordSpacing: 0),
                                MeorText(
                                    text: Fstart,
                                    size: 54,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.blueAccent,
                                    wordSpacing: 0),
                                MeorText(
                                    text: THstop,
                                    size: 54,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.grey.shade900,
                                    wordSpacing: 0),
                                MeorText(
                                    text: THstart,
                                    size: 54,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.blueAccent,
                                    wordSpacing: 0),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                MeorText(
                                    text: FIstop,
                                    size: 54,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.grey.shade900,
                                    wordSpacing: 0),
                                MeorText(
                                    text: FIend,
                                    size: 54,
                                    fontWeight: FontWeight.normal,
                                    color: const Color(0xff4dd865),
                                    wordSpacing: 0),
                                Container(
                                  width: 82,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: gradient,
                                      stops: stop3,
                                      end: Alignment.centerLeft,
                                      begin: Alignment.centerRight,
                                    ),
                                  ),
                                  child: CustomPaint(
                                    painter: CutOutTextPainter(
                                      text: FImid2,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                MeorText(
                                    text: FImid1,
                                    size: 54,
                                    fontWeight: FontWeight.normal,
                                    color: const Color(0xff4dd865),
                                    wordSpacing: 0),
                                MeorText(
                                    text: FIstart,
                                    size: 54,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.blueAccent,
                                    wordSpacing: 0),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                MeorText(
                                    text: Sstop,
                                    size: 54,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.grey.shade900,
                                    wordSpacing: 0),
                                MeorText(
                                    text: Send,
                                    size: 54,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.blueAccent,
                                    wordSpacing: 0),
                                MeorText(
                                    text: Smid,
                                    size: 54,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.blueAccent,
                                    wordSpacing: 0),
                                Container(
                                  width: 80,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: gradient2,
                                      stops: stop4,
                                      end: Alignment.centerLeft,
                                      begin: Alignment.centerRight,
                                    ),
                                  ),
                                  child: CustomPaint(
                                    painter: CutOutTextPainter(
                                      text: Sstart,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                MeorText(
                                    text: SEstop,
                                    size: 54,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.grey.shade900,
                                    wordSpacing: 0),
                                MeorText(
                                    text: SEend,
                                    size: 54,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.blueAccent,
                                    wordSpacing: 0),
                                MeorText(
                                    text: SEmid5,
                                    size: 54,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.redAccent,
                                    wordSpacing: 0),
                                const SizedBox(width: 3),
                                Container(
                                  width: 77,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: gradient,
                                      stops: stop7,
                                      end: Alignment.centerLeft,
                                      begin: Alignment.centerRight,
                                    ),
                                  ),
                                  child: CustomPaint(
                                    painter: CutOutTextPainter(
                                      text: SEmid4,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 1),
                                MeorText(
                                    text: SEmid3,
                                    size: 54,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.blueAccent,
                                    wordSpacing: 0),
                                Container(
                                  width: 74,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: gradient,
                                      stops: stop6,
                                      end: Alignment.centerLeft,
                                      begin: Alignment.centerRight,
                                    ),
                                  ),
                                  child: CustomPaint(
                                    painter: CutOutTextPainter(
                                      text: SEmid2,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 83,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: gradient2,
                                      stops: stop5,
                                      end: Alignment.centerLeft,
                                      begin: Alignment.centerRight,
                                    ),
                                  ),
                                  child: CustomPaint(
                                    painter: CutOutTextPainter(
                                      text: SEmid1,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                MeorText(
                                    text: SEstart,
                                    size: 54,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.blueAccent,
                                    wordSpacing: 0),
                              ],
                            ),
                          ],
                        ),
                        const Spacer(),
                        Column(
                          children: [
                            RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                      text: ba,
                                      style: const TextStyle(
                                          fontFamily: 'MeQuran2',
                                          fontSize: 35,
                                          color: Colors.redAccent)),
                                  TextSpan(
                                      text: ayat1,
                                      style: const TextStyle(
                                          fontFamily: 'MeQuran2',
                                          fontSize: 35,
                                          color: Colors.blueAccent)),
                                  TextSpan(
                                      text: end1,
                                      style: TextStyle(
                                        fontFamily: 'MeQuran2',
                                        fontSize: 35,
                                        color: Colors.grey.shade900,
                                      )),
                                ],
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                      text: ayat2,
                                      style: const TextStyle(
                                          fontFamily: 'MeQuran2',
                                          fontSize: 35,
                                          color: Colors.blueAccent)),
                                  TextSpan(
                                      text: lam,
                                      style: const TextStyle(
                                          fontFamily: 'MeQuran2',
                                          fontSize: 35,
                                          color: Colors.redAccent)),
                                  TextSpan(
                                      text: mid2,
                                      style: const TextStyle(
                                          fontFamily: 'MeQuran2',
                                          fontSize: 35,
                                          color: Colors.blueAccent)),
                                  TextSpan(
                                      text: end2,
                                      style: TextStyle(
                                        fontFamily: 'MeQuran2',
                                        fontSize: 35,
                                        color: Colors.grey.shade900,
                                      )),
                                ],
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                      text: ayat3,
                                      style: const TextStyle(
                                          fontFamily: 'MeQuran2',
                                          fontSize: 35,
                                          color: Colors.blueAccent)),
                                  TextSpan(
                                      text: end3,
                                      style: TextStyle(
                                        fontFamily: 'MeQuran2',
                                        fontSize: 35,
                                        color: Colors.grey.shade900,
                                      )),
                                ],
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                      text: ayat4,
                                      style: const TextStyle(
                                          fontFamily: 'MeQuran2',
                                          fontSize: 35,
                                          color: Colors.blueAccent)),
                                  TextSpan(
                                      text: end4,
                                      style: TextStyle(
                                        fontFamily: 'MeQuran2',
                                        fontSize: 35,
                                        color: Colors.grey.shade900,
                                      )),
                                ],
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                      text: awal5,
                                      style: const TextStyle(
                                          fontFamily: 'MeQuran2',
                                          fontSize: 35,
                                          color: Colors.blueAccent)),
                                  TextSpan(
                                      text: nakbud,
                                      style: const TextStyle(
                                          fontFamily: 'MeQuran2',
                                          fontSize: 35,
                                          color: Colors.greenAccent)),
                                  TextSpan(
                                      text: wa,
                                      style: const TextStyle(
                                          fontFamily: 'MeQuran2',
                                          fontSize: 35,
                                          color: Colors.redAccent)),
                                  TextSpan(
                                      text: mid5,
                                      style: const TextStyle(
                                          fontFamily: 'MeQuran2',
                                          fontSize: 35,
                                          color: Colors.blueAccent)),
                                  TextSpan(
                                      text: nastain,
                                      style: const TextStyle(
                                          fontFamily: 'MeQuran2',
                                          fontSize: 35,
                                          color: Colors.greenAccent)),
                                  TextSpan(
                                      text: end5,
                                      style: TextStyle(
                                        fontFamily: 'MeQuran2',
                                        fontSize: 35,
                                        color: Colors.grey.shade900,
                                      )),
                                ],
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                      text: awal6,
                                      style: const TextStyle(
                                          fontFamily: 'MeQuran2',
                                          fontSize: 35,
                                          color: Colors.greenAccent)),
                                  TextSpan(
                                      text: mid6,
                                      style: const TextStyle(
                                          fontFamily: 'MeQuran2',
                                          fontSize: 35,
                                          color: Colors.blueAccent)),
                                  TextSpan(
                                      text: end6,
                                      style: TextStyle(
                                        fontFamily: 'MeQuran2',
                                        fontSize: 35,
                                        color: Colors.grey.shade900,
                                      )),
                                ],
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                      text: awal7,
                                      style: const TextStyle(
                                          fontFamily: 'MeQuran2',
                                          fontSize: 35,
                                          color: Colors.blue)),
                                  TextSpan(
                                      text: anaam,
                                      style: const TextStyle(
                                          fontFamily: 'MeQuran2',
                                          fontSize: 35,
                                          color: Colors.greenAccent)),
                                  TextSpan(
                                      text: ta,
                                      style: const TextStyle(
                                          fontFamily: 'MeQuran2',
                                          fontSize: 35,
                                          color: Colors.blueAccent)),
                                  TextSpan(
                                      text: alai,
                                      style: const TextStyle(
                                          fontFamily: 'MeQuran2',
                                          fontSize: 35,
                                          color: Colors.redAccent)),
                                  TextSpan(
                                      text: mid7,
                                      style: const TextStyle(
                                          fontFamily: 'MeQuran2',
                                          fontSize: 35,
                                          color: Colors.blueAccent)),
                                  TextSpan(
                                      text: alai2,
                                      style: const TextStyle(
                                          fontFamily: 'MeQuran2',
                                          fontSize: 35,
                                          color: Colors.redAccent)),
                                  TextSpan(
                                      text: him,
                                      style: const TextStyle(
                                          fontFamily: 'MeQuran2',
                                          fontSize: 35,
                                          color: Colors.blueAccent)),
                                  TextSpan(
                                      text: wala,
                                      style: const TextStyle(
                                          fontFamily: 'MeQuran2',
                                          fontSize: 35,
                                          color: Colors.redAccent)),
                                  TextSpan(
                                      text: dolin,
                                      style: const TextStyle(
                                          fontFamily: 'MeQuran2',
                                          fontSize: 35,
                                          color: Colors.blue)),
                                  TextSpan(
                                      text: end7,
                                      style: TextStyle(
                                        fontFamily: 'MeQuran2',
                                        fontSize: 35,
                                        color: Colors.grey.shade900,
                                      )),
                                ],
                              ),
                            ),
                          ],
                        ),
                        // String others = datas.substring(41);
                        // Text(
                        //   datas,
                        //   textAlign: TextAlign.center,
                        //   style: const TextStyle(
                        //     fontSize: 33,
                        //     fontFamily: 'MeQuran2',
                        //   ),
                        // ),
                      ],
                    );
                  } else {
                    return Container();
                  }
                },
              )),
        ));
  }
}

class CutOutTextPainter extends CustomPainter {
  final String text;
  final Color color;
  TextPainter? _textPainter;

  CutOutTextPainter({required this.text, required this.color}) {
    _textPainter = TextPainter(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: text,
        style: const TextStyle(
          fontFamily: 'MeQuran2',
          fontSize: 30.0,
        ),
      ),
      textDirection: TextDirection.rtl,
    );
    _textPainter!.layout();
  }

  @override
  void paint(Canvas canvas, Size size) {
    // Draw the text in the middle of the canvas
    final textOffset =
        size.center(Offset.zero) - _textPainter!.size.center(Offset.zero);
    final textRect = textOffset & _textPainter!.size;

    // The box surrounding the text should be 10 pixels larger, with 4 pixels corner radius
    final boxRect = RRect.fromRectAndRadius(
        textRect.inflate(1), const Radius.circular(0.0));
    final boxPaint = Paint()
      ..color = color
      ..blendMode = BlendMode.srcOut;

    canvas.saveLayer(boxRect.outerRect, Paint());

    _textPainter!.paint(canvas, textOffset);
    canvas.drawRRect(boxRect, boxPaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(CutOutTextPainter oldDelegate) {
    return text != oldDelegate.text;
  }
}
