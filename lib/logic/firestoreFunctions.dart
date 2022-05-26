import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instaa/model/postModel.dart';
import 'package:instaa/model/userModel.dart';
import 'package:uuid/uuid.dart';

import 'imageUpload.dart';

Future addUser(String username, String email, String bio, String userId,
    String imgUrl, String name) async {
  UserModel userModel = UserModel(
      bio: bio,
      email: email,
      followers: [],
      following: [],
      imgUrl: imgUrl,
      userId: userId,
      username: username,
      name: name);
  await FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .set(userModel.toJson());
}

Future addPost(String description, String username, Uint8List image,
    String userId, String profileUrl) async {
  String res = '';
  try {
    String postId = Uuid().v1();
    String photoUrl =
        await ImageUpload().uploadImages('Post Pictures', postId, image);
    PostModel postModel = PostModel(
        profileUrl: profileUrl,
        description: description,
        postId: postId,
        datePublished: DateTime.now(),
        photoUrl: photoUrl,
        likes: [],
        userId: userId,
        username: username);
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .set(postModel.toJson());
    res = 'done';
  } catch (e) {
    res = e.toString();
    res = e.toString();
  }
  return res;
}

Future addLike(bool like, String postId, String userId) async {
  if (like == false) {
    await FirebaseFirestore.instance.collection('posts').doc(postId).update({
      "likes": FieldValue.arrayUnion([userId])
    });
  } else if (like == true) {
    await FirebaseFirestore.instance.collection('posts').doc(postId).update({
      "likes": FieldValue.arrayRemove([userId])
    });
  }
}

Future addFollower(bool isFollowing, String followerId, String userId) async {
  if (isFollowing == false) {
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      "following": FieldValue.arrayUnion([followerId])
    });
    await FirebaseFirestore.instance
        .collection('users')
        .doc(followerId)
        .update({
      "followers": FieldValue.arrayUnion([userId])
    });
  } else if (isFollowing == true) {
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      "following": FieldValue.arrayRemove([followerId])
    });
    await FirebaseFirestore.instance
        .collection('users')
        .doc(followerId)
        .update({
      "followers": FieldValue.arrayRemove([userId])
    });
  }
}

Future addComment(String postId, String userId, String profileId,
    String username, String comment) async {
  try {
    String commentId = Uuid().v1();
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(commentId)
        .set({
      "userId": userId,
      "profileId": profileId,
      "username": username,
      "comment": comment,
      "commentId": commentId,
      "datePublished": DateTime.now()
    });
  } catch (e) {}
}

Future updateProfileImage(
  Uint8List image,
  String userId,
) async {
  String msg = '';
  try {
    String postId = Uuid().v1();
    String photoUrl =
        await ImageUpload().uploadImages('Post Pictures', postId, image);
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .update({"imgUrl": photoUrl});
    msg = 'done';
  } catch (e) {
    msg = e.toString();
  }
  return msg;
}
