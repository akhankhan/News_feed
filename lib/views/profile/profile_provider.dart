import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news_feed/services/database_service.dart';
import 'package:news_feed/views/widgets/snabar.dart';

import '../../models/user.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileProvider with ChangeNotifier {
  TextEditingController nameController = TextEditingController();
  TextEditingController email = TextEditingController();
  File selectedImage = File('');
  bool isLoading = false;

  final _databaseServices = DatabaseServices();
  final formkey = GlobalKey<FormState>();

  ProfileProvider(userModel) {
    showUserData(userModel);
  }

  void showUserData(UserModel userModel) {
    nameController.text = userModel.name.toString();
    email.text = userModel.email.toString();
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

  Future<void> submitUpdate(context) async {
    if (formkey.currentState!.validate()) {
      if (selectedImage.path.isNotEmpty) {
        isLoading = true;
        notifyListeners();
        String? imageStoredUrl = await _uploadImageToStorage();
        await _databaseServices.updateUserData(
            nameController.text, imageStoredUrl!);
      } else {
        await _databaseServices.updateUserData(nameController.text, '');
      }

      isLoading = false;
      notifyListeners();
      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Update',
          message:
              'Data is update successfully',
          contentType: ContentType.success,
        ),
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
    }
  }

  Future<String?> _uploadImageToStorage() async {
    String userProfileName = 'userProfile.jpg';

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
}
