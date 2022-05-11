import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AppUser extends ChangeNotifier {
  update() {
    notifyListeners();
  }

  AppUser._() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      notifyListeners();
    });
  }

  User? get user => FirebaseAuth.instance.currentUser;

  factory AppUser() => AppUser._();
  String role = 'None';

  static AppUser get instance => AppUser();
  FirebaseFirestore db = FirebaseFirestore.instance;

  signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<void> signIn({required String email, required String password}) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      print('Sign in Successful');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw ('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        throw ('Wrong password provided for that user.');
      } else {
        throw (e.toString());
      }
    }
  }

  Future<void> getRole() async {
    final docRef =
        db.collection("quranIrabUsers").doc(AppUser.instance.user!.uid);
    role = await docRef.get().then(
      (value) {
        return value['role'] ?? 'None';
      },
      onError: (e) => print("Error completing: $e"),
    );
    notifyListeners();
  }

  Future<void> updateName(String name) async {
    user!.updateDisplayName(name);
    notifyListeners();
  }

  Future<void> updatePassword(String password) async {
    user!.updatePassword(password);
    notifyListeners();
  }

  Future<bool> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      user!.updateDisplayName('$firstName $lastName');
      return true;
    } catch (e) {
      rethrow;
    }
  }
}
