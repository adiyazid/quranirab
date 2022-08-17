import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:quranirab/widget/menu.dart';
import 'package:webview_flutter/webview_flutter.dart';


class Privacypolicy extends StatefulWidget {
  const Privacypolicy({Key? key}) : super(key: key);

  @override
  State<Privacypolicy> createState() => _PrivacypolicyState();
}

class _PrivacypolicyState extends State<Privacypolicy> {
  int diff = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Menu(),
      appBar: AppBar(),
      body:WebView (
             javascriptMode: JavascriptMode.unrestricted,
             initialUrl: 'https://www.freeprivacypolicy.com/live/8a9abf43-a7bd-4edb-8038-276754fc5d97',)
    );
  }
}