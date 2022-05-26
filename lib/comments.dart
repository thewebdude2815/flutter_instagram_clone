import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instaa/logic/firestoreFunctions.dart';
import 'package:instaa/model/userModel.dart';
import 'package:instaa/providers/userProvider.dart';
import 'package:provider/provider.dart';

class Comments extends StatefulWidget {
  String postId;
  String uploaderImaage;
  String description;
  String username;
  Comments(
      {required this.postId,
      required this.description,
      required this.uploaderImaage,
      required this.username});

  @override
  State<Comments> createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  @override
  Widget build(BuildContext context) {
    TextEditingController commentC = TextEditingController();
    UserModel userModel = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 30, 30, 30),
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_ios),
        ),
        title: const Text(
          'Comments',
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 17, right: 17, bottom: 17),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(widget.uploaderImaage),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  widget.username,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(widget.description)
              ],
            ),
            Container(
              padding: const EdgeInsets.only(top: 17),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                      width: 1, color: Color.fromARGB(255, 42, 42, 42)),
                ),
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('posts')
                  .doc(widget.postId)
                  .collection('comments')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  final commentCount = snapshot.data!.docs;
                  if (commentCount.isEmpty) {
                    return const Center(
                      child: Text('No Comments yet'),
                    );
                  } else {
                    return ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: commentCount.length,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: const EdgeInsets.only(top: 17),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(
                                    commentCount[index]['profileId']),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                commentCount[index]['username'],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(commentCount[index]['comment'])
                            ],
                          ),
                        );
                      },
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: 50,
          margin: const EdgeInsets.only(left: 10),
          child: Row(
            children: [
              CircleAvatar(backgroundImage: NetworkImage(userModel.imgUrl)),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 10),
                  child: TextField(
                    controller: commentC,
                    decoration: InputDecoration(
                        hintText: 'Comment as ${userModel.username}',
                        border: InputBorder.none),
                  ),
                ),
              ),
              TextButton(
                onPressed: () async {
                  await addComment(widget.postId, userModel.userId,
                          userModel.imgUrl, userModel.username, commentC.text)
                      .then((value) {
                    commentC.text = '';
                  });
                },
                child: const Text('Post'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
