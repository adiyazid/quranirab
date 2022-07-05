import 'package:flutter/material.dart';
import 'package:quranirab/theme/theme_provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ReceiptScreen extends StatefulWidget {
  const ReceiptScreen(this.url, {Key? key}) : super(key: key);

  final String url;

  @override
  State<ReceiptScreen> createState() => _ReceiptScreenState();
}

class _ReceiptScreenState extends State<ReceiptScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: QuranThemes.darkTheme.primaryColor,
        title: Text('Receipt detail'),
        actions: [],
      ),
      body: WebView(
        initialUrl: widget.url,
      ),
    );
  }
}
