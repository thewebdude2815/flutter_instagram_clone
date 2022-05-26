import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  String username;
  String email;
  String imgUrl;
  String userId;
  String bio;
  List followers;
  List following;
  String name;
  UserModel(
      {required this.bio,
      required this.email,
      required this.followers,
      required this.following,
      required this.imgUrl,
      required this.userId,
      required this.username,
      required this.name});

  Map<String, dynamic> toJson() => {
        "username": username,
        "email": email,
        "bio": bio,
        "userId": userId,
        "imgUrl": imgUrl,
        "followers": [],
        "following": [],
        "name": name
      };

  static UserModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    // print(snapshot['bio']);
    return UserModel(
        name: snapshot['name'],
        bio: snapshot['bio'],
        email: snapshot['email'],
        followers: snapshot['followers'],
        following: snapshot['following'],
        imgUrl: snapshot['imgUrl'],
        userId: snapshot['userId'],
        username: snapshot['username']);
  }
}
