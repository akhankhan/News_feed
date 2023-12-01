import 'package:flutter/material.dart';
import 'package:news_feed/views/widgets/button.dart';
import 'package:news_feed/views/widgets/text_field.dart';
import 'package:provider/provider.dart';

import 'feed_provider.dart';

class NewPostScreen extends StatelessWidget {
  const NewPostScreen({super.key, required this.valueModel});
  final FeedProvider valueModel;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text("Create Post"),
        ),
        body: ChangeNotifierProvider(
          create: (context) => FeedProvider(),
          child: Consumer<FeedProvider>(builder: (context, value, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: TextFieldWidget(
                    controller: value.titleController,
                    hintText: 'Enter Text',
                    obscureText: false,
                    maxLines: 4,
                    validator: (value) {},
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 15, left: 25),
                  child: Text(
                    'Optional:',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 17,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: GestureDetector(
                    onTap: () => value.pickImage(),
                    child: Container(
                      height: 180,
                      margin: const EdgeInsets.symmetric(horizontal: 25),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey[200],
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 1,
                            offset: Offset(0, 0.5),
                          )
                        ],
                      ),
                      child: Center(
                        child: value.selectedImage.path.isNotEmpty
                            ? Image.file(
                                value.selectedImage,
                                fit: BoxFit.cover,
                                height: 180,
                                width: double.infinity,
                              )
                            : const Text(
                                'Select Image',
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 18),
                              ),
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: ButtonWidget(
                    onTap: () {
                      value.createPost(context);
                    },
                    title: 'Create',
                    isLoading: value.isLoading,
                  ),
                ),
              ],
            );
          }),
        ));
  }
}
