import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../theme/theme_provider.dart';

class ContainerUpdate extends StatefulWidget {
  final String text;
  final TextEditingController controller;
  bool obsecure;

  ContainerUpdate({
    required this.text,
    required this.controller,
    required this.obsecure,
    Key? key,
  }) : super(key: key);

  @override
  State<ContainerUpdate> createState() => _ContainerUpdateState();
}

class _ContainerUpdateState extends State<ContainerUpdate> {
  get theColor => Colors.transparent;

  @override
  Widget build(BuildContext context) {
    var theme = Provider.of<ThemeProvider>(context);
    return Container(
        width: MediaQuery.of(context).size.width < 600
            ? MediaQuery.of(context).size.width * 0.9
            : 522,
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
              obscureText: widget.obsecure,
              obscuringCharacter: '*',
              controller: widget.controller,
              cursorColor: theme.isDarkMode ? Colors.white : Colors.black,
              decoration: InputDecoration(
                  suffixIcon: IconButton(
                    color: theme.isDarkMode ? Colors.white : Colors.black,
                    onPressed: () {
                      setState(() {});
                      widget.obsecure = !widget.obsecure;
                    },
                    icon: Icon(
                      !widget.obsecure
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                  ),
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
          ),
        ));
  }
}