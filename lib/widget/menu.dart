import 'package:flutter/material.dart';
import 'package:quranirab/views/home.page.dart';

class Menu extends StatelessWidget {
  final padding = const EdgeInsets.symmetric(horizontal: 10);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Material(
        color: Theme.of(context).primaryColor,
        child: ListView(
          padding: padding,
          children: <Widget>[
            const SizedBox(height: 10),
            const Center(
              child: CircleAvatar(
                backgroundImage: AssetImage('assets/quranirab.png'),
                radius: 30.0,
              ),
            ),
            Divider(color: Colors.grey[300]),
            const SizedBox(height: 18),
            buildMenuItem(
              text: 'Home',
              icon: Icons.home_outlined,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const HomePage()));
              },
            ),
            const SizedBox(height: 16),
            buildMenuItem(
              text: 'About us',
              icon: Icons.info_outline,
              onTap: () {},
            ),
            const SizedBox(height: 16),
            buildMenuItem(
              text: 'Privacy',
              icon: Icons.privacy_tip_outlined,
              onTap: () {},
            ),
            const SizedBox(height: 16),
            buildMenuItem(
              text: 'Feedback',
              icon: Icons.feedback_outlined,
              onTap: () {},
            ),
            const SizedBox(height: 16),
            buildMenuItem(
              text: 'Help',
              icon: Icons.help_outline,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMenuItem({
    required String text,
    required IconData icon,
    required var onTap,
  }) {
    final color = Colors.black;

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(text, style: TextStyle(color: color)),
      onTap: onTap,
    );
  }

  void SelectedItem(BuildContext context, int index) {
    Navigator.of(context).pop();
  }
}
