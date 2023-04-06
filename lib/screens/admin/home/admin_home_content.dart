import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:howver/controllers/admin_home_controller.dart';
import 'package:howver/screens/admin/home/view_reported_video_screen.dart';
import 'package:howver/screens/auth/login_screen.dart';
import 'package:howver/utils/colors.dart';
import 'package:howver/utils/constants.dart';
import 'package:howver/widgets/custom_button.dart';

class AdminHomeContent extends StatefulWidget {
  const AdminHomeContent({super.key});

  @override
  State<AdminHomeContent> createState() => _AdminHomeContentState();
}

class _AdminHomeContentState extends State<AdminHomeContent> {
  final Rx<Map<String, dynamic>> _user = Rx<Map<String, dynamic>>({});
  Map<String, dynamic> get user => _user.value;

  @override
  void initState() {
    Get.put(AdminHomeController()).getReportedVideos();
    super.initState();
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: AdminHomeController(),
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              elevation: 0.0,
              backgroundColor: AppColors.greyColor,
              actions: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: CustomButton(
                    onPressed: () {
                      Get.offAll(() => LoginScreen());
                      Get.offAll(() => authController.signOut());
                    },
                    radius: 10,
                    btnText: 'Logout',
                    widthPercent: 0.24,
                  ),
                ),
              ],
              title: const Text(
                'Reported Video',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            body: isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : controller.reportedVideos.isEmpty
                    ? const Center(
                        child: Text(
                          'No Reported Videos Found',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),
                      )
                    : Obx(
                        () => ListView.builder(
                          itemCount: controller.reportedVideos.length,
                          itemBuilder: (context, index) {
                            var report = controller.reportedVideos[index];
                            return ReportedVideoItem(
                              onTap: () {
                                Get.to(
                                  () => ViewReportedVideoScreen(
                                    index: index,
                                  ),
                                );
                              },
                              id: report.videoId,
                              caption: report.caption,
                              profilePhoto: report.photoUrl,
                              hotelName: report.hotelName,
                              username: report.username,
                              onDelete: () {
                                //show confirm dialog
                                Get.dialog(
                                  AlertDialog(
                                    title: const Text('Confirm'),
                                    content: const Text('Are you sure?'),
                                    actions: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          elevation: 0.0,
                                          backgroundColor: AppColors.greyColor,
                                        ),
                                        onPressed: () { Get.back(); },
                                        child: const Text(
                                          'Cancel', style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          elevation: 0.0,
                                          backgroundColor:
                                              AppColors.buttonColor,
                                        ),
                                        onPressed: () {
                                          setState(() { isLoading = true; });
                                          controller.deleteReportedVideo(report.videoId);
                                          Get.back();
                                          setState(() { isLoading = false; });
                                        },
                                        child: const Text(
                                          'Delete', style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              onDeny: () {
                                //show confirm dialog
                                Get.dialog(
                                  AlertDialog(
                                    backgroundColor: Colors.black,
                                    content: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Text( 'Do you want to ignore this video?',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        const SizedBox( height: 20,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                elevation: 0.0,
                                                backgroundColor: AppColors.buttonColor,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  isLoading = true;
                                                });
                                                controller.denyReportedVideo(
                                                    report.videoId);
                                                Get.back();
                                                setState(() {
                                                  isLoading = false;
                                                });
                                              },
                                              child: const Text(
                                                'YES',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                elevation: 0.0,
                                                backgroundColor: Colors.white,
                                              ),
                                              onPressed: () {
                                                Get.back();
                                              },
                                              child: const Text(
                                                'NO',
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
          );
        });
  }
}

class ReportedVideoItem extends StatefulWidget {
  final String username;
  final String caption;
  final String profilePhoto;
  final String hotelName;
  final VoidCallback onDelete;
  final VoidCallback onDeny;
  final VoidCallback onTap;
  final String id;

  const ReportedVideoItem({
    super.key,
    required this.username,
    required this.caption,
    required this.hotelName,
    required this.onDelete,
    required this.onDeny,
    required this.profilePhoto,
    required this.onTap,
    required this.id,
  });

  @override
  State<ReportedVideoItem> createState() => _ReportedVideoItemState();
}

class _ReportedVideoItemState extends State<ReportedVideoItem> {
  bool isDeleted = false;
  getStatus() {
    firestore.collection('reportedVideos').doc(widget.id).get().then((value) {
      if (value['isDeleted'] != null && value['isDeleted'] == false) {
        setState(() {
          isDeleted = false;
        });
      } else {
        setState(() {
          isDeleted = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    getStatus();
    return GestureDetector(
      onTap: isDeleted ? () {} : widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.greyColor,
          borderRadius: BorderRadius.circular(13),
        ),
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(widget.profilePhoto),
              backgroundColor: const Color(0xffB2CBE5),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 2),
                  Text(
                    widget.username,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.caption,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Image.asset('assets/images/location.png', height: 20),
                      Text(
                        widget.hotelName,
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
            ),
            isDeleted
                ? const SizedBox()
                : Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Image.asset('assets/images/eye.png', height: 20)),
            const SizedBox(width: 10),
            isDeleted
                ? const Padding(
                    padding: EdgeInsets.only(top: 18.0),
                    child: Text('Deleted'),
                  )
                : Column(
                    children: [
                      ElevatedButton(
                        onPressed: widget.onDelete,
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
                      ),
                      ElevatedButton(
                        onPressed: widget.onDeny,
                        style: ElevatedButton.styleFrom(
                          elevation: 0.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          backgroundColor: Colors.black,
                        ),
                        child: const Text(
                          ' DENY ',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  )
          ],
        ),
      ),
    );
  }
}
