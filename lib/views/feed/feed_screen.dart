import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:news_feed/views/feed/feed_provider.dart';
import 'package:provider/provider.dart';

import '../../models/post.dart';
import '../navigation_bar/navigation_bar_screen.dart';
import '../widgets/post_card.dart';
import 'new_post_screen.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => FeedProvider(),
        child: Consumer<FeedProvider>(builder: (context, valueModel, child) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.black,
              title: const Text("Feed"),
              // actions: [
              //   Padding(
              //     padding: const EdgeInsets.only(right: 10),
              //     child: GestureDetector(
              //       onTap: () {
              //         // Navigator.push(
              //         //     context,
              //         //     MaterialPageRoute(
              //         //         builder: (context) => const ProfileScreen()));
              //       },
              //       child: Container(
              //         width: 35,
              //         height: 35,
              //         decoration: BoxDecoration(
              //           //  borderRadius: BorderRadius.circular(20),
              //           color: Colors.grey[500],
              //           shape: BoxShape.circle,
              //         ),
              //         child: Center(
              //           child: valueModel.userModel!.userProfile != null
              //               ? ClipRRect(
              //                   borderRadius: BorderRadius.circular(20),
              //                   child: Image.network(
              //                     "${valueModel.userModel!.userProfile}",
              //                     fit: BoxFit.cover,
              //                   ),
              //                 )
              //               : const Icon(Icons.person),
              //         ),
              //       ),
              //     ),
              //   ),
              // ],
            ),
            body: StreamBuilder<List<Post>>(
              stream: valueModel.data,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('No posts available');
                } else {
                  List<Post> posts = snapshot.data!;
                  return ListView.builder(
                      padding: const EdgeInsets.only(bottom: 20),
                      // controller: valueModel.scrollController,
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        log("checkkking${posts[index].totalLikes}");
                        return PostCardWidget(
                          title: posts[index].title,
                          dateTime:
                              valueModel.formateDateTime(posts[index].dateTime),
                          imagePath: posts[index].image,
                          name: posts[index].userName,
                          userPic: posts[index].userPicture,
                          likeOnTap: () async {
                            valueModel.setLike(index);
                            valueModel.setLikeToDatabase(posts[index].id);
                          },
                          isLiked: valueModel.isliked.isEmpty
                              ? false
                              : (index >= 0 &&
                                      index < valueModel.isliked.length)
                                  ? valueModel.isliked[index]
                                  : false,
                          totalLikes: posts[index].totalLikes.toString(),
                          onCommentTap: () {
                            valueModel.toggleComment(index);
                            valueModel.getComments(posts[index].id);
                          },
                          sendCommentTap: () {
                            valueModel.sendComment(posts[index].id);
                          },
                          controller: valueModel.commentController,
                          commentsList: valueModel.commentsList,
                          postId: posts[index].id,
                          isShowCommint: valueModel.isShowComment[index],
                          isReplay: valueModel.isRepaly,
                          onTapReplay: () {
                            //   valueModel.toggleIsReplay();
                          },
                          model: valueModel,
                          
                        );
                        
                      });
                }
              },
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.black,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NewPostScreen(
                              valueModel: valueModel,
                            )));
              },
              child: const Icon(Icons.add),
            ),
            drawer: NavigationBarScreen(userModel: valueModel.userModel),
          );
        }));
  }
}

void _showBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        height: 400,
        color: Colors.white,
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(),
            ],
          ),
        ),
      );
    },
  );
}
