import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:instaa/providers/userProvider.dart';
import 'package:instaa/responsive/mobileScreen.dart';
import 'package:instaa/responsive/responsiveLayout.dart';
import 'package:instaa/responsive/webScreen.dart';
import 'package:provider/provider.dart';

import 'login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const Insta());
}

class Insta extends StatelessWidget {
  const Insta({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => UserProvider())],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData.dark().copyWith(
              scaffoldBackgroundColor: Color.fromARGB(255, 30, 30, 30)),
          home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ResponsiveLayout(
                    mobileScreen: MobileScreen(), webScreen: WebScreen());
              } else {
                return const Login();
              }
            },
          )),
    );
  }
}
