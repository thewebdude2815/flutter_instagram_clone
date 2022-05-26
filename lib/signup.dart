// ignore_for_file: sort_child_properties_last, use_build_context_synchronously

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instaa/logic/authFunctions.dart';
import 'package:instaa/login.dart';
import 'package:instaa/responsive/mobileScreen.dart';
import 'package:instaa/welcome.dart';

import 'logic/pickImage.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController usernameC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController passwordC = TextEditingController();
  TextEditingController bioC = TextEditingController();
  TextEditingController nameC = TextEditingController();
  String err = '';
  Uint8List? _image;
  bool isLoading = false;
  void selectImage() async {
    Uint8List? _img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = _img;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Flexible(
                //   child: Container(),
                //   flex: 2,
                // ),
                const SizedBox(
                  height: 60,
                ),
                Text(err),
                SvgPicture.asset(
                  'image/instagram.svg',
                  height: 100,
                  color: Colors.white,
                ),
                const SizedBox(
                  height: 20,
                ),
                Stack(
                  children: [
                    _image != null
                        ? CircleAvatar(
                            radius: 70,
                            backgroundImage: MemoryImage(_image!),
                          )
                        : const CircleAvatar(
                            radius: 70,
                            backgroundColor: Colors.deepOrangeAccent,
                          ),
                    Positioned(
                      bottom: 0,
                      right: 10,
                      child: GestureDetector(
                          onTap: () {
                            selectImage();
                          },
                          child: Icon(Icons.add_a_photo)),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: usernameC,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Color.fromARGB(255, 114, 114, 114),
                      hintText: 'Enter Your Username',
                      hintStyle: TextStyle(color: Colors.black)),
                ),

                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: nameC,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Color.fromARGB(255, 114, 114, 114),
                      hintText: 'Enter Your Full Name',
                      hintStyle: TextStyle(color: Colors.black)),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: emailC,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Color.fromARGB(255, 114, 114, 114),
                      hintText: 'Enter Your Email',
                      hintStyle: TextStyle(color: Colors.black)),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: passwordC,
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Color.fromARGB(255, 114, 114, 114),
                    hintText: 'Enter Your Password',
                    hintStyle: TextStyle(color: Colors.black),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: bioC,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Color.fromARGB(255, 114, 114, 114),
                      hintText: 'Enter Your Bio',
                      hintStyle: TextStyle(color: Colors.black)),
                ),
                const SizedBox(
                  height: 30,
                ),
                GestureDetector(
                  onTap: () async {
                    setState(() {
                      isLoading = true;
                    });
                    String message = await signupFunction(
                        usernameC.text,
                        emailC.text,
                        passwordC.text,
                        bioC.text,
                        _image!,
                        nameC.text);
                    if (message == "done") {
                      Navigator.push(context, MaterialPageRoute(builder: (_) {
                        return MobileScreen();
                      }));
                    } else if (message == 'miss') {
                      setState(() {
                        err = "Missing";
                      });
                    } else {
                      setState(() {
                        err = message.toString();
                      });
                    }
                  },
                  child: Container(
                    height: 60,
                    width: double.infinity,
                    child: Center(
                      child: isLoading
                          ? CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text('Signup'),
                    ),
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 101, 157, 254),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (_) {
                        return Login();
                      }));
                    },
                    child: const Text('Login Instead.')),
                // Flexible(
                //   child: Container(),
                //   flex: 2,
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
