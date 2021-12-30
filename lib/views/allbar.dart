import 'package:flutter/material.dart';
import 'package:quranirab/widget/menu.dart';
import 'package:quranirab/widget/setting.dart';
import '../widget/language.dart';

class AllBar extends StatefulWidget {
  const AllBar({Key? key}) : super(key: key);

  @override
  State<AllBar> createState() => _AllBarState();
}

class _AllBarState extends State<AllBar> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: Menu(),
      endDrawer: const Setting(),
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme,
        title: Row(
          children: const [
            CircleAvatar(
              backgroundImage: AssetImage('assets/logo.png'),
              radius: 18.0,
            ),
          ],
        ),
        elevation: 0,
        centerTitle: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.search,
                  size: 26.0,
                )),
          ),
          Padding(
              padding: const EdgeInsets.only(right: 20.0), child: Language()),
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(
                Icons.settings,
              ),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            ),
          ),
        ],
      ),
    );
  }
}
