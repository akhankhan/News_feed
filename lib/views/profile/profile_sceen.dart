import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:news_feed/models/user.dart';
import 'package:news_feed/views/profile/profile_provider.dart';
import 'package:news_feed/views/widgets/button.dart';
import 'package:news_feed/views/widgets/text_field.dart';
import 'package:provider/provider.dart';

import '../feed/feed_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, required this.userModel, this.feedProvider});
  final UserModel userModel;
  final FeedProvider? feedProvider;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ProfileProvider(userModel),
        child: Consumer<ProfileProvider>(builder: (context, value, child) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.black,
              title: const Text("User Profile"),
            ),
            body: Form(
              key: value.formkey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Center(
                      child: GestureDetector(
                        onTap: () {
                          value.pickImage();
                        },
                        child: Stack(
                          children: [
                            Container(
                              width: 120,
                              height: 120,
                              decoration: const BoxDecoration(
                                color: Colors.black,
                                shape: BoxShape.circle,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: value.selectedImage.path.isEmpty
                                    ? userModel.userProfile!.isEmpty
                                        ? const Icon(
                                            Icons.person,
                                            color: Colors.white,
                                            size: 50,
                                          )
                                        : Image.network(
                                            '${userModel.userProfile}',
                                            fit: BoxFit.cover)
                                    : Image.file(value.selectedImage,
                                        fit: BoxFit.cover),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 10,
                              child: Container(
                                width: 30,
                                height: 30,
                                decoration: const BoxDecoration(
                                  color: Colors.black,
                                  shape: BoxShape.circle,
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.camera_alt,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  TextFieldWidget(
                      controller: value.nameController,
                      hintText: 'Enter your name',
                      obscureText: false,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a userName';
                        }
                      }),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFieldWidget(
                      controller: value.email,
                      hintText: 'Enter your email',
                      obscureText: false,
                      enable: false,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a email';
                        }
                      }),
                  const SizedBox(
                    height: 40,
                  ),
                  ButtonWidget(
                    onTap: () {
                      value.submitUpdate(context);
                    },
                    title: 'Update',
                    isLoading: value.isLoading,
                  ),
                ],
              ),
            ),
          );
        }));
  }
}
