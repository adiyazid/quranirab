import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DeleteProvider extends ChangeNotifier {
  CollectionReference relationship =
      FirebaseFirestore.instance.collection('word_relationships');

  Future<void> deleteRelationship(id) {
    return relationship
        .doc('$id')
        .delete()
        .then((value) => print("Data $id Deleted"))
        .catchError((error) => print("Failed to delete data: $error"));
  }
}
