import 'package:flutter/material.dart';
import 'package:quranirab/provider/user.provider.dart';
import 'package:quranirab/widget/LanguagePopup.dart';
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
        children: [
          CircleAvatar(
            backgroundImage: AssetImage('assets/quranirab.png'),
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
              onPressed: () {}, icon: Icon(Icons.search, size: 26.0)),
        ),
        const Padding(
            padding: EdgeInsets.only(right: 20.0), child: LangPopup()),
        const Padding(
            padding: EdgeInsets.only(right: 20.0), child: SettingPopup()),
      ],
    );
  }

  Future<void> init() async {}
}
