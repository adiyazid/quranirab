import 'package:flutter/material.dart';
import 'package:quranirab/views/page1.dart';
import 'package:quranirab/views/homePage.dart';
import 'package:quranirab/views/login.dart';
import 'package:quranirab/views/quran.home.dart';
import 'package:quranirab/views/quran.words.dart';
import 'package:quranirab/views/surah/alfatihah.dart';

class navDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor:
            Colors.black38, //This will change the drawer background to blue.
        //other styles
      ),
      child: Drawer(
        child: ListView(
          children: <Widget>[
            const ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage('assets/quranirab.png'),
              ),
              title: Text(
                'Menu',
                style: TextStyle(color: Colors.white),
              ),
            ),
            ListTile(
                leading: const Icon(Icons.home, color: Colors.white),
                title: const Text(
                  'Home',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomePage()));
                }),
            ListTile(
                leading: const Icon(Icons.stay_primary_portrait,
                    color: Colors.white),
                title: const Text(
                  'Mobile app',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const QuranHome()));
                }),
            ListTile(
                leading: const Icon(
                  Icons.group,
                  color: Colors.white,
                ),
                title: const Text(
                  'Sign in',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                }),
            ListTile(
              leading: const Icon(
                Icons.device_hub,
                color: Colors.white,
              ),
              title: const Text(
                'Related sites',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () => {Navigator.of(context).pop()},
            ),
            ListTile(
              leading: const Icon(
                Icons.device_hub,
                color: Colors.white,
              ),
              title: const Text(
                'WordText',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Words()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
