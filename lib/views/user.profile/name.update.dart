import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../theme/theme_provider.dart';

class NameUpdate extends StatefulWidget {
  final String text;
  final TextEditingController controller;

  const NameUpdate({
    required this.text,
    required this.controller,
    Key? key,
  }) : super(key: key);

  @override
  State<NameUpdate> createState() => _NameUpdateState();
}

class _NameUpdateState extends State<NameUpdate> {
  get theColor => Colors.transparent;

  @override
  Widget build(BuildContext context) {
    var theme = Provider.of<ThemeProvider>(context);
    return Container(
        width: MediaQuery.of(context).size.width < 600
            ? MediaQuery.of(context).size.width * 0.4
            : 250,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
          color: theme.isDarkMode
              ? Color(0xff808BA1)
              : Color.fromRGBO(255, 255, 255, 1),
          border: Border.all(
            color: theme.isDarkMode
                ? Color(0xff67748E)
                : Color.fromRGBO(255, 181, 94, 1),
            width: 1,
          ),
        ),
        child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: widget.controller,
                cursorColor: theme.isDarkMode ? Colors.white : Colors.black,
                decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: theColor),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: theColor),
                    ),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: theColor),
                    ),
                    hintText: widget.text,
                    hintStyle: TextStyle(
                        color: theme.isDarkMode
                            ? Colors.white
                            : const Color.fromRGBO(151, 151, 151, 1),
                        fontFamily: 'Poppins',
                        fontSize: 20,
                        letterSpacing:
                        0 /*percentages not used in flutter. defaulting to zero*/,
                        fontWeight: FontWeight.normal,
                        height: 1)),
              ),
            )));
  }
}