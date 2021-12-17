import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quranirab/themes/theme_model.dart';
import 'package:quranirab/views/test.dart';
import 'nav.draw.dart';

class QuranHome extends StatefulWidget {
  const QuranHome({Key? key}) : super(key: key);

  @override
  _QuranHomeState createState() => _QuranHomeState();
}

class _QuranHomeState extends State<QuranHome> {
  final List<Map> surah = [
    {"name": "al-Fātihah", "pageGreen": 1, "end": 1},
    {"name": "al-Baqarah", "pageGreen": 2, "end": 49},
    {"name": "Āl-ʿImrān", "pageGreen": 50, "end": 76},
    {"name": "an-Nisāʾ", "pageGreen": 77, "end": 106},
    {"name": "al-Māʾidah", "pageGreen": 106, "end": 127},
    {"name": "al-Anʿām", "pageGreen": 128, "end": 150},
    {"name": "al-Aʿrāf", "pageGreen": 151, "end": 176},
    {"name": "al-Anfāl", "pageGreen": 177, "end": 186},
    {"name": "at-Taubah", "pageGreen": 187, "end": 207},
    {"name": "Yūnus", "pageGreen": 208, "end": 221},
    {"name": "Hūd", "pageGreen": 221, "end": 235},
    {"name": "Yūsuf", "pageGreen": 235, "end": 248},
    {"name": "ar-Raʿd", "pageGreen": 249, "end": 255},
    {"name": "Ibrāhīm", "pageGreen": 255, "end": 261},
    {"name": "al-Ḥijr", "pageGreen": 262, "end": 267},
    {"name": "an-Naḥl", "pageGreen": 267, "end": 281},
    {"name": "al-Isrāʾ", "pageGreen": 282, "end": 293},
    {"name": "al-Kahf", "pageGreen": 293, "end": 304},
    {"name": "Maryam", "pageGreen": 305, "end": 311},
    {"name": "Ṭā-Hā", "pageGreen": 312, "end": 321},
    {"name": "al-Anbiyāʾ", "pageGreen": 322, "end": 331},
    {"name": "al-Ḥajj", "pageGreen": 332, "end": 341},
    {"name": "al-Muʾminūn", "pageGreen": 342, "end": 350},
    {"name": "an-Nūr", "pageGreen": 350, "end": 359},
    {"name": "al-Furqān", "pageGreen": 359, "end": 366},
    {"name": "ash-Shuʿarā", "pageGreen": 367, "end": 376},
    {"name": "an-Naml", "pageGreen": 377, "end": 385},
    {"name": "al-Qaṣaṣ", "pageGreen": 385, "end": 396},
    {"name": "al-ʿAnkabūt", "pageGreen": 396, "end": 404},
    {"name": "ar-Rūm", "pageGreen": 404, "end": 410},
    {"name": "Luqmān", "pageGreen": 411, "end": 414},
    {"name": "as-Sajdah", "pageGreen": 415, "end": 417},
    {"name": "al-Aḥzāb", "pageGreen": 418, "end": 427},
    {"name": "Sabaʾ", "pageGreen": 428, "end": 434},

    {"name": "Fāṭir", "pageGreen": 434, "end": 440},
    {"name": "Yā-Sīn", "pageGreen": 440, "end": 445},
    {"name": "as-Ṣāffāt", "pageGreen": 446, "end": 452},
    {"name": "Ṣād", "pageGreen": 453, "end": 458},
    {"name": "az-Zumar", "pageGreen": 458, "end": 466},
    {"name": "Ghāfir", "pageGreen": 467, "end": 476},
    {"name": "Fuṣṣilat", "pageGreen": 477, "end": 482},
    {"name": "ash-Shūrā", "pageGreen": 483, "end": 489},
    {"name": "az-Zukhruf", "pageGreen": 489, "end": 495},
    {"name": "ad-Dukhān", "pageGreen": 496, "end": 498},
    {"name": "al-Jāthiyah", "pageGreen": 499, "end": 502},
    {"name": "al-Aḥqāf", "pageGreen": 502, "end": 506},
    {"name": "Muḥammad", "pageGreen": 507, "end": 510},
    {"name": "al-Fatḥ", "pageGreen": 511, "end": 515},
    {"name": "al-Ḥujurāt", "pageGreen": 515, "end": 517},
    {"name": "Qāf", "pageGreen": 518, "end": 520},
    {"name": "adh-Dhāriyāt", "pageGreen": 520, "end": 523},
    {"name": "at-Ṭūr", "pageGreen": 523, "end": 525},
    {"name": "an-Najm", "pageGreen": 526, "end": 528},
    {"name": "al-Qamar", "pageGreen": 528, "end": 531},
    {"name": "ar-Raḥmān", "pageGreen": 531, "end": 534},
    {"name": "al-Wāqiʿah", "pageGreen": 534, "end": 537},
    {"name": "al-Ḥadīd", "pageGreen": 537, "end": 541},
    {"name": "al-Mujādilah", "pageGreen": 542, "end": 544},
    {"name": "al-Ḥashr", "pageGreen": 545, "end": 548},
    {"name": "al-Mumtaḥanah", "pageGreen": 549, "end": 551},
    {"name": "as-Ṣaff", "pageGreen": 551, "end": 552},
    {"name": "al-Jumuʿah", "pageGreen": 553, "end": 554},
    {"name": "al-Munāfiqūn", "pageGreen": 554, "end": 555},
    {"name": "at-Taghābun", "pageGreen": 556, "end": 557},
    {"name": "at-Ṭalāq", "pageGreen": 558, "end": 559},
    {"name": "at-Taḥrīm", "pageGreen": 560, "end": 561},
    {"name": "al-Mulk", "pageGreen": 562, "end": 564},
    {"name": "al-Qalam", "pageGreen": 564, "end": 565},
    {"name": "al-Ḥāqqah", "pageGreen": 566, "end": 568},
    {"name": "al-Maʿārij", "pageGreen": 568, "end": 569},
    {"name": "Nūḥ", "pageGreen": 570, "end": 571},
    {"name": "al-Jinn", "pageGreen": 572, "end": 573},
    {"name": "al-Muzzammil", "pageGreen": 574, "end": 575},
    {"name": "al-Muddaththir", "pageGreen": 575, "end": 577},
    {"name": "al-Qiyāmah", "pageGreen": 577, "end": 578},
    {"name": "al-Insān", "pageGreen": 578, "end": 580},
    {"name": "al-Mursalāt", "pageGreen": 580, "end": 581},
    {"name": "an-Nabaʾ", "pageGreen": 582, "end": 583},
    {"name": "an-Nāziʿāt", "pageGreen": 583, "end": 584},
    {"name": "ʿAbasa", "pageGreen": 585, "end": 585},
    {"name": "at-Takwīr", "pageGreen": 586, "end": 586},
    {"name": "al-Infiṭār", "pageGreen": 587, "end": 587},
    {"name": "al-Muṭaffifīn", "pageGreen": 587, "end": 588},
    {"name": "al-Inshiqāq", "pageGreen": 589, "end": 589},
    {"name": "al-Burūj", "pageGreen": 590, "end": 590},
    {"name": "at-Ṭāriq", "pageGreen": 591, "end": 591},
    {"name": "al-Aʿlā", "pageGreen": 591, "end": 592},
    {"name": "al-Ghāshiyah", "pageGreen": 592, "end": 592},
    {"name": "al-Fajr", "pageGreen": 593, "end": 594},
    {"name": "al-Balad", "pageGreen": 594, "end": 594},
    {"name": "ash-Shams", "pageGreen": 595, "end": 595},
    {"name": "al-Layl", "pageGreen": 595, "end": 596},
    {"name": "ad-Ḍuḥā", "pageGreen": 596, "end": 596},
    {"name": "ash-Sharḥ", "pageGreen": 596, "end": 596},
    {"name": "at-Tīn", "pageGreen": 597, "end": 597},
    {"name": "al-ʿAlaq", "pageGreen": 597, "end": 597},
    {"name": "al-Qadr", "pageGreen": 598, "end": 598},
    {"name": "al-Bayyinah", "pageGreen": 598, "end": 599},
    {"name": "az-Zalzalah", "pageGreen": 599, "end": 600},
    {"name": "al-ʿĀdiyāt", "pageGreen": 599, "end": 600},
    {"name": "al-Qāriʿah", "pageGreen": 600, "end": 600},
    {"name": "at-Takāthur", "pageGreen": 600, "end": 600},
    {"name": "al-ʿAsr", "pageGreen": 601, "end": 601},
    {"name": "al-Humazah", "pageGreen": 601, "end": 601},
    {"name": "al-Fīl", "pageGreen": 601, "end": 601},
    {"name": "Quraysh", "pageGreen": 602, "end": 602},
    {"name": "al-Māʿūn", "pageGreen": 602, "end": 602},
    {"name": "al-Kawthar", "pageGreen": 602, "end": 603},
    {"name": "al-Kāfirūn", "pageGreen": 603, "end": 603},
    {"name": "an-Naṣr", "pageGreen": 603, "end": 603},
    {"name": "al-Masad", "pageGreen": 603, "end": 603},
    {"name": "al-Ikhlāṣ", "pageGreen": 604, "end": 604},
    {"name": "al-Falaq", "pageGreen": 604, "end": 604},
    {"name": "an-Nās", "pageGreen": 604, "end": 604}
  ].toList();

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeModel>(
        builder: (context, ThemeModel themeNotifier, child) {
      return Scaffold(
        drawer: navDrawer(),
        appBar: AppBar(
          backgroundColor: Colors.orange[700],
          elevation: 0,
          actions: [
            IconButton(
                icon: Icon(
                    themeNotifier.isDark
                        ? Icons.nightlight_round
                        : Icons.wb_sunny,
                    color: themeNotifier.isDark
                        ? Colors.white
                        : Colors.grey.shade900),
                onPressed: () {
                  themeNotifier.isDark
                      ? themeNotifier.isDark = false
                      : themeNotifier.isDark = true;
                })
          ],
        ),
        body: GridView.builder(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                childAspectRatio: 3 / 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20),
            itemCount: surah.length,
            itemBuilder: (BuildContext ctx, index) {
              return InkWell(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      'Surah ${surah[index]['name']}',textAlign: TextAlign.center,style: const TextStyle(fontSize: 20),
                    ),
                    decoration: BoxDecoration(
                        color: (themeNotifier.isDark)?Colors.cyan:Colors.amber,
                        borderRadius: BorderRadius.circular(15)),
                  ),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Test(surah[index]["pageGreen"],
                              surah[index]["name"],index+1,surah[index]["end"])));
                },
              );
            }),
      );
    });
  }
}

class Quran {
  final String name;
  final int page;

  Quran({required this.name, required this.page});

  factory Quran.fromJson(Map<String, dynamic> json) {
    return Quran(name: json["name"], page: json["pageGreen"]);
  }

  @override
  String toString() {
    return '$name' '$page';
  }
}
