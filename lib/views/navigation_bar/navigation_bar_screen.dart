import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:news_feed/views/feed/feed_provider.dart';
import 'package:news_feed/views/profile/profile_sceen.dart';
import 'package:provider/provider.dart';

import '../../models/user.dart';
import '../widgets/image.dart';
import 'navigation_bar_provider.dart';

class NavigationBarScreen extends StatelessWidget {
  const NavigationBarScreen({super.key, this.userModel, this.feedProvider});
  final UserModel? userModel;
  final FeedProvider? feedProvider;
  @override
  Widget build(BuildContext context) {
    // log("checking pro${userModel!.userProfile.toString()}");
    return ChangeNotifierProvider(
        create: (context) => NavigationBarProvider(),
        child: Consumer<NavigationBarProvider>(
            builder: (context, valueModel, child) {
          return Drawer(
            child: ListView(
              // Remove padding
              padding: EdgeInsets.zero,
              children: [
                UserAccountsDrawerHeader(
                  accountName: Text(userModel!.name ?? 'userName'),
                  accountEmail: Text(userModel!.email ?? 'email'),
                  currentAccountPicture: CircleAvatar(
                    child: userModel!.userProfile!.isNotEmpty
                        ? ClipOval(
                            child: ImageWidget(
                            imageUrl: userModel!.userProfile.toString(),
                            width: 120,
                            height: 120,
                          ))
                        : const Icon(
                            Icons.person,
                            size: 40,
                          ),
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.black87,
                    // image: DecorationImage(
                    //   fit: BoxFit.fill,
                    //   image: NetworkImage(
                    //     'https://oflutter.com/wp-content/uploads/2021/02/profile-bg3.jp',
                    //   ),
                    // ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.share),
                  title: const Text('Share'),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Update profile'),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProfileScreen(userModel: userModel!),
                        ));
                  },
                ),
                const Divider(),
                ListTile(
                  title: const Text('Logout'),
                  leading: const Icon(Icons.logout),
                  onTap: () {
                    valueModel.logout(context);
                  },
                ),
              ],
            ),
          );
        }));
  }
}
