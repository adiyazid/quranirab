import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quranirab/themes/theme_model.dart';
import 'package:quranirab/views/surah/alanam.dart';
import 'package:quranirab/views/surah/albaqarah.dart';
import 'package:quranirab/views/surah/alfatihah.dart';
import 'package:quranirab/views/surah/aliimran.dart';
import 'package:quranirab/views/surah/almaidah.dart';
import 'package:quranirab/views/surah/alquran.dart';
import 'package:quranirab/views/surah/annisa.dart';

import 'nav.draw.dart';

class QuranHome extends StatefulWidget {
  const QuranHome({Key? key}) : super(key: key);

  @override
  _QuranHomeState createState() => _QuranHomeState();
}

class _QuranHomeState extends State<QuranHome> {
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
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AlQuran()));
                  },
                  child: const Text('Full Al-Quran')),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Alfatihah()));
                  },
                  child: const Text('Al-Fatihah')),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AlBaqarah()));
                  },
                  child: const Text('Al-Baqarah')),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AliImran()));
                  },
                  child: const Text('Ali \'Imran')),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AnNisa()));
                  },
                  child: const Text('An-Nisa')),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AlMaidah()));
                  },
                  child: const Text('Al-Ma\'idah')),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AlAnAm()));
                  },
                  child: const Text('Al-An\'am')),
              Container(),
            ],
          ),
        ),
      );
    });
  }
}
