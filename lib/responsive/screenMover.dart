import 'dart:async';

import 'package:flutter/material.dart';

class ScreenMover extends StatefulWidget {
  Widget mobileScreen;
  ScreenMover({required this.mobileScreen});

  @override
  State<ScreenMover> createState() => _ScreenMoverState();
}

class _ScreenMoverState extends State<ScreenMover> {
  @override
  void initState() {
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) {
        return widget.mobileScreen;
      }));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(child: Center(child: CircularProgressIndicator())),
    );
  }
}
