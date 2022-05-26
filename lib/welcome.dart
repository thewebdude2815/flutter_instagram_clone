import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instaa/model/userModel.dart';
import 'package:instaa/providers/userProvider.dart';
import 'package:provider/provider.dart';

class Welcome extends StatefulWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    // final UserProvider userModel = Provider.of<UserProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: Text(''),
      ),
    );
  }
}
