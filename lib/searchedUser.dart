import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instaa/model/userModel.dart';
import 'package:instaa/providers/userProvider.dart';
import 'package:instaa/searchedUserProfile.dart';
import 'package:provider/provider.dart';

class SearchedUser extends StatefulWidget {
  String searchedC;
  SearchedUser({required this.searchedC});

  @override
  State<SearchedUser> createState() => _SearchedUserState();
}

class _SearchedUserState extends State<SearchedUser> {
  @override
  Widget build(BuildContext context) {
    UserModel userModel = Provider.of<UserProvider>(context).getUser;
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
        title: Text('Search Results'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .where('username', isNotEqualTo: userModel.username)
              .where('username', isGreaterThanOrEqualTo: widget.searchedC)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
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
                return ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: userCount.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) {
                          return SearchedUserProfile(
                              follow: userCount[index]['followers']
                                  .contains(userModel.userId),
                              username: userCount[index]['username'],
                              imgUrl: userCount[index]['imgUrl'],
                              bio: userCount[index]['bio'],
                              userId: userCount[index]['userId'],
                              name: userCount[index]['name']);
                        }));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundImage:
                                  NetworkImage(userCount[index]['imgUrl']),
                              radius: 25,
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  userCount[index]['username'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17),
                                ),
                                const SizedBox(
                                  height: 6,
                                ),
                                Text(
                                  userCount[index]['name'],
                                  style: TextStyle(fontSize: 12),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            }
          },
        ),
      ),
    );
  }
}
