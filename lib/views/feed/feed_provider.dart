import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:intl/intl.dart';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:news_feed/services/database_service.dart';

import '../../models/comments.dart';
import '../../models/post.dart';
import '../../models/user.dart';

class FeedProvider with ChangeNotifier {
  UserModel? userModel = UserModel();
  CommentModel commentModel = CommentModel();
  Post postModel = Post();

  final _databaseServices = DatabaseServices();
  final StreamController<UserModel?> _userController =
      StreamController<UserModel?>.broadcast();

  Stream<UserModel?> get userDataStream => _userController.stream;

  TextEditingController titleController = TextEditingController();
  TextEditingController commentController = TextEditingController();

  File selectedImage = File('');

  int postLength = 0;
  int commentLength = 0;
  int replayCommentLength = 0;

  bool isLoading = false;
  List<bool> isliked = [];
  List<bool> isShowComment = [];
  List comments = [];
  List<bool> isRepaly = [];

  late FocusNode myFocusNode;

  String commentId = '';
  String commentLenght = '';

  String commentIdShow = '';
  List isCommentShow = [];

  List commendIdByUnique = [];

  FeedProvider() {
    getUserData();
    getPosts();
    onFocusNode();
  }

  void isShowUniqueCommentToggle(index, id) {
    commendIdByUnique[index] = id;
    notifyListeners();
    print('sub id:$commendIdByUnique');
  }

  void isShowCommentToggle(index, id) {
    isCommentShow[index] = true;
    notifyListeners();
    print('sub comment:$isCommentShow');
  }

  // Future<void> getUserData() async {
  //   userModel = await _databaseServices.getUserData();
  //   notifyListeners();
  // }

  Future<void> getUserData() async {
    final String uid = FirebaseAuth.instance.currentUser!.uid.toString();
    final DocumentReference<Map<String, dynamic>> userDocRef =
        FirebaseFirestore.instance.collection('users').doc(uid);

    userDocRef.snapshots().listen((userDoc) {
      //log("checking..${userDoc['userName']}");
      if (userDoc.exists) {
        userModel = UserModel(
          name: userDoc['userName'],
          email: userDoc['email'],
          userProfile: userDoc['userProfile'],
        );

        notifyListeners();
      }
    });
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();

    try {
      XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        selectedImage = File(pickedFile.path);
      } else {}
      notifyListeners();
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<void> createPost(context) async {
    isLoading = true;
    notifyListeners();
    postModel.title = titleController.text;
    postModel.dateTime = DateTime.now().toString();
    postModel.userName = userModel!.name.toString();
    postModel.userPicture = userModel!.userProfile.toString();

    if (selectedImage.path.isNotEmpty) {
      String? imagePath = await _uploadPostImage();
      if (imagePath != null) {
        postModel.image = imagePath;
        await _databaseServices.createPost(postModel);
        isLoading = false;
        notifyListeners();
      }
    } else {
      postModel.image = '';
      await _databaseServices.createPost(postModel);
      isLoading = false;
      notifyListeners();
    }

    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: 'Post',
        message: 'Post is create successfully',
        contentType: ContentType.success,
      ),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);

