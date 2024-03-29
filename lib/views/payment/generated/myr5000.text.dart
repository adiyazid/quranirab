import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import '../../../theme/theme_provider.dart';

/* Text MYR 50.00
    Autogenerated by FlutLab FTF Generator
  */
class MYR5000Text extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    return Text(
      '''MYR 50.00''',
      overflow: TextOverflow.visible,
      textAlign: TextAlign.left,
      style: TextStyle(
        height: 1,
        fontSize: 63.0,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w400,
        color: theme.isDarkMode?white:Color.fromARGB(255, 0, 0, 0),

        /* letterSpacing: 0.0, */
      ),
    );
  }
}
