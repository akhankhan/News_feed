import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/user.dart';

class AuthenticationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> signUpWithEmailAndPassword(context, UserModel userModel) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: userModel.email.toString(),
        password: userModel.password.toString(),
      );
    } catch (e) {
      String errorMessage = "Error during sign up: $e";

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          duration: const Duration(seconds: 2), // Adjust the duration as needed
        ),
      );
    }
  }

  Future<bool> signInWithEmailAndPassword(
      BuildContext context, String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return true;
    } on FirebaseAuthException catch (e) {
      String errorMessage = "";
      if (e.code == 'user-not-found') {
        errorMessage = 'No user found with that email.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Wrong password provided for that user.';
      } else {
        errorMessage = 'Error during login: $e';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          duration: const Duration(seconds: 3), // Adjust the duration as needed
        ),
      );

      return false;
    } catch (e) {
      String errorMessage = "Unexpected error during login: $e";

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          duration: const Duration(seconds: 3), // Adjust the duration as needed
        ),
      );

      return false;
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
    // Trigger the sign-in flow
    GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

    // If sign-in is successful, obtain the authentication token
    if (googleUser != null) {
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Use the token to authenticate with Firebase
      final authResult = await _auth.signInWithCredential(
        GoogleAuthProvider.credential(
            idToken: googleAuth.idToken, accessToken: googleAuth.accessToken),
      );

      // Return the user credentials
      return authResult;
    }

    // Sign-in failed
    return null;
  }
}
