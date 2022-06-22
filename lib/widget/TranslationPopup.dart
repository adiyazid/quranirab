import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:quranirab/provider/language.provider.dart';
import 'package:quranirab/theme/theme_provider.dart';

import '../models/translation.dart';

class TransPopup extends StatefulWidget {
  const TransPopup({Key? key}) : super(key: key);

  @override
  State<TransPopup> createState() => _TransPopupState();
}

class _TransPopupState extends State<TransPopup> {
  final padding = const EdgeInsets.symmetric(horizontal: 10);
  final FirebaseFirestore _fireStoreDataBase = FirebaseFirestore.instance;

  final _menu = CustomPopupMenuController();

  Stream<List<TranslationModel>> getUserList() {
    return _fireStoreDataBase.collection('translations').snapshots().map(
        (snapShot) => snapShot.docs
            .map((document) => TranslationModel.fromJson(document.data()))
            .toList());
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return CustomPopupMenu(
      controller: _menu,
      child: const ImageIcon(
        AssetImage("assets/translation_icon.png"),
        size: 50,
      ),
      pressType: PressType.singleClick,
      showArrow: false,
      verticalMargin: 0,
      horizontalMargin: 0,
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
                      child: ListView(
                        padding: padding,
                        children: <Widget>[
                          buildMenuItem(
                              text: AppLocalizations.of(context)!.translations,
                              enable: false,
                              darkMode: themeProvider.isDarkMode,
                              align: TextAlign.left,
                              onTap: () {}),
                          const Divider(
                            color: Color(0xFFC4C4C4),
                            thickness: 1.0,
                          ),
                          Center(
                            child: StreamBuilder(
                                stream: getUserList(),
                                builder: (context,
                                    AsyncSnapshot<List<TranslationModel>>
                                        asyncSnapshot) {
                                  if (asyncSnapshot.hasError) {
                                    return Text(
                                        'Error: ${asyncSnapshot.error}');
                                  }
                                  switch (asyncSnapshot.connectionState) {
                                    case ConnectionState.none:
                                      return Text('No data');
                                    case ConnectionState.waiting:
                                      return Text('Awaiting...');
                                    case ConnectionState.active:
                                      return SizedBox(
                                        height: 400,
                                        child: ListView.builder(
                                          itemCount: asyncSnapshot.data!.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return buildMenuItem(
                                                text: asyncSnapshot
                                                    .data![index].name,
                                                enable: true,
                                                darkMode:
                                                    themeProvider.isDarkMode,
                                                align: TextAlign.left,
                                                onTap: () {
                                                  _menu.hideMenu();
                                                  Provider.of<LangProvider>(
                                                          context,
                                                          listen: false)
                                                      .changeLang(
                                                    asyncSnapshot.data![index]
                                                        .language_id,
                                                  );
                                                });
                                          },
                                        ),
                                      );
                                    case ConnectionState.done:
                                      return SizedBox(
                                        height: 400,
                                        child: ListView.builder(
                                          itemCount: asyncSnapshot.data!.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return buildMenuItem(
                                                text: asyncSnapshot
                                                    .data![index].name,
                                                enable:
                                                    Provider.of<LangProvider>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .langId ==
                                                            asyncSnapshot
                                                                .data![index]
                                                                .language_id
                                                        ? false
                                                        : true,
                                                darkMode: themeProvider
                                                    .isDarkMode,
                                                align: TextAlign.left,
                                                onTap:
                                                    Provider.of<LangProvider>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .langId ==
                                                            asyncSnapshot
                                                                .data![index]
                                                                .language_id
                                                        ? null
                                                        : () {
                                                            _menu.hideMenu();
                                                            Provider.of<LangProvider>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .changeLang(
                                                              asyncSnapshot
                                                                  .data![index]
                                                                  .language_id,
                                                            );
                                                          });
                                          },
                                        ),
                                      );
                                  }
                                }),
                          ),
                        ],
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
