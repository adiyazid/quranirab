import 'package:flutter/material.dart';

class Language extends StatelessWidget {
  const Language({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
        color: Theme.of(context).primaryColor,
        icon: const Icon(Icons.language),
        onSelected: (item) => onSelected(context, item),
        itemBuilder: (context) => [
               PopupMenuItem<int>(
                  value: 0,
                  enabled: false,
                  child: Text(
                    'Language',
                    style: TextStyle(
                        color: Theme.of(context).textSelectionColor, fontWeight: FontWeight.bold),
                  )),
              const PopupMenuDivider(),
               PopupMenuItem<int>(
                  value: 1,
                  child:
                      Text('English', style: TextStyle(color: Theme.of(context).textSelectionColor))),
               PopupMenuItem<int>(
                  value: 2,
                  child: Text('Melayu', style: TextStyle(color: Theme.of(context).textSelectionColor))),
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
