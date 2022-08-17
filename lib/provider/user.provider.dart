import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AppUser extends ChangeNotifier {
  String? cid;
  String? pid;
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
  String? role = 'No data';

  static AppUser get instance => AppUser();
  FirebaseFirestore db = FirebaseFirestore.instance;

  signOut() async {
    await FirebaseAuth.instance.signOut();
    role = 'No data';
    notifyListeners();
  }

  Future<void> signIn({required String email, required String password}) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        await getRole();
      });
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
    await docRef.get().then(
      (value) {
        role = value['role'];
        notifyListeners();
      },
    );
  }

  Future<void> updateRole(url, pid, cid) async {
    db.collection("quranIrabUsers").doc(AppUser.instance.user!.uid).set({
      "role": "premium-user",
      "receipt-url": url,
      "payment-id": pid,
      "cust-id": cid
    }, SetOptions(merge: true));
    role = 'premium-user';
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

  final firestoreInstance = FirebaseFirestore.instance;

  Future<void> updatedata(
      String firstname, String lastname, String email) async {
    await firestoreInstance
        .collection("quranIrabUsers")
        .doc(AppUser.instance.user!.uid)
        .set({
      "role": 'user',
      "first_name": firstname,
      "last_name": lastname,
      "email": email,
      "profileImage": AppUser.instance.user!.photoURL ?? "",
      "uid": AppUser.instance.user!.uid
    }, SetOptions(merge: true)).then((value) {
      print("Data added sucessfully");
    });
    var imageURL = AppUser.instance.user!.photoURL ?? "";
    var displayName = "$firstname $lastname";
    AppUser.instance.user!.updateDisplayName(displayName);
    AppUser.instance.user!.updatePhotoURL(imageURL);
  }

  Future<void> getData(
      String firstname, String lastname, String email, String url) async {
    await firestoreInstance
        .collection("quranIrabUsers")
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        firstname = doc["first_name"];
        lastname = doc["last_name"];
        email = doc["email"];
        url = doc["profileImage"];
      }
    });
  }

  Future<void> updateImage(String url) async {
    user!.updatePhotoURL(url);
    notifyListeners();
  }

  Future<void> updatePass(String newpass, String oldpass) async {
    AppUser.instance.signIn(email: user!.email!, password: oldpass);
    user!.updatePassword(newpass);
    notifyListeners();
  }

  void setCid(custId) {
    cid = custId;
    notifyListeners();
  }

  void setPid(id) {
    pid = id;
    notifyListeners();
  }
}
