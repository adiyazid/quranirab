import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:quranirab/theme/theme_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Setting extends StatefulWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> with SingleTickerProviderStateMixin {
  final padding = const EdgeInsets.symmetric(horizontal: 10);
  int no = 0;

  bool get indexIsChanging => _indexIsChangingCount != 0;
  final int _indexIsChangingCount = 0;
  late int index = 0;
  List<bool> isSelected = [true, false, true];

  late TabController _controller;
  int _selectedIndex = 1;

  List<Widget> list = [
    const Tab(
        child: Text(
          'Auto',
          style: TextStyle(fontSize: 12),
        ),
        icon: Icon(Icons.brightness_auto)),
    const Tab(
        child: Text(
          'Light Mode',
          style: TextStyle(fontSize: 12),
        ),
        icon: Icon(Icons.light_mode)),
    const Tab(
        child: Text(
          'Dark Mode',
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
    getIndex();
    _controller =
        TabController(length: list.length, vsync: this, initialIndex: index);
    // Create TabController for getting the index of current tab
    _controller.addListener(() {
      setState(() {
        _selectedIndex = _controller.index;
      });
      if (_controller.indexIsChanging) {
        print(_controller.index);
      }
    });
  }

  Future<void> getIndex() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      index = prefs.getInt('index') ?? 0;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final brightness = SchedulerBinding.instance!.window.platformBrightness;
    return Drawer(
      child: Material(
        color: Theme.of(context).primaryColor,
        child: ListView(
          padding: padding,
          children: <Widget>[
            const SizedBox(height: 10),
            Stack(
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.fromLTRB(10, 16, 0, 15),
                  child: Text(
                    'Settings',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(255, 0, 0, 0),
                  child: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.close),
                    color: Colors.black,
                    iconSize: 20,
                    splashRadius: 15,
                  ),
                ),
              ],
            ),
            Divider(color: Colors.grey[300]),
            const SizedBox(height: 5),
            const Padding(
              padding: EdgeInsets.fromLTRB(10, 16, 0, 15),
              child: Text('Theme',
                  style: TextStyle(
                    color: Colors.black,
                  )),
            ),
            const SizedBox(height: 3),
            TabBar(
              onTap: (index) async {
                if (_controller.index == 1) {
                  themeProvider.toggleTheme(false);
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();

                  await prefs.setInt('index', _selectedIndex);
                } else if (_controller.index == 2) {
                  themeProvider.toggleTheme(true);
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();

                  await prefs.setInt('index', _selectedIndex);
                } else {
                  if (brightness.toString() == "Brightness.light" &&
                      themeProvider.isDarkMode == true) {
                    themeProvider.toggleTheme(false);
                  }
                  if (brightness.toString() == "Brightness.dark") {
                    themeProvider.toggleTheme(true);
                  }
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();

                  await prefs.setInt('index', _selectedIndex);
                }
              },
              controller: _controller,
              tabs: list,
            ),
            const SizedBox(height: 30),
            const Padding(
              padding: EdgeInsets.fromLTRB(10, 16, 0, 15),
              child: Text('Font Size',
                  style: TextStyle(
                    color: Colors.black,
                  )),
            ),
            const SizedBox(height: 15),
            Center(
              child: ToggleButtons(
                children: [
                  const Icon(Icons.exposure_minus_1, size: 20),
                  Center(
                      child: Text(
                    '$no',
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
                      no--;
                    });
                  } else if (newIndex == 2) {
                    setState(() {
                      no++;
                    });
                  }
                },
                fillColor: Colors.white60,
                color: Colors.black,
                selectedColor: Colors.black,
                renderBorder: false,
              ),
            )
          ],
        ),
      ),
    );
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

  void selectedItem(BuildContext context, int index) {
    Navigator.of(context).pop();
  }
}
