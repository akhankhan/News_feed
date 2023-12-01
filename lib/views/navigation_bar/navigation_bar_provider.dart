import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../authentication/login_screen.dart';

class NavigationBarProvider with ChangeNotifier {
  String name = '';
  String email = '';

  NavigationBarProvider();
  // void getUserData() {
  //   log("check id:${FirebaseAuth.instance.currentUser!.uid.toString()}");
  // }

  void logout(context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }
}
