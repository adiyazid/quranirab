import 'package:flutter/material.dart';
import 'package:quranirab/views/nav.draw.dart';
import 'package:provider/provider.dart';
import 'package:quranirab/themes/theme_model.dart';

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
              icon: Icon(themeNotifier.isDark
                ? Icons.nightlight_round
                : Icons.wb_sunny, color: themeNotifier.isDark ? Colors.white : Colors.grey.shade900),
              onPressed: () {
                themeNotifier.isDark
                  ? themeNotifier.isDark = false
                  : themeNotifier.isDark = true;
              }
            )
          ],
        ),
        body: Container(
          margin: EdgeInsets.all(170),
          decoration: BoxDecoration(
            color: Colors.orange[300],
            shape: BoxShape.circle,
          ),
        )
      );
    });
  }
}