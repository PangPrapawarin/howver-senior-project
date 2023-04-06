import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:howver/controllers/profile_controller.dart';
import 'package:howver/controllers/video_controller.dart';
import 'package:howver/screens/profile/user_videos_screen.dart';
import 'package:howver/utils/colors.dart';

class OthersProfileScreen extends StatefulWidget {
  final String uid;
  const OthersProfileScreen({super.key, required this.uid});

  @override
  State<OthersProfileScreen> createState() => _OthersProfileScreenState();
}

class _OthersProfileScreenState extends State<OthersProfileScreen> {
  var profileController = Get.put(ProfileController());

  @override
  void initState() {
    profileController.updateUserId(widget.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var videoController = Get.put(VideoController());
    videoController.getUserVideos(widget.uid);
    return GetBuilder(
        init: ProfileController(),
        builder: (controller) {
          return Scaffold(
            body: SafeArea(
              child: Column(
                children: [
                  Container(
                    color: AppColors.greyColor,
                    child: Column(
                      children: [
                        SizedBox(height: Get.height * 0.02),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(width: 10),
                            CircleAvatar(
                              radius: 50,
                              backgroundImage: NetworkImage(controller
                                  .otherPersonData!.value.profilePhoto),
                              backgroundColor: const Color(0xffD0FFB3),
                            ),
                            const SizedBox(width: 40),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  controller.otherPersonData!.value.accountName,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  controller.otherPersonData!.value.name,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                  ),
                                ),
                                Row(
                                  children: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        elevation: 0.0,
                                        backgroundColor: controller
                                                        .user['isFollowing'] !=
                                                    null &&
                                                controller.user['isFollowing']
                                            ? AppColors.buttonColor
                                            : Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      onPressed: () {
                                        controller.followUser();
                                      },
                                      child: Text(
                                        controller.user['isFollowing'] !=
                                                    null &&
                                                controller.user['isFollowing']
                                            ? 'FOLLOWING'
                                            : 'FOLLOW',
                                        style: TextStyle(
                                          fontSize: 15,
                                          color:
                                              controller.user['isFollowing'] !=
                                                          null &&
                                                      controller
                                                          .user['isFollowing']
                                                  ? Colors.white
                                                  : Colors.black,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () {
                                Get.back();
                              },
                              child: Image.asset('assets/images/arrow_back.png',
                                  height: 40),
                            ),
                            const SizedBox(width: 10),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                  Expanded(
                    child: controller.myVideosList.isEmpty
                        ? const Center(
                            child: Text('No Videos Found!'),
                          )
                        : Obx(
                            () => GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                mainAxisExtent: 200,
                              ),
                              itemCount: videoController.userVideoList.length,
                              itemBuilder: (context, index) => GestureDetector(
                                onTap: () {
                                  Get.to(
                                    () => UserVideoScreen(
                                      uid:
                                          controller.otherPersonData!.value.uid,
                                      index: index,
                                    ),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(videoController
                                          .userVideoList[index].thumbnail),
                                      fit: BoxFit.cover,
                                    ),
                                    border: Border.all(
                                      color: Colors.black54,
                                    ),
                                  ),
                                  alignment: Alignment.bottomCenter,
                                ),
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
