import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:news_feed/services/database_service.dart';

import '../../models/user.dart';
import '../../services/authentication_service.dart';
import '../feed/feed_screen.dart';
import 'login_screen.dart';

class AuthenticationProvider with ChangeNotifier {
  UserModel userModel = UserModel();
  final authenticationService = AuthenticationService();
  final databaseServices = DatabaseServices();
  final formkey = GlobalKey<FormState>();
  final loginFormkey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();

  bool showPassword = true;
  bool showConfrimPassword = true;
  bool isLoading = false;



  Future<void> signIn(context, email, password) async {
    if (loginFormkey.currentState!.validate()) {
      isLoading = true;
      notifyListeners();
      bool isLogin = await authenticationService.signInWithEmailAndPassword(
          context, email, password);

      if (isLogin) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const FeedScreen()));

        isLoading = false;
        notifyListeners();
      }

      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signUp(BuildContext context) async {
    if (formkey.currentState!.validate()) {
      isLoading = true;
      notifyListeners();
      await authenticationService.signUpWithEmailAndPassword(
          context, userModel);
      bool isDataStoreSuccesfully =
          await databaseServices.storeUserData(userModel);
      if (isDataStoreSuccesfully) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Your account register successfully!"),
            duration: Duration(seconds: 2), // Adjust the duration as needed
          ),
        );
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => LoginScreen(
                      email: userModel.email.toString(),
                    )));
        isLoading = false;
        notifyListeners();
      }

      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> googleSignIn(context) async {
    UserCredential? userCredential =
        await authenticationService.signInWithGoogle();

    userModel.email = userCredential!.user!.email.toString();
    userModel.userProfile = userCredential.user!.photoURL.toString();
    userModel.name = userCredential.user!.displayName.toString();

    bool isDataStoreSuccesfully =
        await databaseServices.storeUserData(userModel);

    if (isDataStoreSuccesfully) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const FeedScreen()));
    }
  }

  void toggleShowPasswrod() {
    showPassword = !showPassword;
    notifyListeners();
  }

  void toggleConfrimShowPasswrod() {
    showConfrimPassword = !showConfrimPassword;
    notifyListeners();
  }

  
  
}
