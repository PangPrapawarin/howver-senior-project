import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:howver/enums/home_pages_enum.dart';
import 'package:howver/screens/add_post/add_post_screen.dart';
import 'package:howver/screens/auth/login_screen.dart';
import 'package:howver/screens/home/main_screen.dart';
import 'package:howver/screens/profile/profile_screen.dart';
import 'package:howver/utils/constants.dart';

class HomeController extends GetxController {
  final _selectedIndex = 0.obs;
  void onItemTapped(int index) {
    //change the selected index of the bottom navigation bar
    _selectedIndex.value = index;
    goBackToHomePage();
    update();
  }

  List<Widget> screens = [
    const MainScreen(),
    const AddPostScreen(),
    ProfileScreen(uid: authController.user.uid),
    LoginScreen(),
  ];
  HomePages homePages = HomePages.home;
  goToSearchPage() {
    homePages = HomePages.search;
    update();
  }

  goToAddHotelPage() {
    homePages = HomePages.addHotelPage;
    update();
  }

  goBackToLoginPage() {
    homePages = HomePages.login;
    update();
  }

  //go back to home page
  goBackToHomePage() {
    homePages = HomePages.home;
    update();
  }

  onHotelDetailsBack() {
    goToSearchPage();
  }

  goToHotelDetailsPage() {
    homePages = HomePages.hotelDetails;
    update();
  }

  goToOthersProfilePage() {
    homePages = HomePages.otherProfilePage;
    update();
  }

  goToHotelLocationPage() {
    homePages = HomePages.hotelLocation;
    update();
  }

  int get selectedIndex => _selectedIndex.value;
}
