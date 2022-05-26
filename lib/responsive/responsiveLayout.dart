import 'dart:async';

import 'package:flutter/material.dart';
import 'package:instaa/providers/userProvider.dart';
import 'package:instaa/responsive/screenMover.dart';
import 'package:instaa/utils/screenSizes.dart';
import 'package:provider/provider.dart';

class ResponsiveLayout extends StatefulWidget {
  Widget mobileScreen;
  Widget webScreen;
  ResponsiveLayout({required this.mobileScreen, required this.webScreen});

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {
  @override
  void initState() {
    addData();
    super.initState();
  }

  addData() async {
    print('called');
    UserProvider userProvider = Provider.of(context, listen: false);
    await userProvider.refreshUser();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > webScreenSize) {
        return widget.webScreen;
      } else {
        return ScreenMover(
          mobileScreen: widget.mobileScreen,
        );
      }
    });
  }
}
