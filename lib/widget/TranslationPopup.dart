import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:quranirab/theme/theme_provider.dart';


class TransPopup extends StatefulWidget {
  const TransPopup({Key? key}) : super(key: key);

  @override
  State<TransPopup> createState() => _TransPopupState();
}

class _TransPopupState extends State<TransPopup>{
  final padding = const EdgeInsets.symmetric(horizontal: 10);


  @override


  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return CustomPopupMenu(
      child: IconButton(
        icon: Image.asset("translation_icon.png"),
        onPressed: () => const TransPopup(),
        color: Theme.of(context).iconTheme.color,
        iconSize: 48,
        splashRadius: 30,
        tooltip: 'Translation  menu',
      ),
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
                              text: 'Translation',
                              enable: false,
                              darkMode: themeProvider.isDarkMode,
                              align: TextAlign.left,
                              onTap: (){}
                          ),
                          const Divider(
                              color: Color(0xFFC4C4C4)),
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
