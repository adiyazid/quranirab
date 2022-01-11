import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quranirab/theme/theme_provider.dart';
import 'responsive.dart';

class CenterTabBar extends StatefulWidget {
  const CenterTabBar({
    Key? key,
  }) : super(key: key);

  @override
  State<CenterTabBar> createState() => _CenterTabBarState();
}

class _CenterTabBarState extends State<CenterTabBar> {
  bool isRead = true;
  bool isTranslate = false;

  Color? _check() {
    if (isRead) {
      return const Color(0xffE0BD61);
    } else {
      return const Color(0xffFFF3CA);
    }
  }

  Color? _checkDark() {
    if (isRead) {
      return const Color(0xff808ba1);
    } else {
      return const Color(0xff67748E);
    }
  }
  Color? _check1() {
    if (isTranslate) {
      return const Color(0xffE0BD61);
    } else {
      return  const Color(0xffFFF3CA);
    }
  }

  Color? _checkDark1() {
    if (isTranslate) {
      return const Color(0xff808ba1);
    } else {
      return const Color(0xff67748E);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final bool isDesktop = Responsive.isDesktop(context);
    return Card(
      margin: EdgeInsets.symmetric(horizontal: isDesktop ? 100.0 : 0.0),
      elevation: isDesktop ? 1.0 : 0.0,
      shape: isDesktop
          ? RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0))
          : null,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: (themeProvider.isDarkMode)
                ? const Color(0xff67748E)
                : const Color(0xffFFF3CA)),
        child: Column(
          children: [
            SizedBox(
              width: isDesktop ? 352 : 220,
              height: 40.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    style: ElevatedButton.styleFrom(
                        fixedSize: isDesktop
                            ? const Size.fromWidth(150)
                            : const Size.fromWidth(102),
                        primary: (themeProvider.isDarkMode)
                            ? _checkDark1()
                            : _check1()),
                    onPressed: () => setState(() {
                      isRead = false;
                      isTranslate = true;
                    }),
                    child: Text(
                      'Translation',
                      style: TextStyle(
                        fontSize: isDesktop ? 18 : 14,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                    ),
                  ),
                  TextButton(
                    style: ElevatedButton.styleFrom(
                        fixedSize: isDesktop
                            ? const Size.fromWidth(150)
                            : const Size.fromWidth(102),
                        primary: (themeProvider.isDarkMode)
                            ? _checkDark()
                            : _check()),
                    onPressed: () => setState(() {
                      isRead = true;
                      isTranslate = false;
                    }),
                    child: Text(
                      'Reading',
                      style: TextStyle(
                        fontSize: isDesktop ? 18 : 14,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
