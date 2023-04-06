import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:howver/controllers/home_controller.dart';
import 'package:howver/controllers/video_controller.dart';
import 'package:howver/models/report_video.dart';
import 'package:howver/screens/home/components/video_item.dart';
import 'package:howver/screens/search/hotel/hotel_details_screen.dart';
import 'package:howver/screens/search/search_screen.dart';
import 'package:howver/utils/colors.dart';
import 'package:howver/utils/constants.dart';
import 'package:howver/widgets/comment_sheet.dart';

import 'profile_screen.dart';

class UserVideoScreen extends StatefulWidget {
  final String uid;
  final int index;

  const UserVideoScreen({super.key, required this.uid, required this.index});

  @override
  State<UserVideoScreen> createState() => _UserVideoScreenState();
}

class _UserVideoScreenState extends State<UserVideoScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: VideoController(),
      builder: (controller) {
        controller.getUserVideos(widget.uid);
        return Scaffold(
          backgroundColor: Colors.white,
          body: Obx(
            () => SafeArea(
              child: PageView.builder(
                scrollDirection: Axis.vertical,
                itemCount: controller.userVideoList.length,
                controller: PageController(
                  initialPage: widget.index + 1,
                  viewportFraction: 1,
                ),
                itemBuilder: (context, index) {
                  final videoData = controller.userVideoList[index];
                  return Stack(
                    children: [
                      VideoPlayerItem(
                        thumbnail: videoData.thumbnail,
                        videoURL: videoData.videoUrl,
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
                                if (videoData.uid != authController.user.uid) {
                                  Get.to(
                                      () => ProfileScreen(uid: videoData.uid));
                                } else {
                                  Get.put(HomeController()).onItemTapped(2);
                                }
                              },
                              child: CircleAvatar(
                                radius: 25,
                                backgroundImage:
                                    NetworkImage(videoData.profilePhoto),
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
                                    color: Colors.white,
                                    shadows: [
                                      Shadow(
                                        blurRadius: 1.0,
                                        color: Colors.black,
                                        offset: Offset(0.0, 0.0),
                                      ),
                                    ],
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  videoData.caption,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                    shadows: [
                                      Shadow(
                                        blurRadius: 1.0,
                                        color: Colors.black,
                                        offset: Offset(0.0, 0.0),
                                      ),
                                    ],
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                InkWell(
                                  onTap: () async {
                                    firestore
                                        .collection('hotels')
                                        .where('hotelName',
                                            isEqualTo: videoData.hotelName)
                                        .snapshots()
                                        .listen((event) {
                                      if (event.docs.isNotEmpty) {
                                        Get.to(
                                          () => HotelDetailsScreen(
                                            id: event.docs[0].id,
                                            hotelName: event.docs[0]
                                                .data()['hotelName'],
                                            rating: double.parse(event.docs[0]
                                                .data()['starRate']),
                                            fb: event.docs[0]
                                                .data()['facebook'],
                                            location: event.docs[0]
                                                .data()['location'],
                                            phone:
                                                event.docs[0].data()['phone'],
                                            website:
                                                event.docs[0].data()['website'],
                                          ),
                                        );
                                      } else {
                                        Get.snackbar(
                                            'Error', 'Hotel not found');
                                      }
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      Image.asset('assets/images/location.png',
                                          color: Colors.white, height: 20),
                                      Text(
                                        videoData.hotelName,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          color: Colors.white,
                                          shadows: [
                                            Shadow(
                                              blurRadius: 1.0,
                                              color: Colors.black,
                                              offset: Offset(0.0, 0.0),
                                            ),
                                          ],
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () {
                                Get.to(() => const SearchScreen());
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 20.0,
                                      color:
                                          Colors.transparent.withOpacity(0.4),
                                      offset: const Offset(0.0, 0.0),
                                    ),
                                  ],
                                ),
                                child: Image.asset('assets/images/search.png',
                                    color: Colors.white, height: 20),
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            GestureDetector(
                              onTap: () {
                                Get.back();
                              },
                              child: Image.asset(
                                'assets/images/arrow_back.png',
                                color: Colors.white,
                                height: 30,
                              ),
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
                          children: [
                            const Spacer(),
                            GestureDetector(
                              onTap: () {
                                Get.bottomSheet(
                                  CommentSheet(
                                    id: videoData.id,
                                  ),
                                );
                              },
                              child: Column(
                                children: [
                                  Image.asset('assets/images/comment.png',
                                      height: 30),
                                  const SizedBox(height: 5),
                                  Text(
                                    videoData.commentCount.toString(),
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            InkWell(
                              onTap: () {
                                controller.likeVideo(videoData.id);
                              },
                              child: Column(
                                children: [
                                  videoData.likes
                                          .contains(authController.user.uid)
                                      ? const Icon(
                                          Icons.favorite,
                                          color: Colors.red,
                                          size: 30,
                                        )
                                      : Image.asset(
                                          'assets/images/like.png',
                                          height: 25,
                                        ),
                                  const SizedBox(height: 5),
                                  Text(
                                    videoData.likes.length.toString(),
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            const Spacer(),
                            GestureDetector(
                                onTap: () {
                                  Get.dialog(
                                    AlertDialog(
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Text('Report this video?'),
                                          const SizedBox(height: 10),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  elevation: 0.0,
                                                  backgroundColor:
                                                      AppColors.greyColor,
                                                ),
                                                onPressed: () {
                                                  Get.back();
                                                },
                                                child: const Text(
                                                  'NO',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  elevation: 0.0,
                                                  backgroundColor:
                                                      AppColors.buttonColor,
                                                ),
                                                onPressed: () {
                                                  controller.onReportAVideo(
                                                    ReportVideo(
                                                      videoId: videoData.id,
                                                      photoUrl: videoData
                                                          .profilePhoto,
                                                      reportCount:
                                                          videoData.reportCount,
                                                      comments: videoData
                                                          .commentCount,
                                                      username:
                                                          videoData.username,
                                                      uid: videoData.uid,
                                                      caption:
                                                          videoData.caption,
                                                      hotelName:
                                                          videoData.hotelName,
                                                      videoURl:
                                                          videoData.videoUrl,
                                                      thumbnailUrl:
                                                          videoData.thumbnail,
                                                    ),
                                                  );
                                                  Get.back();
                                                },
                                                child: const Text('YES'),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                child: Image.asset('assets/images/more.png',
                                    height: 30)),
                            const Spacer(),
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
      },
    );
  }
}
