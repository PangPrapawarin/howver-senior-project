import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:howver/controllers/auth_controller.dart';
import 'package:howver/controllers/profile_controller.dart';
import 'package:howver/screens/home/home_screen.dart';
import 'package:howver/screens/profile/user_videos_screen.dart';
import 'package:howver/utils/colors.dart';
import 'package:howver/utils/constants.dart';
import 'package:howver/widgets/custom_button.dart';
import 'package:howver/widgets/custom_field.dart';

import '../../controllers/video_controller.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({
    Key? key,
    required this.uid,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _nameController = TextEditingController(
    text: Get.put(ProfileController()).user['name'] ?? '',
  );
  final ProfileController profileController = Get.put(ProfileController());
  final VideoController videoController = Get.put(VideoController());
  late TabController _tabController;
  int _currentIndex = 0;
  @override
  void initState() {
    _nameController.text = Get.put(ProfileController()).user['name'] ?? '';

    super.initState();

    _tabController = TabController(length: 2, vsync: this);
    _tabController.animation!.addListener(() {
      setState(() {
        _currentIndex = (_tabController.animation!.value)
            .round(); //_tabController.animation.value returns double
      });
    });

    super.initState();
  }

  bool loading = true;
  @override
  Widget build(BuildContext context) {
    profileController.updateUserId(widget.uid);

    videoController.getUserVideos(widget.uid);
    profileController.getUserData();
    Future.delayed(const Duration(seconds: 2), () {
      loading = false;
      setState(() {});
    });

    return Scaffold(
      body: authController.isLoading.value || loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : GetBuilder(
              init: ProfileController(),
              builder: (controller) {
                Obx(() => profileController.updateUserId(widget.uid));
                Obx(() {
                  videoController.getUserVideos(widget.uid);
                  return const SizedBox();
                });
                profileController.getUserData();
                if (controller.user.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return SafeArea(
                  child: Column(
                    children: [
                      Container(
                        color: AppColors.greyColor,
                        child: controller.isEditMode.value &&
                                authController.user.uid == widget.uid
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        const SizedBox(width: 10),
                                        CircleAvatar(
                                          radius: 55,
                                          backgroundColor:
                                              const Color(0xffD0FFB3),
                                          backgroundImage: NetworkImage(
                                            controller.user['profilePhoto'],
                                          ),
                                        ),
                                        const SizedBox(width: 20),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: Get.width * 0.4,
                                              height: 40,
                                              child: CustomField(
                                                controller: _nameController,
                                                labelText: 'accountName',
                                                hintText: 'Edit account name',
                                                hintFontSize: 12,
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            const Text(
                                              '@username',
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.black,
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            CustomButton(
                                              onPressed: () {
                                                if (_nameController.text !=
                                                    controller.user['name']) {
                                                  Get.find<AuthController>()
                                                      .updateAccountName(
                                                          _nameController.text)
                                                      .then((value) =>
                                                          controller
                                                              .setEditMode(
                                                                  false));
                                                } else {
                                                  controller.setEditMode(false);
                                                }
                                              },
                                              btnText: 'DONE',
                                              widthPercent: 0.25,
                                            ),
                                            const SizedBox(height: 20),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            : Column(
                                children: [
                                  SizedBox(height: Get.height * 0.02),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(width: 10),
                                      CircleAvatar(
                                        radius: 50,
                                        backgroundImage:
                                            CachedNetworkImageProvider(
                                          controller.user['profilePhoto'],
                                        ),
                                      ),
                                      const SizedBox(width: 40),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            controller.user['name'],
                                            style: const TextStyle(
                                              fontSize: 20,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            controller.user['accountName'] ??
                                                '',
                                            style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black,
                                            ),
                                          ),
                                          authController.user.uid == widget.uid
                                              ? Row(
                                                  children: [
                                                    ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        elevation: 0.0,
                                                        backgroundColor:
                                                            Colors.white,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        controller
                                                            .setEditMode(true);
                                                      },
                                                      child: const Text(
                                                        'EDIT PROFILE',
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 10),
                                                    InkWell(
                                                      onTap: () {
                                                        Get.dialog(
                                                          AlertDialog(
                                                            title: const Text(
                                                              'Logout',
                                                              style: TextStyle(
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                              ),
                                                            ),
                                                            content: const Text(
                                                              'Are you sure you want to logout?',
                                                              style: TextStyle(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                              ),
                                                            ),
                                                            actions: [
                                                              TextButton(
                                                                onPressed: () {
                                                                  Get.back();
                                                                },
                                                                child:
                                                                    const Text(
                                                                  'CANCEL',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                  ),
                                                                ),
                                                              ),
                                                              TextButton(
                                                                onPressed: () {
                                                                  Get.back();
                                                                  Get.find<
                                                                          AuthController>()
                                                                      .signOut();
                                                                  Get.offAll(
                                                                      const HomeScreen());
                                                                },
                                                                child:
                                                                    const Text(
                                                                  'LOGOUT',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                      child: Image.asset(
                                                        'assets/images/logout.png',
                                                        height: 30,
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              : const SizedBox(),
                                        ],
                                      ),
                                      const Spacer(),
                                      authController.user.uid != widget.uid
                                          ? GestureDetector(
                                              onTap: () {
                                                Get.back();
                                              },
                                              child: Image.asset(
                                                  'assets/images/arrow_back.png',
                                                  height: 40),
                                            )
                                          : const SizedBox(),
                                    ],
                                  ),
                                  SizedBox(
                                      height:
                                          authController.user.uid == widget.uid
                                              ? 20
                                              : 0),
                                  authController.user.uid != widget.uid
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                elevation: 0.0,
                                                backgroundColor: controller
                                                        .user['isFollowing']
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
                                                controller.user['isFollowing']
                                                    ? 'FOLLOWING'
                                                    : 'FOLLOW',
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  color: controller
                                                          .user['isFollowing']
                                                      ? Colors.white
                                                      : Colors.black,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      : const SizedBox(),
                                  authController.user.uid == widget.uid
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Column(
                                              children: [
                                                Text(
                                                  profileController
                                                      .user['following'],
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20,
                                                  ),
                                                ),
                                                const SizedBox(height: 5),
                                                const Text(
                                                  'Following',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(width: 20),
                                            Column(
                                              children: [
                                                Text(
                                                  profileController
                                                      .user['followers'],
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20,
                                                  ),
                                                ),
                                                const SizedBox(height: 5),
                                                const Text(
                                                  'Followers',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(width: 20),
                                            Column(
                                              children: [
                                                Text(
                                                  profileController
                                                      .user['likes'],
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20,
                                                  ),
                                                ),
                                                const SizedBox(height: 5),
                                                const Text(
                                                  'likes',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )
                                      : SizedBox(),
                                  const SizedBox(height: 20),
                                  SizedBox(height: _currentIndex == 1 ? 20 : 0),
                                  _currentIndex == 1
                                      ? SizedBox(
                                          height: 45,
                                          child: ListView.builder(
                                            itemCount: controller
                                                .user['thumbnails'].length,
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (c, i) {
                                              String thumbnail = controller
                                                  .user['thumbnails'][i];
                                              Container(
                                                height: 45,
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 5,
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 10,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: AppColors.buttonColor,
                                                  borderRadius:
                                                      BorderRadius.circular(14),
                                                ),
                                                child: const Center(
                                                  child: Text(
                                                    '5-Star',
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                ),
                                              );
                                              return CachedNetworkImage(
                                                imageUrl: thumbnail,
                                                fit: BoxFit.cover,
                                              );
                                            },
                                          ),
                                        )
                                      : const SizedBox(),
                                  SizedBox(height: _currentIndex == 1 ? 20 : 0),
                                ],
                              ),
                      ),
                      widget.uid == authController.user.uid
                          ? const Expanded(child: VideosScreen())
                          : Expanded(
                              child: videoController.userVideoList.isEmpty
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
                                        itemCount: videoController
                                            .userVideoList.length,
                                        itemBuilder: (context, index) =>
                                            GestureDetector(
                                          onTap: () {
                                            Get.to(
                                              () => UserVideoScreen(
                                                uid: widget.uid,
                                                index: index,
                                              ),
                                            );
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                    videoController
                                                        .userVideoList[index]
                                                        .thumbnail),
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
                );
              },
            ),
    );
  }
}

class VideosScreen extends StatefulWidget {
  const VideosScreen({
    super.key,
  });

  @override
  State<VideosScreen> createState() => _VideosScreenState();
}

class _VideosScreenState extends State<VideosScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: ProfileController(),
      builder: (controller) {
        return controller.myVideosList.isEmpty
            ? const Center(
                child: Text('No Videos Found!'),
              )
            : Obx(
                () => GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisExtent: 200,
                  ),
                  itemCount: controller.myVideosList.length,
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: () {
                      Get.to(
                        () => UserVideoScreen(
                          uid: authController.user.uid,
                          index: index,
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                              controller.myVideosList[index].thumbnail),
                          fit: BoxFit.cover,
                        ),
                        border: Border.all(
                          color: Colors.black54,
                        ),
                      ),
                      alignment: Alignment.bottomCenter,
                      child: controller.isEditMode.value
                          ? ElevatedButton(
                              onPressed: () async {
                                //show confirm dialog
                                await Get.defaultDialog(
                                  title: 'Delete Video',
                                  middleText:
                                      'Are you sure you want to delete this video?',
                                  textConfirm: 'Yes',
                                  textCancel: 'No',
                                  confirmTextColor: Colors.white,
                                  cancelTextColor: Colors.black,
                                  buttonColor: Colors.red,
                                  onConfirm: () async {
                                    await firestore
                                        .collection('videos')
                                        .doc(controller.myVideosList[index].id)
                                        .delete();
                                    Get.back();
                                    Get.snackbar('Success',
                                        'Video deleted successfully');
                                  },
                                  onCancel: () {
                                    Get.back();
                                  },
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                elevation: 0.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                backgroundColor: const Color(0xffFF5252),
                              ),
                              child: const Text(
                                'DELETE',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            )
                          : null,
                    ),
                  ),
                ),
              );
      },
    );
  }
}

class BookmarkSaveScreen extends StatelessWidget {
  const BookmarkSaveScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisExtent: 200,
      ),
      itemCount: 15,
      itemBuilder: (context, index) => Container(
        decoration: BoxDecoration(
          image: const DecorationImage(
            image: AssetImage('assets/images/bg.png'),
            fit: BoxFit.cover,
          ),
          border: Border.all(
            color: Colors.black54,
          ),
        ),
      ),
    );
  }
}
