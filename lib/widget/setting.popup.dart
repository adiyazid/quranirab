import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:quranirab/provider/ayah.number.provider.dart';
import 'package:quranirab/theme/theme_provider.dart';

class SettingPopup extends StatefulWidget {
  const SettingPopup({Key? key}) : super(key: key);

  @override
  State<SettingPopup> createState() => _SettingPopupState();
}

class _SettingPopupState extends State<SettingPopup>
    with TickerProviderStateMixin {
  final padding = const EdgeInsets.symmetric(horizontal: 10);

  int no = 0;

  var visible = true;

  final _custom = CustomPopupMenuController();

  bool get indexIsChanging => _indexIsChangingCount != 0;

  final int _indexIsChangingCount = 0;

  late int index = 0;

  List<bool> isSelected = [true, false, true];

  late TabController _controller;

  List<Widget> list = [
    const Tab(
        child: Text(
          'Auto',textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12),
        ),
        icon: Icon(Icons.brightness_auto)),
    const Tab(
        child: Text(
          'Light Mode',textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12),
        ),
        icon: Icon(Icons.light_mode)),
    const Tab(
        child: Text(
          'Dark Mode',textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12),
        ),
        icon: Icon(Icons.dark_mode)),
  ];

  ThemeMode themeMode = ThemeMode.system;

  bool get isDarkMode {
    if (themeMode == ThemeMode.system) {
      final brightness = SchedulerBinding.instance!.window.platformBrightness;
      return brightness == Brightness.dark;
    } else {
      return themeMode == ThemeMode.dark;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = TabController(length: list.length, vsync: this);
    // Create TabController for getting the index of current tab
    _controller.addListener(() {
      setState(() {});
      if (_controller.indexIsChanging) {
        print(_controller.index);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final font = Provider.of<AyaProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final brightness = SchedulerBinding.instance!.window.platformBrightness;
    return StatefulBuilder(builder: (context, setState) {
      return CustomPopupMenu(
        controller: _custom,
        child: const Icon(Icons.settings),
        pressType: PressType.singleClick,
        showArrow: false,
        horizontalMargin: 10,
        menuBuilder: () {
          return StatefulBuilder(builder: (context, setState) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Container(
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
                    width: 516,
                    height: 433,
                    child: Stack(children: <Widget>[
                      ListView(
                        padding: padding,
                        children: <Widget>[
                          const SizedBox(height: 10),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              children: <Widget>[
                                Text(
                                  'Setting',
                                  style: TextStyle(
                                      color:
                                          Theme.of(context).textSelectionColor,
                                      fontSize: 16),
                                ),
                                Spacer(),
                                IconButton(
                                  onPressed: () async {
                                    _custom.hideMenu();
                                  },
                                  icon: const Icon(Icons.close),
                                  color: Theme.of(context).textSelectionColor,
                                  iconSize: 20,
                                  splashRadius: 15,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 5),
                          Center(
                            child: Container(
                              width: 500,
                              height: 150,
                              margin: const EdgeInsets.all(10),
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(10.0),
                                      bottomRight: Radius.circular(10.0),
                                      topLeft: Radius.circular(10.0),
                                      bottomLeft: Radius.circular(10.0)),
                                  color: Theme.of(context).focusColor,
                                  border: Border.all(
                                    color: Theme.of(context).dividerColor,
                                    width: 1,
                                  )),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Text('Theme',
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .textSelectionColor,
                                            fontSize: 16,
                                          )),
                                    ),
                                    TabBar(
                                      indicatorColor:
                                          Theme.of(context).iconTheme.color,
                                      onTap: (index) async {
                                        if (_controller.index == 1) {
                                          themeProvider.toggleTheme(false);
                                        } else if (_controller.index == 2) {
                                          themeProvider.toggleTheme(true);
                                        } else {
                                          if (brightness.toString() ==
                                                  "Brightness.light" &&
                                              themeProvider.isDarkMode ==
                                                  true) {
                                            themeProvider.toggleTheme(false);
                                          }
                                          if (brightness.toString() ==
                                              "Brightness.dark") {
                                            themeProvider.toggleTheme(true);
                                          }
                                        }
                                      },
                                      controller: _controller,
                                      tabs: list,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: 500,
                            height: 130,
                            margin: const EdgeInsets.all(10),
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(10.0),
                                    bottomRight: Radius.circular(10.0),
                                    topLeft: Radius.circular(10.0),
                                    bottomLeft: Radius.circular(10.0)),
                                color: Theme.of(context).focusColor,
                                border: Border.all(
                                  color: Theme.of(context).dividerColor,
                                  width: 1,
                                )),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Text('Font Size',
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .textSelectionColor,
                                            fontSize: 16)),
                                  ),
                                  Center(
                                    child: ToggleButtons(
                                      children: [
                                        const Icon(Icons.exposure_minus_1,
                                            size: 20),
                                        Center(
                                            child: Text(
                                          '${font.value}',
                                          style: const TextStyle(fontSize: 30),
                                        )),
                                        const Icon(Icons.plus_one, size: 20),
                                      ],
                                      splashColor: Colors.grey.withAlpha(66),
                                      borderRadius: BorderRadius.circular(10),
                                      isSelected: isSelected,
                                      onPressed: (int newIndex) {
                                        if (newIndex == 0) {
                                          setState(() {
                                            if (font.value != 0 &&
                                                font.value > 10) {
                                              Provider.of<AyaProvider>(context,
                                                      listen: false)
                                                  .decrement();
                                            }
                                            no--;
                                          });
                                        } else if (newIndex == 2) {
                                          setState(() {
                                            Provider.of<AyaProvider>(context,
                                                    listen: false)
                                                .increment();

                                            no++;
                                          });
                                        }
                                      },
                                      fillColor: Colors.white60,
                                      color: Colors.black,
                                      selectedColor: Colors.black,
                                      renderBorder: false,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ])),
              ),
            );
          });
        },
      );
    });
  }
}

Widget buildMenuItem({
  required String text,
  required IconData icon,
}) {
  const color = Colors.black;

  return ListTile(
    leading: Icon(icon, color: color),
    title: Text(text, style: const TextStyle(color: color)),
    onTap: () {},
  );
}

void SelectedItem(BuildContext context, int index) {
  Navigator.of(context).pop();
}

class CurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    int curveHeight = 40;
    Offset controlPoint = Offset(size.width / 2, size.height + curveHeight);
    Offset endPoint = Offset(size.width, size.height - curveHeight);

    Path path = Path()
      ..lineTo(0, size.height - curveHeight)
      ..quadraticBezierTo(
          controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy)
      ..lineTo(size.width, 0)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
