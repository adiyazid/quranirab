import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quranirab/views/payment/payment.screen.dart';
import 'package:quranirab/widget/LanguagePopup.dart';
import 'package:quranirab/widget/search.popup.dart';
import 'package:quranirab/widget/setting.popup.dart';
import 'package:url_launcher/url_launcher.dart';

import '../provider/user.provider.dart';
import '../theme/theme_provider.dart';
import '../views/payment/receipt.screen.dart';

class Appbar extends StatefulWidget {
  const Appbar({Key? key}) : super(key: key);

  @override
  _AppbarState createState() => _AppbarState();
}

class _AppbarState extends State<Appbar> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    return SliverAppBar(
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(5),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                  width: 2.0,
                  color: themeProvider.isDarkMode
                      ? Colors.white
                      : const Color(0xffE86F00)),
            ),
          ),
        ),
      ),
      iconTheme: Theme.of(context).iconTheme,
      title: Row(
        children: [
          CircleAvatar(
            backgroundImage: AssetImage('assets/quranirab.png'),
            radius: 18.0,
          ),
          Consumer<AppUser>(builder: (context, user, child) {
            if (user.role == 'No Data') return Container();
            return InkWell(
              onTap: () async {
                try {
                  var data = await FirebaseFirestore.instance
                      .collection('quranIrabUsers')
                      .doc(AppUser().user!.uid)
                      .get()
                      .then((value) => value['receipt-url']);
                  if (!kIsWeb) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ReceiptScreen(data)));
                  } else {
                    launchUrl(Uri.parse(data));
                  }
                } catch (e) {
                  print(e);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => PaymentScreen()));
                }
              },
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: user.role == 'user'
                    ? Chip(
                        backgroundColor: Colors.amber,
                        label: Text(
                          'Standard',
                          style: TextStyle(color: Colors.black),
                        ))
                    : user.role == 'premium-user'
                        ? Chip(
                            backgroundColor: Colors.teal,
                            label: Text(
                              'Premium',
                              style: TextStyle(color: Colors.white),
                            ))
                        : user.role == 'tester'
                            ? Chip(
                                backgroundColor: Colors.amber,
                                label: Text(
                                  'Tester',
                                  style: TextStyle(color: Colors.black),
                                ))
                            : Container(),
              ),
            );
          }),
        ],
      ),
      elevation: 0,
      centerTitle: false,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      actions: <Widget>[
        SizedBox(width: 16),
        Consumer<AppUser>(builder: (context, user, child) {
          if (user.role != 'user') {
            return SearchPopup();
          } else {
            return Container();
          }
        }),
        SizedBox(width: 16),
        LangPopup(),
        SizedBox(width: 16),
        SettingPopup(),
        SizedBox(width: 16),
      ],
    );
  }
}
