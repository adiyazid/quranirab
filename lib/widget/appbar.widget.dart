import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quranirab/widget/LanguagePopup.dart';
import 'package:quranirab/widget/search.popup.dart';
import 'package:quranirab/widget/setting.popup.dart';

import '../provider/user.provider.dart';

class Appbar extends StatefulWidget {
  const Appbar({Key? key}) : super(key: key);

  @override
  _AppbarState createState() => _AppbarState();
}

class _AppbarState extends State<Appbar> {
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
          Consumer<AppUser>(builder: (context, user, child) {
            if (user.role == 'No Data') return Container();
            return Padding(
              padding: EdgeInsets.all(16.0),
              child: user.role! == 'user'
                  ? Chip(label: Text('Standard'))
                  : user.role! == 'premium-user'
                      ? Chip(
                          backgroundColor: Colors.teal, label: Text('Premium'))
                      : Container(),
            );
          }),
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
