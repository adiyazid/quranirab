import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quranirab/theme/theme_provider.dart';

class SearchPopup extends StatefulWidget {
  const SearchPopup({Key? key}) : super(key: key);

  @override
  State<SearchPopup> createState() => _SearchPopupState();
}

class _SearchPopupState extends State<SearchPopup>
    with TickerProviderStateMixin {
  final padding = const EdgeInsets.symmetric(horizontal: 10);

  int no = 0;

  var visible = true;

  TextEditingController myController = TextEditingController();

  List all = [];

  List _list = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return CustomPopupMenu(
      child: const Icon(Icons.search),
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
                height: 200,
                width: 500,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24.0, vertical: 16),
                      child: TextField(
                        cursorColor: themeProvider.isDarkMode
                            ? Colors.white
                            : Colors.black,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          suffixIcon: IconButton(
                            icon: Icon(
                              Icons.clear,
                              color: themeProvider.isDarkMode
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            onPressed: () {
                              myController.clear();
                              visible = false;
                              setState(() {
                                _list = all;
                              });
                            },
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: themeProvider.isDarkMode
                                ? Colors.white
                                : Colors.black,
                          ),
                          hintText: 'Search',
                        ),
                        controller: myController,
                        onChanged: _search,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
      },
    );
  }

  Future<void> _search(String query) async {
    if (query != '') {
      final suggestions = _list.where((book) {
        final bookTitle = book.toLowerCase();

        final input = query.toLowerCase();
        return bookTitle.contains(input);
      }).toList();
      setState(() {
        visible = true;
        if (suggestions.isNotEmpty) {
          _list = suggestions;
        }
      });
    } else {
      visible = false;
      setState(() {
        _list = all;
      });
    }
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
