import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:quranirab/facebook/widgets/circle_button.dart';

class Appbar extends StatefulWidget {
  const Appbar({Key? key}) : super(key: key);

  @override
  _AppbarState createState() => _AppbarState();
}

class _AppbarState extends State<Appbar> {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      leading: IconButton(
        icon: Icon(
          Icons.menu,
          color: Theme.of(context).colorScheme.onBackground,
        ),
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      title: const CircleAvatar(
        backgroundImage: AssetImage('assets/quranirab.png'),
        radius: 18.0,
      ),
      centerTitle: false,
      floating: true,
      actions: [
        CircleButton(
          icon: Icons.search,
          iconSize: 30.0,
          onPressed: () => print('Search'),
        ),
        CircleButton(
          icon: MdiIcons.earth,
          iconSize: 30.0,
          onPressed: () => print('Messenger'),
        ),
        CircleButton(
          icon: Icons.settings,
          iconSize: 30.0,
          onPressed: () {
            Scaffold.of(context).openEndDrawer();
          },
        ),
      ],
    );
  }
}
