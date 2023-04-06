import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:howver/controllers/home_controller.dart';
import 'package:howver/models/hotel.dart';
import 'package:howver/models/video.dart';
import 'package:howver/utils/constants.dart';

class AddHotelController extends GetxController {
  Rx<int> sizeGroupValue = (-1).obs;

  TextEditingController hotelNameController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  void onSizeGroupChanged(int? value) {
    sizeGroupValue.value = value!;
    update();
  }

  stringToSize(String size) {
    switch (size) {
      case 'Small':
        return 0;
      case 'Medium':
        return 1;
      case 'Large':
        return 2;
      case 'Very Large':
        return 3;
      default:
        return 0;
    }
  }

  sizeToString() {
    switch (sizeGroupValue.value) {
      case 0:
        return 'Small';
      case 1:
        return 'Medium';
      case 2:
        return 'Large';
      case 3:
        return 'Very Large';
      default:
        return 'Small';
    }
  }

  Rx<bool> isLoading = false.obs;

  onSubmitHotel(
      {required String hotelName, required double stars,
      required String type, required String style, required String size,
      String? location, String? linkWebsite, String? linkFB, String? phoneNum,
      required String uid}) async {
    isLoading.value = true;
    update();
    try {
      var allDocs = await firestore.collection('hotels').get();
      int len = allDocs.docs.length;
      var model = Hotel(
        hotelName: hotelName,
        phone: phoneNum ?? '',
        id: "hotel $len",
        size: size,
        starRate: stars.toString(),
        style: style,
        facebook: linkFB ?? '',
        website: linkWebsite ?? '',
        location: location ?? '',
        type: type,
        detail: uid,
      );
      firestore.collection('hotels').doc("hotel $len").set(model.toJson());
      Get.snackbar('Success', 'Hotel added successfully');
      Get.put(HomeController()).onItemTapped(1);
    } catch (e) {
      isLoading.value = false;
      update();
      Get.snackbar('Error', 'Something went wrong');
      print(e);
    }
    isLoading.value = false;
    update();
  }

  final Rx<List<Video>> _hotelVideos = Rx<List<Video>>([]);
  List<Video> get hotelVideos => _hotelVideos.value;
  getHotelVideos(String hotelId) {
    _hotelVideos.bindStream(firestore
        .collection('videos')
        .where('hotelId', isEqualTo: hotelId)
        .snapshots()
        .map((QuerySnapshot query) {
      List<Video> retVal = [];
      for (var element in query.docs) {
        retVal.add(Video.fromSnap(element));
      }
      return retVal;
    }));
  }
}
