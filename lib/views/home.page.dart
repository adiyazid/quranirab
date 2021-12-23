import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quranirab/views/nav.draw.dart';
import 'package:provider/provider.dart';
import 'package:quranirab/themes/theme_model.dart';

import 'data.from.firestore.dart';
import 'mushaf.page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(28.0),
                child: Container(
                  width: 500,
                  margin: const EdgeInsets.all(30.0),
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.orange),
                  ),
                  //             <--- BoxDecoration here
                  child: GestureDetector(
                    child: ListTile(
                      leading: Container(
                          decoration: BoxDecoration(
                              color: Colors.orange[700],
                              borderRadius: BorderRadius.circular(5)),
                          width: 25,
                          height: 25,
                          child: const Text(
                            '1',
                            textAlign: TextAlign.center,
                          )),
                      title: const Text('Al-fatihah'),
                      subtitle: const Text('The Opener'),
                      trailing: const Text('الفاتحة'),
                    ),
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MushafPage())),
                  ),
                ),
              ),
              ElevatedButton(
                  onPressed: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const DataFromFirestore()));
                  },
                  child: const Text('Data from firestore'))
            ],
          ));
    });
  }
}
