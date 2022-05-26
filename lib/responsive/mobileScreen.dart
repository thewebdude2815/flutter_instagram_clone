// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instaa/addPost.dart';
import 'package:instaa/feedScreen.dart';
import 'package:instaa/model/userModel.dart';
import 'package:instaa/myProfile.dart';
import 'package:instaa/searchScreen.dart';
import 'package:provider/provider.dart';
import '../providers/userProvider.dart';
import '../welcome.dart';

class MobileScreen extends StatefulWidget {
  const MobileScreen({Key? key}) : super(key: key);

  @override
  State<MobileScreen> createState() => _MobileScreenState();
}

class _MobileScreenState extends State<MobileScreen> {
  int page = 0;
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  _onPageChanged(int pagse) {
    setState(() {
      page = pagse;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PageView(
          children: [
            FeeScreen(),
            SearchScreen(),
            AddPost(),
            Center(child: Text('Favourite')),
            MyProfile()
          ],
          controller: pageController,
          onPageChanged: _onPageChanged,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color.fromARGB(255, 30, 30, 30),
        onTap: navigationTapped,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: page == 0
                    ? Colors.white
                    : Color.fromARGB(255, 145, 145, 145),
              ),
              label: ''),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
                color: page == 1
                    ? Colors.white
                    : Color.fromARGB(255, 145, 145, 145),
              ),
              label: ''),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.add,
                color: page == 2
                    ? Colors.white
                    : Color.fromARGB(255, 145, 145, 145),
              ),
              label: ''),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.favorite,
                color: page == 3
                    ? Colors.white
                    : Color.fromARGB(255, 145, 145, 145),
              ),
              label: ''),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                color: page == 4
                    ? Colors.white
                    : Color.fromARGB(255, 145, 145, 145),
              ),
              label: ''),
        ],
      ),
    );
  }
}
