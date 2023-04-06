import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:howver/models/report_video.dart';
import 'package:howver/models/video.dart';

import '../utils/constants.dart';

class VideoController extends GetxController {
  final Rx<List<Video>> _videoList = Rx<List<Video>>([]);
  final Rx<List<Video>> _userVideoList = Rx<List<Video>>([]);

  Rx<bool> isForYou = true.obs;

  onForYou() {
    isForYou.value = true;
    update();
  }

  onFollowing() {
    isForYou.value = false;
    update();
  }

  List<Video> get videoList => _videoList.value;
  List<Video> get userVideoList => _userVideoList.value;

  onReportAVideo(ReportVideo reportVideo) async {
    DocumentSnapshot doc =
        await firestore.collection('videos').doc(reportVideo.videoId).get();
    firestore.collection('videos').doc(reportVideo.videoId).update({
      'reportCount': (doc.data() as dynamic)['reportCount'] + 1,
    });

    firestore.collection('reportedVideos').doc(reportVideo.videoId).set({
      'videoId': reportVideo.videoId,
      'uid': reportVideo.uid,
      'caption': reportVideo.caption,
      'videoUrl': reportVideo.videoURl,
      'thumbnail': reportVideo.thumbnailUrl,
      'username': reportVideo.username,
      'comments': reportVideo.comments,
      'profilePhoto': reportVideo.photoUrl,
      'hotelName': reportVideo.hotelName,
      'reportCount': (doc.data() as dynamic)['reportCount'] + 1,
    });
    Get.snackbar('Success', 'Video Reported Successfully');
  }

  @override
  void onInit() {
    super.onInit();

    _videoList.bindStream(
        firestore.collection('videos').snapshots().map((QuerySnapshot query) {
      List<Video> retVal = [];
      for (var element in query.docs) {
        retVal.add(
          Video.fromSnap(element),
        );
        update();
      }
      return retVal;
    }));
  }

  getAllVIdeos() {
    _videoList.bindStream(
        firestore.collection('videos').snapshots().map((QuerySnapshot query) {
      List<Video> retVal = [];
      for (var element in query.docs) {
        retVal.add(
          Video.fromSnap(element),
        );
        update();
      }
      return retVal;
    }));
  }

  final Rx<List<Video>> _followerVideos = Rx<List<Video>>([]);
  List<Video> get followerVideos => _followerVideos.value;
  //get following videos
  getFollowingVideos() async {
    List<Video> retVal = [];

    QuerySnapshot followingSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(authController.user.uid)
        .collection('following')
        .get();

    List<String> followingIds =
        followingSnapshot.docs.map((doc) => doc.id).toList();

    _followerVideos.bindStream(firestore
        .collection('videos')
        .where('uid', whereIn: followingIds)
        .snapshots()
        .map((QuerySnapshot query) {
      for (var element in query.docs) {
        retVal.add(
          Video.fromSnap(element),
        );
      }
      return retVal;
    }));
  }

  List<Video> getUserVideos(String uid) {
    List<Video> retVal = [];
    try {
      _userVideoList.bindStream(firestore
          .collection('videos')
          .where('uid', isEqualTo: uid)
          .snapshots()
          .map((QuerySnapshot query) {
        for (var element in query.docs) {
          retVal.add(
            Video.fromSnap(element),
          );
        }
        return retVal;
      }));
    } catch (e) {
      log(e.toString());
    }
    return retVal;
  }

  //LIKE Video
  likeVideo(String id) async {
    DocumentSnapshot doc = await firestore.collection('videos').doc(id).get();
    var uid = authController.user.uid;
    if ((doc.data() as dynamic)['likes'].contains(uid)) {
      await firestore.collection('videos').doc(id).update(
        {
          'likes': FieldValue.arrayRemove([uid]),
        },
      );
    } else {
      await firestore.collection('videos').doc(id).update(
        {
          'likes': FieldValue.arrayUnion([uid]),
        },
      );
    }
  }
}
