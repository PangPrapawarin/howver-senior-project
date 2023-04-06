import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:howver/controllers/admin_home_controller.dart';
import 'package:howver/screens/home/components/video_item.dart';
import 'package:howver/screens/profile/profile_screen.dart';
import 'package:howver/widgets/comment_sheet.dart';

class ViewReportedVideoScreen extends StatefulWidget {
  final int index;
  const ViewReportedVideoScreen({super.key, required this.index});

  @override
  State<ViewReportedVideoScreen> createState() =>
      _ViewReportedVideoScreenState();
}

class _ViewReportedVideoScreenState extends State<ViewReportedVideoScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Get.find<AdminHomeController>().goBackToAdminHome();
        return Future.value(false);
      },
      child: GetBuilder(
          init: AdminHomeController(),
          builder: (controller) {
            controller.reportedVideos
                .removeWhere((element) => element.isDeleted == true);
            return Scaffold(
              backgroundColor: Colors.white,
              body: Obx(
                () => SafeArea(
                  child: PageView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: controller.reportedVideos.length,
                    controller: PageController(
                      initialPage: widget.index + 1,
                      viewportFraction: 1,
                    ),
                    itemBuilder: (context, index) {
                      final videoData = controller.reportedVideos[index];
                      return Stack(
                        children: [
                          VideoPlayerItem(
                            thumbnail: videoData.thumbnailUrl,
                            videoURL: videoData.videoURl,
                          ),
                          Positioned(
                            top: 20,
                            right: 0,
                            left: 10,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(width: 10),
                                GestureDetector(
                                  onTap: () {
                                    Get.to(
                                      () => ProfileScreen(
                                        uid: videoData.uid,
                                      ),
                                    );
                                  },
                                  child: CircleAvatar(
                                    radius: 25,
                                    backgroundImage:
                                        NetworkImage(videoData.photoUrl),
                                    backgroundColor: const Color(0xffB2CBE5),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      videoData.username,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    Text(
                                      videoData.caption,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Row(
                                      children: [
                                        Image.asset(
                                            'assets/images/location.png',
                                            height: 20),
                                        Text(
                                          videoData.hotelName,
                                          style: const TextStyle(
                                            fontSize: 15,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400,
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
                                  child: Image.asset(
                                      'assets/images/arrow_back.png',
                                      height: 30),
                                ),
                                const SizedBox(width: 20),
                              ],
                            ),
                          ),
                          Positioned(
                            bottom: 10,
                            left: 0,
                            right: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Get.bottomSheet(
                                      CommentSheet(
                                        id: videoData.videoId,
                                      ),
                                    );
                                  },
                                  child: Column(
                                    children: [
                                      Image.asset('assets/images/comment.png',
                                          height: 30),
                                      const SizedBox(height: 5),
                                      Text(
                                        videoData.comments.toString(),
                                        style: const TextStyle(
                                          fontSize: 15,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            );
          }),
    );
  }
}
