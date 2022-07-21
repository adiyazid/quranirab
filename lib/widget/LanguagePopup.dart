import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:quranirab/theme/theme_provider.dart';

import '../main.dart';

class LangPopup extends StatefulWidget {
  const LangPopup({Key? key}) : super(key: key);

  @override
  State<LangPopup> createState() => _LangPopupState();
}

class _LangPopupState extends State<LangPopup> {
  final padding = const EdgeInsets.symmetric(horizontal: 10);

  final _menu = CustomPopupMenuController();

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return CustomPopupMenu(
      controller: _menu,
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
                      color: themeProvider.isDarkMode
                          ? const Color(0xFF67748E)
                          : const Color(0xFFFFC692),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(12.0),
                      ),
                      border: Border.all(
                        color: Theme.of(context).dividerColor,
                        width: 1,
                      )),
                  child: SizedBox(
                      width: 365,
                      height: 500,
                      child: Center(
                        child: ListView(
                          padding: padding,
                          children: <Widget>[
                            buildMenuItem(
                                text: AppLocalizations.of(context)!.language,
                                enable: false,
                                darkMode: themeProvider.isDarkMode,
                                align: TextAlign.left,
                                onTap: () {}),
                            const Divider(
                              color: Color(0xFFC4C4C4),
                              thickness: 1,
                            ),
                            buildMenuItem(
                                text: 'English',
                                enable: true,
                                darkMode: themeProvider.isDarkMode,
                                align: TextAlign.center,
                                onTap: () {
                                  _menu.hideMenu();
                                  MyApp.of(context)!.setLocale(
                                      Locale.fromSubtags(languageCode: 'en'));
                                }),
                            buildMenuItem(
                                text: 'Bahasa Melayu',
                                enable: true,
                                darkMode: themeProvider.isDarkMode,
                                align: TextAlign.center,
                                onTap: () {
                                  _menu.hideMenu();
                                  MyApp.of(context)!.setLocale(
                                      Locale.fromSubtags(languageCode: 'ms'));
                                }),
                            buildMenuItem(
                                text: 'Arabic',
                                enable: true,
                                darkMode: themeProvider.isDarkMode,
                                align: TextAlign.center,
                                onTap: () {
                                  _menu.hideMenu();
                                  MyApp.of(context)!.setLocale(
                                      Locale.fromSubtags(languageCode: 'ar'));
                                }),
                            buildMenuItem(
                                text: 'Chinese',
                                enable: true,
                                darkMode: themeProvider.isDarkMode,
                                align: TextAlign.center,
                                onTap: () {
                                  _menu.hideMenu();
                                  MyApp.of(context)!.setLocale(
                                      Locale.fromSubtags(languageCode: 'zh'));
                                }),
                            buildMenuItem(
                                text: 'French',
                                enable: true,
                                darkMode: themeProvider.isDarkMode,
                                align: TextAlign.center,
                                onTap: () {
                                  _menu.hideMenu();
                                  MyApp.of(context)!.setLocale(
                                      Locale.fromSubtags(languageCode: 'fr'));
                                }),
                            buildMenuItem(
                                text: 'Spanish',
                                enable: true,
                                darkMode: themeProvider.isDarkMode,
                                align: TextAlign.center,
                                onTap: () {
                                  _menu.hideMenu();
                                  MyApp.of(context)!.setLocale(
                                      Locale.fromSubtags(languageCode: 'es'));
                                }),
                            buildMenuItem(
                                text: 'Bengali',
                                enable: true,
                                darkMode: themeProvider.isDarkMode,
                                align: TextAlign.center,
                                onTap: () {
                                  _menu.hideMenu();
                                  MyApp.of(context)!.setLocale(
                                      Locale.fromSubtags(languageCode: 'ne'));
                                }),
                          ],
                        ),
                      )),
                ),
              ],
            ),
          ),
        );
      },
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
    title: Text(text,
        textAlign: align,
        style: TextStyle(color: (darkMode) ? Colors.white : Colors.black)),
    enabled: enable,
    onTap: onTap,
  );
}
