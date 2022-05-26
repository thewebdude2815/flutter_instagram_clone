import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instaa/logic/firestoreFunctions.dart';
import 'package:instaa/model/userModel.dart';
import 'package:instaa/providers/userProvider.dart';
import 'package:provider/provider.dart';

import 'comments.dart';

class FeeScreen extends StatefulWidget {
  const FeeScreen({Key? key}) : super(key: key);

  @override
  State<FeeScreen> createState() => _FeeScreenState();
}

class _FeeScreenState extends State<FeeScreen> {
  bool isLiked = false;
  @override
  Widget build(BuildContext context) {
    UserModel userModel = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SvgPicture.asset(
                      'image/instagram.svg',
                      height: 50,
                      color: Colors.white,
                    ),
                    const Icon(Icons.message_outlined),
                  ],
                ),
                StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('posts')
                        .where('userId', isNotEqualTo: userModel.userId)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        final postCount = snapshot.data!.docs;
                        if (postCount.isEmpty) {
                          return const Center(
                            child: Text('No Posts yet'),
                          );
                        } else {
                          return SizedBox(
                            height: MediaQuery.of(context).size.height * 0.8,
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: postCount.length,
                                itemBuilder: (context, index) {
                                  return PostBoox(
                                    lol: postCount[index]['likes']
                                        .contains(userModel.userId),
                                    postId: postCount[index]['postId'],
                                    userId: userModel.userId,
                                    userName: postCount[index]['username'],
                                    description: postCount[index]
                                        ['description'],
                                    postImage: postCount[index]['photoUrl'],
                                    profileImage: postCount[index]
                                        ['profileUrl'],
                                    likes: postCount[index]['likes'].length,
                                  );
                                }),
                          );
                        }
                      }
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PostBoox extends StatelessWidget {
  String userName;
  String description;
  String postImage;
  String profileImage;
  int likes;

  String postId;
  String userId;
  bool lol;
  PostBoox(
      {required this.userName,
      required this.lol,
      required this.description,
      required this.postId,
      required this.userId,
      required this.likes,
      required this.postImage,
      required this.profileImage});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                  backgroundImage: NetworkImage(profileImage), radius: 20),
              const SizedBox(
                width: 15,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userName,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Bio',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Text(description),
          const SizedBox(
            height: 10,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              height: 300,
              width: double.infinity,
              child: Image.network(
                postImage,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Row(
                children: [
                  lol
                      ? GestureDetector(
                          onTap: () {
                            addLike(lol, postId, userId);
                          },
                          child: Icon(
                            Icons.favorite,
                            color: Colors.red,
                          ),
                        )
                      : GestureDetector(
                          onTap: () {
                            addLike(lol, postId, userId);
                          },
                          child: Icon(Icons.favorite_outline_outlined)),
                  SizedBox(
                    width: 5,
                  ),
                  Text(likes.toString())
                ],
              ),
              const SizedBox(
                width: 20,
              ),
              Row(
                children: [
                  GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) {
                          return Comments(
                            description: description,
                            username: userName,
                            uploaderImaage: profileImage,
                            postId: postId,
                          );
                        }));
                      },
                      child: Icon(Icons.comment_sharp)),
                  const SizedBox(
                    width: 5,
                  ),
                ],
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
              ),
              const Icon(Icons.hdr_strong_outlined),
            ],
          )
        ],
      ),
    );
  }
}
