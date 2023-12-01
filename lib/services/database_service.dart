import 'dart:developer';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:news_feed/models/post.dart';

import '../models/comments.dart';
import '../models/user.dart';

class DatabaseServices {
  Future<bool> storeUserData(UserModel userModel) async {
    try {
      final String uid = FirebaseAuth.instance.currentUser!.uid.toString();
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'id': uid,
        'userName': userModel.name,
        'email': userModel.email,
        'userProfile': userModel.userProfile ?? '',
      });

      return true;
    } catch (error) {
      print('Error storing user data: $error');
      return false;
    }
  }

  Future<UserModel?> getUserData() async {
    final String uid = FirebaseAuth.instance.currentUser!.uid.toString();
    final userDocRef =
        FirebaseFirestore.instance.collection('users').doc(uid).snapshots();
    userDocRef.listen((userDoc) {
      if (userDoc.exists) {
        UserModel(
          name: userDoc['userName'],
          email: userDoc['email'],
          userProfile: userDoc['userProfile'],
        );
      }
    });
    return null;
  }

  Future<bool> updateUserData(String name, String userProfile) async {
    try {
      final String uid = FirebaseAuth.instance.currentUser!.uid;

      Map<String, dynamic> updateData = {
        'userName': name,
      };

      if (userProfile.isNotEmpty) {
        updateData['userProfile'] = userProfile;
      }

      await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .update(updateData);

      return true;
    } catch (error) {
      print('Error updating user data: $error');
      return false;
    }
  }

  Future<void> createPost(Post postModel) async {
    final String uid = FirebaseAuth.instance.currentUser!.uid;

    final DocumentReference<Map<String, dynamic>> documentReference =
        FirebaseFirestore.instance.collection("Posts").doc();
    // store in model
    postModel.uid = uid;
    postModel.id = documentReference.id;
    await documentReference.set(postModel.toJson());
  }

  Stream<List<Post>> getPostsStream() {
    try {
      final Query<Map<String, dynamic>> query =
          FirebaseFirestore.instance.collection("Posts");

      return query.snapshots().map((querySnapshot) {
        List<Post> posts = querySnapshot.docs.map((doc) {
          return Post.fromJson(doc.data());
        }).toList();

        return posts;
      });
    } catch (e) {
      print("Error getting posts: $e");
      return Stream.value([]);
    }
  }

  Future<void> toggleLikeForPost(String postId) async {
    try {
      final String uid = FirebaseAuth.instance.currentUser!.uid;

      final DocumentReference<Map<String, dynamic>> postReference =
          FirebaseFirestore.instance.collection("Posts").doc(postId);

      // Check if the user has already liked the post
      final DocumentSnapshot<Map<String, dynamic>> postSnapshot =
          await postReference.get();

      final List<dynamic>? likes = postSnapshot.data()?['likes'];

      if (likes != null && likes.contains(uid)) {
        // If the user has already liked the post, remove the like
        await postReference.update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        // If the user has not liked the post, add the like
        await postReference.update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      print("Error toggling like for post: $e");
      // Handle the error as needed
    }
  }

  Future<bool> checkLikeForPost(String postId) async {
    try {
      final String uid = FirebaseAuth.instance.currentUser!.uid;

      final DocumentReference<Map<String, dynamic>> postReference =
          FirebaseFirestore.instance.collection("Posts").doc(postId);

      // Check if the user has already liked the post
      final DocumentSnapshot<Map<String, dynamic>> postSnapshot =
          await postReference.get();

      final List<dynamic>? likes = postSnapshot.data()?['likes'];

      if (likes != null && likes.contains(uid)) {
        // If the user has already liked the post, remove the like
        return true;
      } else {
        // If the user has not liked the post, add the like
        return false;
      }
    } catch (e) {
      print("Error toggling like for post: $e");
      return false;
      // Handle the error as needed
    }
  }

  Future<void> sendComment(String postId, CommentModel comment) async {
    try {
      final String uid = FirebaseAuth.instance.currentUser!.uid;

      final postReference = FirebaseFirestore.instance
          .collection("Posts")
          .doc(postId)
          .collection('Comments')
          .doc();

      comment.id = postReference.id.toString();
      comment.uid = uid.toString();
      comment.postId = postId;
      comment.timestamp = FieldValue.serverTimestamp();
      postReference.set(comment.toJson());
    } catch (e) {
      print("Error toggling like for post: $e");
    }
  }

  Stream<List<CommentModel>> getComments(postId) {
    try {
      final Query<Map<String, dynamic>> query = FirebaseFirestore.instance
          .collection("Posts")
          .doc(postId)
          .collection('Comments');

      print("post id:$postId");

      return query
          .orderBy('timestamp', descending: true)
          .snapshots()
          .map((querySnapshot) {
        log("check comm:$querySnapshot");
        List<CommentModel> comment = querySnapshot.docs.map((doc) {
          return CommentModel.fromJson(doc.data());
        }).toList();

        return comment;
      });
    } catch (e) {
      print("Error getting posts: $e");
      return Stream.value([]);
    }
  }

  Future<void> addReplay(
    String postId,
    commentId,
    CommentModel comment,
  ) async {
    try {
      final String uid = FirebaseAuth.instance.currentUser!.uid;

      final replayReference = FirebaseFirestore.instance
          .collection("Posts")
          .doc(postId)
          .collection('Comments')
          .doc(commentId)
          .collection('replies')
          .doc();

      comment.id = replayReference.id.toString();
      comment.uid = uid.toString();
      comment.postId = postId;
      comment.commentId = commentId;
      comment.timestamp = FieldValue.serverTimestamp();
      replayReference.set(comment.toJson(true));
    } catch (e) {
      print("Error toggling like for post: $e");
    }
  }

  Stream<List<CommentModel>> getReplayComments(postId, commentId) {
    try {
      final Query<Map<String, dynamic>> query = FirebaseFirestore.instance
          .collection("Posts")
          .doc(postId)
          .collection('Comments')
          .doc(commentId)
          .collection('replies');

      print("post id:$postId");

      return query
          .orderBy('timestamp', descending: true)
          .snapshots()
          .map((querySnapshot) {
        log("check comm:$querySnapshot");
        List<CommentModel> comment = querySnapshot.docs.map((doc) {
          return CommentModel.fromJson(doc.data());
        }).toList();

        return comment;
      });
    } catch (e) {
      print("Error getting posts: $e");
      return Stream.value([]);
    }
  }
}
