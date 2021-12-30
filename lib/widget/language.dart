import 'package:flutter/material.dart';

class Language extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
        color: Theme.of(context).primaryColor,
        icon: const Icon(Icons.language),
        onSelected: (item) => onSelected(context, item),
        itemBuilder: (context) => [
              const PopupMenuItem<int>(
                  value: 0,
                  enabled: false,
                  child: Text(
                    'Language',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  )),
              const PopupMenuDivider(),
              const PopupMenuItem<int>(
                  value: 1,
                  child:
                      Text('English', style: TextStyle(color: Colors.black))),
              const PopupMenuItem<int>(
                  value: 2,
                  child: Text('Melayu', style: TextStyle(color: Colors.black))),
            ]);
  }

  void onSelected(BuildContext context, int item) {
    switch (item) {
      case 1:
        print('english click');
        break;
      case 2:
        print('melayu click');
        break;
    }
  }
}
