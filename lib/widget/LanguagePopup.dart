import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:quranirab/theme/theme_provider.dart';


class LangPopup extends StatefulWidget {
  const LangPopup({Key? key}) : super(key: key);

  @override
  State<LangPopup> createState() => _LangPopupState();
}

class _LangPopupState extends State<LangPopup>{
  final padding = const EdgeInsets.symmetric(horizontal: 10);


  @override


  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return CustomPopupMenu(
      child: const Icon(Icons.language),

      pressType: PressType.singleClick,
      showArrow: false,
      verticalMargin: 1,
      horizontalMargin: 50,
      menuBuilder: () {
        return ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: IntrinsicWidth(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: themeProvider.isDarkMode?const Color(0xFF67748E):const Color(0xFFFFC692),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(12.0),
                      ),
                      border: Border.all(
                        color: Theme.of(context).dividerColor,
                        width: 1,
                      )),
                  child: SizedBox(
                      width: 365,
                      height: 120,

                      child: ListView(
                        padding: padding,
                        children: <Widget>[
                          buildMenuItem(
                              text: 'Language',
                              enable: false,
                              darkMode: themeProvider.isDarkMode,
                              align: TextAlign.left,
                              onTap: (){}
                          ),
                           const Divider(
                              color: Color(0xFFC4C4C4),thickness: 1,),
                          buildMenuItem(
                              text: 'English',
                              enable: true,
                              darkMode: themeProvider.isDarkMode,
                              align: TextAlign.center,
                              onTap: (){}
                          ),
                        ],
                      )
                  ),
                ),
              ],
            ),
          ),
        );},

    );

  }
}

Widget buildMenuItem({
  required String text,
  required bool enable,
  required var onTap,
  required bool darkMode,
  required var align,
}) {

  return ListTile(
    title: Text(text, textAlign: align, style: TextStyle(color: (darkMode)? Colors.white : Colors.black)),
    enabled: enable,
    onTap: () {},
  );
}
