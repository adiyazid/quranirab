import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quranirab/provider/ayah.number.provider.dart';

class EditData extends StatefulWidget {
  final int id;
  const EditData({required this.id, Key? key}) : super(key: key);

  @override
  State<EditData> createState() => _EditDataState();
}

class _EditDataState extends State<EditData> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Id ${widget.id}'),
        ),
        body: Consumer<AyaProvider>(builder: (context, aya, child) {
          return ListView.builder(
            itemCount: aya.wordDetail.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text('${aya.wordDetail[index].name}'),
                subtitle: Text('${aya.wordDetail[index].childType}'),
              );
            },
          );
        }));
  }
}
