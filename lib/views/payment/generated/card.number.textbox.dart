import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../theme/theme_provider.dart';

/* Rectangle Rectangle 55
    Autogenerated by FlutLab FTF Generator
  */
class CardNumberTextBox extends StatelessWidget {
  const CardNumberTextBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    return Container(
      width: 647.0,
      height: 64.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(
          width: 1.0,
          color: theme.isDarkMode
              ? Color(0xff808BA1)
              : Color.fromARGB(255, 255, 181, 94),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: Container(
          color: theme.isDarkMode
              ? Color(0xff67748E)
              : Color.fromARGB(255, 255, 255, 255),
        ),
      ),
    );
  }
}
