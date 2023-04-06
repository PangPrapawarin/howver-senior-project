import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:howver/models/hotel.dart';

import 'package:howver/utils/constants.dart';
import 'package:howver/models/video.dart';
import 'package:video_compress/video_compress.dart';

class AddPostController extends GetxController {
  _compressVideo(String videoPath) async {
    final compressedVideo = await VideoCompress.compressVideo(videoPath,
        quality: VideoQuality.MediumQuality);
    return compressedVideo!.file;
  }

  TextEditingController caption = TextEditingController();

  List<Hotel> allHotels = [];
  final Rx<List<Hotel>> _allHotels = Rx<List<Hotel>>([]);
  List<Hotel> get allHotelsList => _allHotels.value;

  @override
  void onInit() {
    getAllHotels();
    super.onInit();
  }

  Future getAllHotels() async {
    try {
      _allHotels.bindStream(
          firestore.collection('hotels').snapshots().map((QuerySnapshot query) {
        List<Hotel> retVal = [];
        for (var element in query.docs) {
          retVal.add(Hotel.fromSnap(element));

          update();
        }
        retVal.add(Hotel(
            id: '',
            hotelName: 'Add new hotel',
            phone: '',
            size: '',
            starRate: '',
            style: '',
            facebook: '',
            website: '',
            location: '',
            type: '',
            detail: ''));
        return retVal;
      }));
    } catch (e) {
      print(e);
    }
  }

  Future<String> _uploadVideoToStorage(String id, String videoPath) async {
    Reference ref = firebaseStorage.ref().child('videos').child(id);

    UploadTask uploadTask = ref.putFile(await _compressVideo(videoPath));
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  _getThumbnail(String videoPath) async {
    final thumbnail = await VideoCompress.getFileThumbnail(videoPath);
    return thumbnail;
  }

  Future<String> _uploadImageToStorage(String id, String videoPath) async {
    Reference ref = firebaseStorage.ref().child('thumbnails').child(id);

    UploadTask uploadTask = ref.putFile(await _getThumbnail(videoPath));
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  //upload video
  uploadVideo(String caption, String videoPath, String hotelName) async {
    try {
      String uid = firebaseAuth.currentUser!.uid;
      DocumentSnapshot userDoc =
          await firestore.collection('users').doc(uid).get();
      var allDocs = await firestore.collection('videos').get();
      int len = allDocs.docs.length;
      String videoUrl = await _uploadVideoToStorage("Video $len", videoPath);
      String thumbnail = await _uploadImageToStorage("Video $len", videoPath);
      Video video = Video(
        hotelName: hotelName,
        username: (userDoc.data()! as Map<String, dynamic>)['name'],
        uid: uid,
        id: "Video $len",
        hotelId: allHotelsList
            .firstWhere((element) => element.hotelName == hotelName)
            .id,
        likes: [],
        commentCount: 0,
        caption: caption,
        videoUrl: videoUrl,
        thumbnail: thumbnail,
        profilePhoto: (userDoc.data()! as Map<String, dynamic>)['profilePhoto'],
        reportCount: 0,
        statusCheck: '',
        userSavedVideo: [],
      );
      await firestore
          .collection('videos')
          .doc("Video $len")
          .set(video.toJson());
      Get.back();
      Get.snackbar('success', 'successfully added post.');
    } catch (e) {
      Get.snackbar("Error Uploading Video", e.toString());
    }
  }
}
