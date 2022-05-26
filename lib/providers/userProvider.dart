// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instaa/logic/authFunctions.dart';
import 'package:provider/provider.dart';

import '../model/userModel.dart';

class UserProvider with ChangeNotifier {
  UserModel? _userModel;

  Future<void> refreshUser() async {
    UserModel user = await getUserDetails();
    _userModel = user;

    notifyListeners();
  }

  UserModel get getUser => _userModel!;
}
