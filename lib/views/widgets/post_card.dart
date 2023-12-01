import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:icofont_flutter/icofont_flutter.dart';
import 'package:news_feed/views/widgets/image.dart';

import '../../models/comments.dart';
import '../feed/feed_provider.dart';

class PostCardWidget extends StatelessWidget {
  const PostCardWidget({
    super.key,
    required this.title,
    required this.name,
    required this.imagePath,
    required this.dateTime,
    this.userPic,
    required this.likeOnTap,
    this.isLiked,
    this.totalLikes,
    this.onCommentTap,
    this.sendCommentTap,
    this.controller,
    this.commentsList,
    this.postId,
    this.isShowCommint,
    required this.isReplay,
    this.onTapReplay,
    required this.model,
  });
  final String? title;
  final String? name;
  final String? imagePath;
  final String? dateTime;
  final String? userPic;
  final dynamic likeOnTap;
  final dynamic onCommentTap;
  final dynamic sendCommentTap;
  final dynamic onTapReplay;
  final bool? isLiked;
  final String? totalLikes;
  final TextEditingController? controller;
  final List<CommentModel>? commentsList;
  final String? postId;
  final bool? isShowCommint;
  final List<bool> isReplay;
  final FeedProvider model;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              boxShadow: const [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 0.3,
                  offset: Offset(-0.1, 0.1),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10, top: 10),
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: ImageWidget(
                                  imageUrl: userPic.toString(),
                                  width: 50,
                                  height: 50),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name ?? 'Name',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                              Text(title ?? 'title'),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Text(dateTime.toString(),
                          style: const TextStyle(
                            fontSize: 9,
                            color: Colors.grey,
                          )),
                    )
                  ],
                ),
                imagePath!.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Container(
                          height: 180,
                          width: double.infinity,
                          color: Colors.grey,
                          child: ImageWidget(
                              imageUrl: imagePath.toString(),
                              width: double.infinity,
                              height: 180),
                        ),
                      )
                    : Container(
                        padding: const EdgeInsets.only(bottom: 15),
                      ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 0.2,
                    color: Colors.grey,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: GestureDetector(
                    onTap: onCommentTap,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          children: [
                            Icon(
                              Icons.comment,
                              color: Colors.black54,
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                              'Comments',
                              style: TextStyle(
                                fontSize: 10,
                              ),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                          ],
                        ),
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: likeOnTap,
                          child: Column(
                            children: [
                              Icon(
                                IcoFontIcons.like,
                                color: isLiked! ? Colors.blue : Colors.grey,
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Text(
                                totalLikes.toString(),
                                style: const TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                isShowCommint == true
                    ? SizedBox(
                        height: 200,
                        width: double.infinity,
                        child: Stack(
                          children: [
                            commentsList!.isEmpty
                                ? const SizedBox()
                                : postId == commentsList![0].postId
                                    ? SizedBox(
                                        height: 130,
                                        child: ListView.builder(
                                            itemCount: commentsList!.length,
                                            shrinkWrap: true,
                                            itemBuilder: (context, index) {
                                              return GestureDetector(
                                                behavior:
                                                    HitTestBehavior.opaque,
                                                onTap: () {
                                                  model.resetSelectReplay();
                                                },
                                                child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 20,
                                                        vertical: 4),
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5.0),
                                                      margin: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 4.0),
                                                      // decoration: BoxDecoration(
                                                      //   border: Border.all(
                                                      //       color: Colors.grey),
                                                      //   borderRadius:
                                                      //       BorderRadius.circular(
                                                      //           8.0),
                                                      // ),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Container(
                                                                    width: 40,
                                                                    height: 40,
                                                                    decoration:
                                                                        const BoxDecoration(
                                                                      color: Colors
                                                                          .black,
                                                                      shape: BoxShape
                                                                          .circle,
                                                                    ),
                                                                    child:
                                                                        ClipRRect(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              25),
                                                                      child:
                                                                          ImageWidget(
                                                                        imageUrl: commentsList![index]
                                                                            .userProfile
                                                                            .toString(),
                                                                        width:
                                                                            40,
                                                                        height:
                                                                            40,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 6,
                                                                  ),
                                                                  Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                        commentsList![index]
                                                                            .name
                                                                            .toString(),
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Colors.grey,
                                                                          fontSize: model.isRepaly[index]
                                                                              ? 16
                                                                              : 14,
                                                                        ),
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            5,
                                                                      ),
                                                                      Text(commentsList![
                                                                              index]
                                                                          .comment
                                                                          .toString()),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                              const Text(
                                                                '',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 10,
                                                                  color: Colors
                                                                      .grey,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    left: 45,
                                                                    top: 10),
                                                            child: Row(
                                                              children: [
                                                                Text(
                                                                    model.formatTimeDifference(commentsList![
                                                                            index]
                                                                        .dateTime
                                                                        .toString()),
                                                                    style:
                                                                        const TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      color: Colors
                                                                          .grey,
                                                                    )),
                                                                const SizedBox(
                                                                  width: 15,
                                                                ),
                                                                GestureDetector(
                                                                  onTap: () {
                                                                    model.commentId =
                                                                        commentsList![index]
                                                                            .id
                                                                            .toString();
                                                                    model.toggleIsReplay(
                                                                        index);
                                                                    model
                                                                        .myFocusNode
                                                                        .requestFocus();

                                                                    log("check replay Id:${model.commentId}");
                                                                  },
                                                                  child: Text(
                                                                      'Replay',
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize: model.isRepaly[index]
                                                                            ? 15
                                                                            : 12,
                                                                        color: model.isRepaly[index] ==
                                                                                true
                                                                            ? Colors.blue
                                                                            : Colors.grey,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                      )),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 10,
                                                          ),
                                                          GestureDetector(
                                                            child: const Row(
                                                              children: [
                                                                Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              45),
                                                                  child:
                                                                      SizedBox(
                                                                    width: 40,
                                                                    height: 1,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 10,
                                                                ),
                                                                // GestureDetector(
                                                                //   behavior:
                                                                //       HitTestBehavior
                                                                //           .opaque,
                                                                //   onTap: () {
                                                                //     model.commentIdShow =
                                                                //         commentsList![index]
                                                                //             .id
                                                                //             .toString();

                                                                //     model.isShowCommentToggle(
                                                                //         index,
                                                                //         model
                                                                //             .commentIdShow = commentsList![
                                                                //                 index]
                                                                //             .id
                                                                //             .toString());

                                                                //     model.isShowUniqueCommentToggle(
                                                                //         index,
                                                                //         commentsList![index]
                                                                //             .id
                                                                //             .toString());
                                                                //   },
                                                                //   child: Text(
                                                                //     'View ${model.commentLenght.toString()} replies',
                                                                //     style:
                                                                //         const TextStyle(
                                                                //       color: Colors
                                                                //           .grey,
                                                                //       fontSize:
                                                                //           13,
                                                                //     ),
                                                                //   ),
                                                                // )
                                                              ],
                                                            ),
                                                          ),
                                                          ListView.builder(
                                                              physics:
                                                                  const NeverScrollableScrollPhysics(),
                                                              itemCount: model
                                                                  .replayCommentsList
                                                                  .length,
                                                              shrinkWrap: true,
                                                              itemBuilder:
                                                                  ((context,
                                                                      indexx) {
                                                                log("sub c:${model.replayCommentsList[indexx].commentId}");
                                                                return model
                                                                            .replayCommentsList[
                                                                                indexx]
                                                                            .commentId ==
                                                                        commentsList![index]
                                                                            .id
                                                                    ? Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Row(
                                                                            children: [
                                                                              Container(
                                                                                margin: const EdgeInsets.only(
                                                                                  top: 5,
                                                                                  left: 30,
                                                                                ),
                                                                                width: 40,
                                                                                height: 40,
                                                                                decoration: const BoxDecoration(
                                                                                  color: Colors.grey,
                                                                                  shape: BoxShape.circle,
                                                                                ),
                                                                                child: ClipRRect(
                                                                                  borderRadius: BorderRadius.circular(25),
                                                                                  child: ImageWidget(
                                                                                    imageUrl: model.replayCommentsList[indexx].userProfile.toString(),
                                                                                    width: 40,
                                                                                    height: 40,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              const SizedBox(
                                                                                height: 60,
                                                                              ),
                                                                              Padding(
                                                                                padding: const EdgeInsets.only(left: 10),
                                                                                child: Column(
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    Text(
                                                                                      model.replayCommentsList[indexx].name.toString(),
                                                                                      style: const TextStyle(
                                                                                        color: Colors.grey,
                                                                                      ),
                                                                                    ),
                                                                                    const SizedBox(
                                                                                      height: 3,
                                                                                    ),
                                                                                    Text(
                                                                                      model.replayCommentsList[indexx].comment.toString(),
                                                                                      style: const TextStyle(),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Text(
                                                                            model.formatTimeDifference(
                                                                              model.replayCommentsList[indexx].dateTime.toString(),
                                                                            ),
                                                                            style:
                                                                                const TextStyle(
                                                                              fontSize: 10,
                                                                              color: Colors.grey,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      )
                                                                    : Container();
                                                              })),
                                                        ],
                                                      ),
                                                    )),
                                              );
                                            }),
                                      )
                                    : Container(),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 10, left: 15, right: 15),
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        width: 0.1,
                                        color: Colors.black,
                                      )),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 15),
                                    child: TextField(
                                      focusNode: model.myFocusNode,
                                      controller: controller,
                                      decoration: InputDecoration(
                                        hintText: "Enter Comment",
                                        border: InputBorder.none,
                                        suffixIcon: GestureDetector(
                                            onTap: sendCommentTap,
                                            child: const Icon(Icons.send)),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
