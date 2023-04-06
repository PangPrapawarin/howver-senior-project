import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:howver/controllers/comment_controller.dart';
import 'package:howver/controllers/profile_controller.dart';
import 'package:howver/utils/constants.dart';

import '../utils/colors.dart';

class CommentSheet extends StatefulWidget {
  final String id;

  const CommentSheet({
    super.key,
    required this.id,
  });

  @override
  State<CommentSheet> createState() => _CommentSheetState();
}

class _CommentSheetState extends State<CommentSheet> {
  final TextEditingController _commentController = TextEditingController();
  CommentController commentController = Get.put(CommentController());
  final ProfileController _profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    commentController.updatePostId(widget.id);

    return GetBuilder(
        init: CommentController(),
        builder: (controller) {
          return Obx(
            () => Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Spacer(),
                      Text('${controller.comments.length} comments'),
                      const Spacer(),
                      //close icon
                      GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: const Icon(
                          Icons.close,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      reverse: true,
                      shrinkWrap: true,
                      itemCount: controller.comments.length,
                      itemBuilder: (context, index) {
                        var comment = controller.comments[index];
                        return ListTile(
                          leading: CircleAvatar(
                            radius: 25,
                            backgroundImage: NetworkImage(comment.profilePhoto),
                            backgroundColor: const Color(0xffB2CBE5),
                          ),
                          title: Text(
                            comment.username,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          subtitle: Text(
                            comment.comment,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          trailing: Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  commentController.likeAComment(comment.id);
                                },
                                child: Icon(
                                  comment.likes
                                          .contains(authController.user.uid)
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: comment.likes
                                          .contains(authController.user.uid)
                                      ? Colors.red
                                      : Colors.black,
                                ),
                              ),
                              Text(comment.likes.length.toString()),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                            _profileController.user['profilePhoto'] ?? ''),
                      ),
                      title: TextField(
                        onSubmitted: (value) {
                          var c = value;
                          controller.postComment(c);
                          _commentController.clear();
                        },
                        controller: _commentController,
                        decoration: const InputDecoration(
                          hintText: 'Add a comment...',
                          border: InputBorder.none,
                        ),
                      ),
                      trailing: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0.0,
                          backgroundColor: AppColors.buttonColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          var c = _commentController.text;
                          controller.postComment(c);
                          _commentController.clear();
                        },
                        child: const Text('SEND'),
                      )),
                ],
              ),
            ),
          );
        });
  }
}
