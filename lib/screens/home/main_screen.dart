import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:howver/controllers/home_controller.dart';
import 'package:howver/controllers/video_controller.dart';
import 'package:howver/models/report_video.dart';
import 'package:howver/screens/profile/profile_screen.dart';
import 'package:howver/screens/search/hotel/hotel_details_screen.dart';
import 'package:howver/utils/colors.dart';
import 'package:howver/utils/constants.dart';
import 'package:howver/widgets/comment_sheet.dart';

import 'components/video_item.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    Get.put(VideoController()).getAllVIdeos();
    Get.put(VideoController()).getFollowingVideos();
    super.initState();
  }

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: VideoController(),
      builder: (controller) {
        Get.put(VideoController()).getFollowingVideos();

        return loading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : RefreshIndicator(
                onRefresh: () async {
                  controller.getFollowingVideos();
                  controller.getAllVIdeos();
                },
                child: Scaffold(
                  backgroundColor: Colors.white,
                  body: controller.videoList.isEmpty ||
                          (controller.isForYou.value == false &&
                              controller.followerVideos.isEmpty)
                      ? Center(
                          child: Stack(
                            children: [
                              SizedBox(
                                height: MediaQuery.of(context).size.height,
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const SizedBox(height: 100),
                                    const Icon(Icons.video_library_sharp,
                                        size: 100),
                                    const SizedBox(height: 20),
                                    const Text(
                                      'No Videos',
                                      style: TextStyle(
                                        color: AppColors.buttonColor,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Text(
                                      (controller.isForYou.value == false &&
                                              controller.followerVideos.isEmpty)
                                          ? 'No Videos found from your followers'
                                          : 'Upload a video to get started!',
                                      style: const TextStyle(
                                        color: AppColors.buttonColor,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                left: 10,
                                top: 0,
                                bottom: 0,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          loading = true;
                                        });
                                        controller.onFollowing();

                                        Future.delayed(
                                            const Duration(seconds: 1), () {
                                          setState(() {
                                            loading = false;
                                          });
                                        });
                                      },
                                      child: Text(
                                        'Following',
                                        style: TextStyle(
                                          fontSize: 15,
                                          shadows: const [
                                            Shadow(
                                              blurRadius: 1.0,
                                              color: Colors.black,
                                              offset: Offset(0.0, 0.0),
                                            ),
                                          ],
                                          color: controller.isForYou.value
                                              ? Colors.white60
                                              : Colors.white,
                                          fontWeight: controller.isForYou.value
                                              ? FontWeight.w400
                                              : FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          loading = true;
                                        });
                                        controller.onForYou();
                                        Future.delayed(
                                            const Duration(seconds: 1), () {
                                          setState(() {
                                            loading = false;
                                          });
                                        });
                                      },
                                      child: Text(
                                        'For you',
                                        style: TextStyle(
                                          fontSize: 15,
                                          shadows: const [
                                            Shadow(
                                              blurRadius: 1.0,
                                              color: Colors.black,
                                              offset: Offset(0.0, 0.0),
                                            ),
                                          ],
                                          color: controller.isForYou.value
                                              ? Colors.white
                                              : Colors.white60,
                                          fontWeight: controller.isForYou.value
                                              ? FontWeight.bold
                                              : FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      : Obx(
                          () => SafeArea(
                            child: PageView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: controller.isForYou.value
                                  ? controller.videoList.length
                                  : controller.followerVideos.length,
                              controller: PageController(
                                initialPage: 0,
                                viewportFraction: 1,
                              ),
                              itemBuilder: (context, index) {
                                final videoData = controller.isForYou.value
                                    ? controller.videoList[index]
                                    : controller.followerVideos[index];
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(width: 10),
                                          GestureDetector(
                                            onTap: () {
                                              if (videoData.uid !=
                                                  authController.user.uid) {
                                                Get.to(() => ProfileScreen(
                                                    uid: videoData.uid));
                                              } else {
                                                Get.put(HomeController())
                                                    .onItemTapped(2);
                                              }
                                            },
                                            child: CircleAvatar(
                                              radius: 25,
                                              backgroundImage: NetworkImage(
                                                  videoData.profilePhoto),
                                              backgroundColor:
                                                  const Color(0xffB2CBE5),
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
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
                                                          isEqualTo: videoData
                                                              .hotelName)
                                                      .snapshots()
                                                      .listen((event) {
                                                    if (event.docs.isNotEmpty) {
                                                      Get.to(
                                                        () =>
                                                            HotelDetailsScreen(
                                                          id: event.docs[0].id,
                                                          hotelName: event
                                                                  .docs[0]
                                                                  .data()[
                                                              'hotelName'],
                                                          rating: double.parse(
                                                              event.docs[0]
                                                                      .data()[
                                                                  'starRate']),
                                                          fb: event.docs[0]
                                                                  .data()[
                                                              'facebook'],
                                                          location: event
                                                                  .docs[0]
                                                                  .data()[
                                                              'location'],
                                                          phone: event.docs[0]
                                                              .data()['phone'],
                                                          website: event.docs[0]
                                                                  .data()[
                                                              'website'],
                                                        ),
                                                      );
                                                    } else {
                                                      Get.snackbar('Error',
                                                          'Hotel not found');
                                                    }
                                                  });
                                                },
                                                child: Row(
                                                  children: [
                                                    Image.asset(
                                                        'assets/images/location.png',
                                                        color: Colors.white,
                                                        height: 20),
                                                    Text(
                                                      videoData.hotelName,
                                                      style: const TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.white,
                                                        shadows: [
                                                          Shadow(
                                                            blurRadius: 1.0,
                                                            color: Colors.black,
                                                            offset: Offset(
                                                                0.0, 0.0),
                                                          ),
                                                        ],
                                                        fontWeight:
                                                            FontWeight.w400,
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
                                              Get.put(HomeController())
                                                  .goToSearchPage();
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                boxShadow: [
                                                  BoxShadow(
                                                    blurRadius: 20.0,
                                                    color: Colors.transparent
                                                        .withOpacity(0.4),
                                                    offset:
                                                        const Offset(0.0, 0.0),
                                                  ),
                                                ],
                                              ),
                                              child: Image.asset(
                                                  'assets/images/search.png',
                                                  color: Colors.white,
                                                  height: 20),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      left: 10,
                                      top: 0,
                                      bottom: 0,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                loading = true;
                                              });
                                              controller.onFollowing();

                                              Future.delayed(
                                                  const Duration(seconds: 1),
                                                  () {
                                                setState(() {
                                                  loading = false;
                                                });
                                              });
                                            },
                                            child: Text(
                                              'Following',
                                              style: TextStyle(
                                                fontSize: 15,
                                                shadows: const [
                                                  Shadow(
                                                    blurRadius: 1.0,
                                                    color: Colors.black,
                                                    offset: Offset(0.0, 0.0),
                                                  ),
                                                ],
                                                color: controller.isForYou.value
                                                    ? Colors.white60
                                                    : Colors.white,
                                                fontWeight:
                                                    controller.isForYou.value
                                                        ? FontWeight.w400
                                                        : FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                loading = true;
                                              });
                                              controller.onForYou();
                                              Future.delayed(
                                                  const Duration(seconds: 1),
                                                  () {
                                                setState(() {
                                                  loading = false;
                                                });
                                              });
                                            },
                                            child: Text(
                                              'For you',
                                              style: TextStyle(
                                                fontSize: 15,
                                                shadows: const [
                                                  Shadow(
                                                    blurRadius: 1.0,
                                                    color: Colors.black,
                                                    offset: Offset(0.0, 0.0),
                                                  ),
                                                ],
                                                color: controller.isForYou.value
                                                    ? Colors.white
                                                    : Colors.white60,
                                                fontWeight:
                                                    controller.isForYou.value
                                                        ? FontWeight.bold
                                                        : FontWeight.w400,
                                              ),
                                            ),
                                          ),
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
                                            child: Container(
                                              decoration:
                                                  BoxDecoration(boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.3),
                                                  spreadRadius: 0.5,
                                                  blurRadius: 10,
                                                  offset: const Offset(0,
                                                      0), // changes position of shadow
                                                ),
                                              ]),
                                              child: Column(
                                                children: [
                                                  Image.asset(
                                                    'assets/images/comment.png',
                                                    color: Colors.white,
                                                    height: 30,
                                                  ),
                                                  const SizedBox(height: 5),
                                                  Text(
                                                    videoData.commentCount
                                                        .toString(),
                                                    style: const TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          const Spacer(),
                                          InkWell(
                                            onTap: () {
                                              controller
                                                  .likeVideo(videoData.id);
                                            },
                                            child: Container(
                                              decoration:
                                                  BoxDecoration(boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.3),
                                                  spreadRadius: 0.5,
                                                  blurRadius: 20,
                                                  offset: const Offset(0,
                                                      0), // changes position of shadow
                                                ),
                                              ]),
                                              child: Column(
                                                children: [
                                                  videoData.likes.contains(
                                                          authController
                                                              .user.uid)
                                                      ? const Icon(
                                                          Icons.favorite,
                                                          color: Colors.red,
                                                          size: 30,
                                                        )
                                                      : Image.asset(
                                                          'assets/images/like.png',
                                                          height: 25,
                                                          color: Colors.white,
                                                        ),
                                                  const SizedBox(height: 5),
                                                  Text(
                                                    videoData.likes.length
                                                        .toString(),
                                                    style: const TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          const Spacer(),
                                          GestureDetector(
                                            onTap: () {
                                              //show report video dialog
                                              Get.dialog(
                                                AlertDialog(
                                                  content: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      const Text(
                                                          'Report this video?'),
                                                      const SizedBox(
                                                          height: 10),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: [
                                                          ElevatedButton(
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              elevation: 0.0,
                                                              backgroundColor:
                                                                  AppColors
                                                                      .greyColor,
                                                            ),
                                                            onPressed: () {
                                                              Get.back();
                                                            },
                                                            child: const Text( 'NO',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                          ),
                                                          ElevatedButton(
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              elevation: 0.0,
                                                              backgroundColor:
                                                                  AppColors
                                                                      .buttonColor,
                                                            ),
                                                            onPressed: () {
                                                              controller
                                                                  .onReportAVideo(
                                                                ReportVideo(
                                                                  videoId: videoData.id,
                                                                  photoUrl: videoData.profilePhoto,
                                                                  reportCount: videoData.reportCount,
                                                                  comments: videoData.commentCount,
                                                                  username: videoData.username,
                                                                  uid: videoData.uid,
                                                                  caption: videoData.caption,
                                                                  hotelName: videoData.hotelName,
                                                                  videoURl: videoData.videoUrl,
                                                                  thumbnailUrl: videoData.thumbnail,
                                                                ),
                                                              );
                                                              Get.back();
                                                            },
                                                            child: const Text(
                                                                'YES'),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              decoration:
                                                  BoxDecoration(boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.3),
                                                  spreadRadius: 0.5,
                                                  blurRadius: 10,
                                                  offset: const Offset(0,
                                                      0), // changes position of shadow
                                                ),
                                              ]),
                                              child: Image.asset(
                                                'assets/images/more.png',
                                                height: 30,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
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
                ),
              );
      },
    );
  }
}
