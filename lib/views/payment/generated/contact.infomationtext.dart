import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import '../../../theme/theme_provider.dart';

/* Text Contact infomation
    Autogenerated by FlutLab FTF Generator
  */
class ContactInfomationText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    return Text(
      '''Contact information''',
      overflow: TextOverflow.visible,
      textAlign: TextAlign.left,
      style: TextStyle(
        height: 1.171875,
        fontSize: 24.0,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w400,
        color: theme.isDarkMode ? white : Color.fromARGB(255, 0, 0, 0),

        /* letterSpacing: 0.0, */
      ),
    );
  }
}
