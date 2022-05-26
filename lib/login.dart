// ignore_for_file: sort_child_properties_last, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instaa/logic/authFunctions.dart';
import 'package:instaa/responsive/mobileScreen.dart';
import 'package:instaa/signup.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isLoading = false;
  TextEditingController emailC = TextEditingController();
  TextEditingController passC = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Flexible(
                child: Container(),
                flex: 2,
              ),
              SvgPicture.asset(
                'image/instagram.svg',
                height: 100,
                color: Colors.white,
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: emailC,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Color.fromARGB(255, 114, 114, 114),
                    hintText: 'Enter Your Email',
                    hintStyle: TextStyle(color: Colors.black)),
              ),
              SizedBox(
                height: 30,
              ),
              TextField(
                controller: passC,
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Color.fromARGB(255, 114, 114, 114),
                  hintText: 'Enter Your Password',
                  hintStyle: TextStyle(color: Colors.black),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              GestureDetector(
                onTap: () async {
                  setState(() {
                    isLoading = true;
                  });
                  String reuslt = await loginFunction(emailC.text, passC.text);
                  if (reuslt == 'done') {
                    setState(() {
                      isLoading = true;
                      Navigator.push(context, MaterialPageRoute(builder: (_) {
                        return MobileScreen();
                      }));
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
                        : const Text('Login'),
                  ),
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 101, 157, 254),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) {
                      return Signup();
                    }));
                  },
                  child: Text('Sign Up Instead.')),
              Flexible(
                child: Container(),
                flex: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
