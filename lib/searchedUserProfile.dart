import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instaa/model/userModel.dart';
import 'package:instaa/providers/userProvider.dart';
import 'package:instaa/singlePost.dart';
import 'package:provider/provider.dart';

import 'logic/firestoreFunctions.dart';

class SearchedUserProfile extends StatefulWidget {
  String username;
  String imgUrl;
  String bio;
  String userId;
  String name;
  bool follow;
  SearchedUserProfile(
      {required this.username,
      required this.follow,
      required this.name,
      required this.imgUrl,
      required this.bio,
      required this.userId});

  @override
  State<SearchedUserProfile> createState() => _SearchedUserProfileState();
}

class _SearchedUserProfileState extends State<SearchedUserProfile> {
  int myPosts = 0;
  bool isLoading = false;

  @override
  void initState() {
    getPostsLength(widget.userId);
    getFollowersLength(widget.userId);
    getFollowersLength(widget.userId);
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
    following = followerData['followings'].length;

    setState(() {
      followings = following;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    UserModel userModel = Provider.of<UserProvider>(context).getUser;
    return isLoading
        ? Scaffold(
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
              leading: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(Icons.arrow_back_ios),
              ),
              title: Text(widget.username),
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
                        CircleAvatar(
                          radius: 45,
                          backgroundImage: NetworkImage(widget.imgUrl),
                        ),
                        Column(
                          // mainAxisAlignment: MainAxisAlignment.center,
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
                        widget.name,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        widget.bio,
                        style: const TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      widget.follow
                          ? Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  addFollower(widget.follow, widget.userId,
                                      userModel.userId);
                                  setState(() {
                                    widget.follow = false;
                                    followers--;
                                  });
                                },
                                child: Container(
                                  height: 30,
                                  child: Center(
                                    child: Text('Unfollow'),
                                  ),
                                  decoration: BoxDecoration(
                                      color: Colors.blueAccent,
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                              ),
                            )
                          : Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  addFollower(widget.follow, widget.userId,
                                      userModel.userId);
                                  setState(() {
                                    widget.follow = true;
                                    followers++;
                                  });
                                },
                                child: Container(
                                  height: 30,
                                  child: Center(
                                    child: Text('Follow'),
                                  ),
                                  decoration: BoxDecoration(
                                      color: Colors.blueAccent,
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                              ),
                            ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Container(
                          height: 30,
                          child: Center(
                            child: Text(
                              'Message',
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
                    height: 10,
                  ),
                  StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('posts')
                          .where('userId', isEqualTo: widget.userId)
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
                              child: Text('No Users Found'),
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
