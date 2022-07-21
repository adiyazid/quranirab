import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import '../../../theme/theme_provider.dart';

/* Text 1234 1234 1234 1234
    Autogenerated by FlutLab FTF Generator
  */
class HintTextCardNumber extends StatelessWidget {
  final _numbercard = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    return Scaffold(
      body: Center(
        child: TextField(
            controller: _numbercard,
            decoration: InputDecoration(
                border: InputBorder.none,
                filled: true,
                fillColor: theme.isDarkMode ? Color(0xff67748E) : Colors.white,
                labelText: ('Card Number'),
                labelStyle:
                    TextStyle(color: theme.isDarkMode ? white : Colors.black)),
            style: TextStyle(color: theme.isDarkMode ? white : Colors.black)),
      ),
    );
  }
}
