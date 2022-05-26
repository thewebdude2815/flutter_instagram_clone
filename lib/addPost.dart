// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instaa/feedScreen.dart';
import 'package:instaa/logic/firestoreFunctions.dart';
import 'package:instaa/logic/pickImage.dart';
import 'package:instaa/model/userModel.dart';
import 'package:instaa/providers/userProvider.dart';
import 'package:instaa/responsive/mobileScreen.dart';
import 'package:instaa/responsive/responsiveLayout.dart';
import 'package:instaa/responsive/webScreen.dart';
import 'package:provider/provider.dart';

class AddPost extends StatefulWidget {
  const AddPost({Key? key}) : super(key: key);

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  TextEditingController descriptionC = TextEditingController();
  String error = '';
  bool isLoading = false;
  @override
  void dispose() {
    descriptionC.dispose();
    super.dispose();
  }

  uploadF(String username, String uid, Uint8List image, String profileUrl) {
    String msg = '';
    try {
      addPost(descriptionC.text, username, image, uid, profileUrl);
      msg = "done";
    } catch (e) {
      msg = e.toString();
    }
    return msg;
  }

  void deleteImage() {
    setState(() {
      _image = null;
    });
  }

  Uint8List? _image;
  selectImage(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Create A Post'),
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
    return _image == null
        ? Center(
            child: IconButton(
              onPressed: () async {
                await selectImage(context);
              },
              icon: Icon(Icons.upload),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: const Color.fromARGB(255, 30, 30, 30),
              leading: IconButton(
                onPressed: () {
                  deleteImage();
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
              ),
              elevation: 0,
              centerTitle: true,
              title: const Text('Add Post'),
              actions: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      isLoading = true;
                    });
                    String msg = uploadF(userModel.username, userModel.userId,
                        _image!, userModel.imgUrl);
                    if (msg == 'done') {
                      Timer(Duration(seconds: 2), () {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (_) {
                          return ResponsiveLayout(
                            mobileScreen: MobileScreen(),
                            webScreen: WebScreen(),
                          );
                        }));
                      });
                    } else {
                      setState(() {
                        error = msg;
                      });
                    }
                  },
                  child: const Text('Post'),
                )
              ],
            ),
            body: Column(
              children: [
                isLoading
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: LinearProgressIndicator(),
                      )
                    : Container(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      // backgroundColor: Colors.amberAccent.shade100,
                      backgroundImage: NetworkImage(userModel.imgUrl),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.35,
                      child: TextField(
                        controller: descriptionC,
                        maxLines: 8,
                        decoration: InputDecoration(
                            hintText: 'Write Something...',
                            border: InputBorder.none),
                      ),
                    ),
                    SizedBox(
                      height: 45,
                      width: 45,
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: MemoryImage(_image!), fit: BoxFit.cover),
                        ),
                      ),
                    ),
                  ],
                ),
                Text(error)
              ],
            ),
          );
  }
}
