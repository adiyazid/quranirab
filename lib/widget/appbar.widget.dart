import 'package:flutter/material.dart';
import 'package:quranirab/widget/LanguagePopup.dart';
import 'package:quranirab/widget/search.popup.dart';
import 'package:quranirab/widget/setting.popup.dart';

class Appbar extends StatefulWidget {
  const Appbar({Key? key}) : super(key: key);

  @override
  _AppbarState createState() => _AppbarState();
}

class _AppbarState extends State<Appbar> {
  String? role;

  @override
  void initState() {
    // TODO: implement initState
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      iconTheme: Theme.of(context).iconTheme,
      title: Row(
        children: const [
          CircleAvatar(
            backgroundImage: AssetImage('assets/quranirab.png'),
            radius: 18.0,
          ),
        ],
      ),
      elevation: 0,
      centerTitle: false,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      actions: const <Widget>[
        SizedBox(width: 16),
        SearchPopup(),
        SizedBox(width: 16),
        LangPopup(),
        SizedBox(width: 16),
        SettingPopup(),
        SizedBox(width: 16),
      ],
    );
  }

  Future<void> init() async {}
}
