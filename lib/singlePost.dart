import 'package:flutter/material.dart';
import 'package:instaa/feedScreen.dart';

class SinglePost extends StatefulWidget {
  String userName;
  String description;
  String postImage;
  String profileImage;
  int likes;

  String postId;
  String userId;
  bool lol;
  SinglePost(
      {required this.description,
      required this.likes,
      required this.lol,
      required this.postId,
      required this.postImage,
      required this.profileImage,
      required this.userId,
      required this.userName});

  @override
  State<SinglePost> createState() => _SinglePostState();
}

class _SinglePostState extends State<SinglePost> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 30, 30, 30),
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back_ios),
        ),
        title: const Text('Post'),
      ),
      body: SafeArea(
        child: PostBoox(
            userName: widget.userName,
            lol: widget.lol,
            description: widget.description,
            postId: widget.postId,
            userId: widget.userId,
            likes: widget.likes,
            postImage: widget.postImage,
            profileImage: widget.profileImage),
      ),
    );
  }
}
