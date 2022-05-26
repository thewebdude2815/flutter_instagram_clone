import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PostModel {
  String description;
  String username;
  String postId;
  String userId;
  DateTime datePublished;
  String photoUrl;
  String profileUrl;
  List likes;
  PostModel(
      {required this.profileUrl,
      required this.description,
      required this.postId,
      required this.datePublished,
      required this.photoUrl,
      required this.likes,
      required this.userId,
      required this.username});

  Map<String, dynamic> toJson() => {
        "profileUrl": profileUrl,
        "description": description,
        "postId": postId,
        "userId": userId,
        "photoUrl": photoUrl,
        "datePublished": datePublished,
        "likes": [],
        "username": username
      };

  static PostModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    // print(snapshot['bio']);
    return PostModel(
        profileUrl: snapshot['profileUrl'],
        description: snapshot['description'],
        postId: snapshot['postId'],
        userId: snapshot['userId'],
        photoUrl: snapshot['photoUrl'],
        datePublished: snapshot['datePublished'],
        likes: snapshot['likes'],
        username: snapshot['username']);
  }
}
