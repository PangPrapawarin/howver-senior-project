import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:howver/enums/admin_pages.dart';
import 'package:howver/models/hotel.dart';
import 'package:howver/models/report_video.dart';
import 'package:howver/models/user.dart';
import 'package:howver/screens/admin/home/admin_home_content.dart';
import 'package:howver/screens/admin/hotel/admin_hotel_screen.dart';
import 'package:howver/utils/constants.dart';

class AdminHomeController extends GetxController {
  static AdminHomeController instance = Get.find();

  late Rx<User?> _user;
  User get user => _user.value!;

  final _selectedIndex = 0.obs;
  get selectedIndex => _selectedIndex.value;
  void onItemTapped(int index) {
    _selectedIndex.value = index;
    goBackToAdminHome();
    update();
  }

  AdminPages adminPages = AdminPages.home;
  goToViewVideoPage() {
    adminPages = AdminPages.viewVideoPage;
    update();
  }

  deleteReportedVideo(String id) async {
    await firestore
        .collection('reportedVideos')
        .doc(id)
        .update({'isDeleted': true});
    await firestore.collection('videos').doc(id).delete();
    Get.snackbar('success', 'Video has been deleted');
    getReportedVideos();
    update();
  }

  denyReportedVideo(String id) async {
    await firestore.collection('reportedVideos').doc(id).delete();
    getReportedVideos();
    update();
  }

  goToEditHotelPage() {
    adminPages = AdminPages.editHotel;
    update();
  }

  goBackToAdminHome() {
    adminPages = AdminPages.home;
    update();
  }

  final Rx<List<Hotel>> _allHotels = Rx<List<Hotel>>([]);
  List<Hotel> get allHotels => _allHotels.value;

  getAllHotels() async {
    _allHotels.bindStream(
        firestore.collection('hotels').snapshots().map((QuerySnapshot query) {
      List<Hotel> retVal = [];
      for (var element in query.docs) {
        retVal.add(Hotel.fromSnap(element));

        update();
      }
      return retVal;
    }));
  }

  editHotelDetails(Hotel hotel) {
    firestore.collection('hotels').doc(hotel.id).update({
      'hotelName': hotel.hotelName,
      'starRate': hotel.starRate,
      'type': hotel.type,
      'style': hotel.style,
      'size': hotel.size,
      'location': hotel.location,
      'linkWebsite': hotel.website,
      'facebook': hotel.facebook,
      'phone': hotel.phone,
      'detail': hotel.detail,
    });
    getAllHotels();
    update();
    Get.back();
  }

  List<Widget> screens = const [
    AdminHomeContent(),
    AdminHotelScreen(),
  ];

  @override
  void onInit() {
    getAllHotels();
    _reportedVideos.bindStream(
      firestore.collection('reportedVideos').snapshots().map(
        (QuerySnapshot query) {
          List<ReportVideo> retVal = [];
          for (var element in query.docs) {
            retVal.add(ReportVideo.fromSnap(element));
            update();
          }
          return retVal;
        },
      ),
    );
    getReportedVideos();
    super.onInit();
  }

  @override
  void onReady() {
    getReportedVideos();
    super.onReady();
  }

  final Rx<List<ReportVideo>> _reportedVideos = Rx<List<ReportVideo>>([]);
  List<ReportVideo> get reportedVideos => _reportedVideos.value;
  getReportedVideos() async {
    try {
      _reportedVideos.bindStream(
        firestore.collection('reportedVideos').snapshots().map(
          (QuerySnapshot query) {
            List<ReportVideo> retVal = [];
            for (var element in query.docs) {
              retVal.add(ReportVideo.fromSnap(element));
              update();
            }
            return retVal;
          },
        ),
      );
    } catch (e) {
      print(e);
    }
  }
}