    clearDataOnScreen();
  }

  void clearDataOnScreen() {
    selectedImage = File('');
    titleController.text = '';
  }

  Future<String?> _uploadPostImage() async {
    int number = generateFourDigitRandomNumber();
    String userProfileName = 'post${number.toString()}.jpg';

    final uid = FirebaseAuth.instance.currentUser!.uid;
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference storageReference =
        storage.ref().child(uid).child(userProfileName);

    UploadTask uploadTask = storageReference.putFile(File(selectedImage.path));

    TaskSnapshot snapshot = await uploadTask;
    if (snapshot.state == TaskState.success) {
      String downloadUrl = await storageReference.getDownloadURL();
      return downloadUrl;
    } else {
      return null;
    }
  }

  int generateFourDigitRandomNumber() {
    Random random = Random();
    return random.nextInt(9000) + 1000;
  }

  late Stream<List<Post>> data;

  Future<void> getPosts() async {
    try {
      data = _databaseServices.getPostsStream();
      // get posts like

      //

      data.listen((List<Post> posts) async {
        //  isliked = List.filled(posts.length, false); // Update isliked
        isliked = List.filled(posts.length, false);
        isShowComment = List.filled(posts.length, false);

        postLength = posts.length;

        for (int i = 0; i < posts.length; i++) {
          isliked[i] =
              await _databaseServices.checkLikeForPost(posts[i].id.toString());
          print("Post ID: $isliked");
        }
        notifyListeners();
      });
    } catch (e) {
      print("Error getting posts: $e");
    }
    notifyListeners();
  }

  String formateDateTime(date) {
    DateTime dateTime = DateTime.parse(date);

    String formattedDateTime = DateFormat('MMM d, y h:mm a').format(dateTime);

    return formattedDateTime;
  }

  void setD(index) {
    isliked[index] = false;
    notifyListeners();
  }

  void setLike(int index) {
    if (index >= 0 && index < isliked.length) {
      isliked[index] = !isliked[index];
    } else {
      isliked.add(true);
    }
    notifyListeners();
  }

  Future<void> setLikeToDatabase(postId) async {
    await _databaseServices.toggleLikeForPost(postId);
  }

  Future<void> sendComment(postId) async {
    if (!isRepaly.contains(true)) {
      commentModel.name = userModel!.name.toString();
      commentModel.userProfile = userModel!.userProfile.toString();
      commentModel.comment = commentController.text.toString();
      commentModel.dateTime = DateTime.now().toString();
      await _databaseServices.sendComment(postId, commentModel);
      await getComments(postId);
      commentController.text = '';

      print("comment send");
      notifyListeners();
    } else {
      print("replay send");

      commentModel.name = userModel!.name.toString();
      commentModel.userProfile = userModel!.userProfile.toString();
      commentModel.comment = commentController.text.toString();
      commentModel.dateTime = DateTime.now().toString();
      notifyListeners();
      replayCommint(postId, commentId, commentModel);
    }
  }

  late Stream<List<CommentModel>> commentData;
  late Stream<List<CommentModel>> replayCommentData;
  List<CommentModel> commentsList = [];
  List<CommentModel> replayCommentsList = [];

  //!
  List commentsIddd = [];

  Future<void> getComments(postId) async {
    print("checkk");
    commentData = _databaseServices.getComments(postId);
    commentData.listen((List<CommentModel> comment) async {
      isRepaly = List.filled(comment.length, false);
      isCommentShow = List.filled(comment.length, false);
      commendIdByUnique = List.filled(comment.length, false);

      commentLength = comment.length;

      commentsList = comment;

      for (int i = 0; i < comment.length; i++) {
        commentsIddd.add(comment[i].id);
        await getReplayComments(postId, comment[i].id);

        // print('abbb${replayCommentsList[i].comment}');
      }
      notifyListeners();
      print('cccccc:${commentsIddd}');
    });
  }

  Future<void> getReplayComments(postId, commentId) async {
    replayCommentData = _databaseServices.getReplayComments(postId, commentId);
    replayCommentData.listen((List<CommentModel> replayComment) async {
      replayCommentsList = replayComment;

      commentLenght = replayComment.length.toString();
      for (int i = 0; i < replayComment.length; i++) {
        print('abbb22${replayCommentsList[i].comment}');
      }
      notifyListeners();
    });
  }

  void toggleComment(index) {
    isShowComment = List.filled(postLength, false);
    isRepaly = List.filled(postLength, false);

    isShowComment[index] = !isShowComment[index];
    print("ccc:$isShowComment");
    notifyListeners();
  }

  Future<void> replayCommint(postId, commentId, commentModel) async {
    _databaseServices.addReplay(postId, commentId, commentModel);
  }

  void toggleIsReplay(int index) {
    isRepaly = List.filled(commentLength, false);

    isRepaly[index] = !isRepaly[index];
    onFocusNode();
    notifyListeners();
  }

  void resetSelectReplay() {
    isRepaly = List.filled(commentLength, false);
    notifyListeners();
  }

  void onFocusNode() {
    myFocusNode = FocusNode();
    notifyListeners();
  }

  String formatTimeDifference(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString);
    DateTime now = DateTime.now();
    Duration difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return DateFormat('yyyy-MM-dd')
          .format(dateTime); // Display full date if more than 1 day
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else {
      return 'just now';
    }
  }
}
