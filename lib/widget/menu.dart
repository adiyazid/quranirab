import 'package:flutter/material.dart';

class Menu extends StatelessWidget {
  final padding = EdgeInsets.symmetric(horizontal: 10);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Material(
        color:Theme.of(context).primaryColor,
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
            ),
            const SizedBox(height: 16),
            buildMenuItem(
              text: 'About us',
              icon: Icons.info_outline,
            ),
            const SizedBox(height: 16),
            buildMenuItem(
              text: 'Privacy',
              icon: Icons.privacy_tip_outlined,
            ),
            const SizedBox(height: 16),
            buildMenuItem(
              text: 'Feedback',
              icon: Icons.feedback_outlined,
            ),
            const SizedBox(height: 16),
            buildMenuItem(
              text: 'Help',
              icon: Icons.help_outline,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMenuItem({
    required String text,
    required IconData icon,
  }) {
    final color = Colors.black;

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(text, style: TextStyle(color: color)),
      onTap: (){},
    );
  }

  void SelectedItem(BuildContext context,int index){
    Navigator.of(context).pop();
  }

}