import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:instaa/logic/firestoreFunctions.dart';
import 'package:instaa/logic/imageUpload.dart';
import 'package:instaa/model/userModel.dart';

Future signupFunction(String username, String email, String password,
    String bio, Uint8List image, String name) async {
  String err = '';
  try {
    if (username.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        bio.isEmpty ||
        image.isEmpty ||
        name.isEmpty) {
      err = 'miss';
    } else {
      String imgUrl =
          await ImageUpload().uploadImages('Profile Pictures', username, image);
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      String userId = FirebaseAuth.instance.currentUser!.uid;
      await addUser(username, email, bio, userId, imgUrl, name);
      err = 'done';
    }
  } catch (e) {
    err = e.toString();
    // return err;
  }
  return err;
}

Future loginFunction(String email, String password) async {
  String err = '';
  try {
    if (email.isEmpty || password.isEmpty) {
      err = 'miss';
    } else {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      err = 'done';
    }
  } catch (e) {
    err = e.toString();
    // return err;
  }
  return err;
}

Future<UserModel> getUserDetails() async {
  DocumentSnapshot snap = await FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .get();
  var receievedData = UserModel.fromSnap(snap);
  return receievedData;
}

Future logout() async {
  String msg = '';
  try {
    await FirebaseAuth.instance.signOut();
    msg = 'done';
  } catch (e) {
    msg = e.toString();
  }
  return msg;
}
