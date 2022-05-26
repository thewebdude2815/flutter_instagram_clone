import 'dart:async';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instaa/logic/authFunctions.dart';
import 'package:instaa/login.dart';
import 'package:instaa/model/userModel.dart';
import 'package:instaa/providers/userProvider.dart';
import 'package:instaa/singlePost.dart';
import 'package:provider/provider.dart';

import 'logic/pickImage.dart';

class MyProfile extends StatefulWidget {
  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  int myPosts = 0;
  bool isLoading = false;
  @override
  void initState() {
    getPostsLength(FirebaseAuth.instance.currentUser!.uid);
    getFollowersLength(FirebaseAuth.instance.currentUser!.uid);
    getFollowingsLength(FirebaseAuth.instance.currentUser!.uid);
    super.initState();
  }

  Future getPostsLength(String userId) async {
    setState(() {
      isLoading = true;
    });
    int posts = 0;
    QuerySnapshot postsCount = await FirebaseFirestore.instance
        .collection('posts')
        .where('userId', isEqualTo: userId)
        .get();
    posts = postsCount.docs.length;
    print(posts);
    setState(() {
      myPosts = posts;
      isLoading = false;
    });
  }

  int followers = 0;
  Future getFollowersLength(String userId) async {
    setState(() {
      isLoading = true;
    });
    int follower = 0;
    DocumentSnapshot followerCount =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    var followerData = followerCount.data() as Map<String, dynamic>;
    follower = followerData['followers'].length;

    setState(() {
      followers = follower;
      isLoading = false;
    });
  }

  int followings = 0;
  Future getFollowingsLength(String userId) async {
    setState(() {
      isLoading = true;
    });
    int following = 0;
    DocumentSnapshot followerCount =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    var followerData = followerCount.data() as Map<String, dynamic>;
    following = followerData['following'].length;

    setState(() {
      followings = following;
      isLoading = false;
    });
  }

  Uint8List? _image;
  selectImage(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Update Profile Pic'),
            children: [
              SimpleDialogOption(
                padding: EdgeInsets.all(20),
                child: const Text('Take A Photo'),
                onPressed: () async {
                  Navigator.pop(context);
                  Uint8List? _img = await pickImage(ImageSource.camera);
                  setState(() {
                    _image = _img;
                  });
                },
              ),
              SimpleDialogOption(
                padding: EdgeInsets.all(20),
                child: const Text('Take From Gallery'),
                onPressed: () async {
                  Navigator.pop(context);
                  Uint8List? _img = await pickImage(ImageSource.gallery);
                  setState(() {
                    _image = _img;
                  });
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    UserModel userModel = Provider.of<UserProvider>(context).getUser;
    return isLoading
        ? const Scaffold(
            body: SafeArea(
                child: Center(
              child: CircularProgressIndicator(),
            )),
          )
        : Scaffold(
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: const Color.fromARGB(255, 30, 30, 30),
              elevation: 0,
              title: Text(userModel.username),
              actions: [
                GestureDetector(
                    onTap: () async {
                      String result = await logout();
                      if (result == 'done') {
                        Timer(Duration(seconds: 2), () {
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (_) {
                            return Login();
                          }));
                        });
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Icon(Icons.logout),
                    ))
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundImage: NetworkImage(userModel.imgUrl),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: () async {
                                  await selectImage(context);
                                },
                                child: Icon(Icons.imagesearch_roller_sharp),
                              ),
                            )
                          ],
                        ),
                        Column(
                          // mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(myPosts.toString()),
                            Text('Posts'),
                          ],
                        ),
                        Column(
                          children: [
                            Text(followers.toString()),
                            Text('Followers'),
                          ],
                        ),
                        Column(
                          children: [
                            Text(followings.toString()),
                            Text('Following'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userModel.name,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        userModel.bio,
                        style: const TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 30,
                          child: Center(
                            child: Text(
                              'Edit Account',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('posts')
                          .where('userId', isEqualTo: userModel.userId)
                          .snapshots(),
                      builder: (context, AsyncSnapshot snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          final userCount = snapshot.data!.docs;
                          if (userCount.isEmpty) {
                            return const Center(
                              child: Text('No Posts Found'),
                            );
                          } else {
                            return GridView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10,
                                childAspectRatio: 0.8,
                              ),
                              itemCount: userCount.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (_) {
                                      return SinglePost(
                                          lol: userCount[index]['likes']
                                              .contains(userModel.userId),
                                          postId: userCount[index]['postId'],
                                          userId: userModel.userId,
                                          userName: userCount[index]
                                              ['username'],
                                          description: userCount[index]
                                              ['description'],
                                          postImage: userCount[index]
                                              ['photoUrl'],
                                          profileImage: userCount[index]
                                              ['profileUrl'],
                                          likes:
                                              userCount[index]['likes'].length);
                                    }));
                                  },
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 10.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                            userCount[index]['photoUrl'],
                                          ),
                                        )),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                        }
                      }),
                ],
              ),
            ),
          );
  }
}
