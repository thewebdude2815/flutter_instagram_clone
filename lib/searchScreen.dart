import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instaa/providers/userProvider.dart';
import 'package:instaa/responsive/mobileScreen.dart';
import 'package:instaa/searchedUser.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instaa/singlePost.dart';
import 'package:provider/provider.dart';

import 'model/userModel.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchC = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? validateSearch(String? searchC) {
    if (searchC == null) {
      return 'Search Name Cant Be Null';
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    UserModel userModel = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 30, 30, 30),
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) {
              return MobileScreen();
            }));
          },
          child: const Icon(Icons.arrow_back_ios),
        ),
        title: Form(
          key: _formKey,
          child: TextFormField(
            onFieldSubmitted: (v) {
              if (_formKey.currentState!.validate()) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) {
                      return SearchedUser(searchedC: searchC.text);
                    },
                  ),
                );
              }
            },
            validator: validateSearch,
            controller: searchC,
            decoration: const InputDecoration(
              hintText: 'Search...',
              contentPadding:
                  EdgeInsets.symmetric(vertical: 10.0, horizontal: 30),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) {
                      return SearchedUser(searchedC: searchC.text);
                    },
                  ),
                );
              }
            },
            child: const Text('Search'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('posts')
                  .where('userId', isNotEqualTo: userModel.userId)
                  .snapshots(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
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
                                  userName: userCount[index]['username'],
                                  description: userCount[index]['description'],
                                  postImage: userCount[index]['photoUrl'],
                                  profileImage: userCount[index]['profileUrl'],
                                  likes: userCount[index]['likes'].length);
                            }));
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
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
        ),
      ),
    );
  }
}

// index: index,
//       extent: (index % 5 + 1) * 100