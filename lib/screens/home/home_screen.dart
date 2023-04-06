import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:howver/controllers/home_controller.dart';
import 'package:howver/enums/home_pages_enum.dart';
import 'package:howver/screens/add_hotel/add_hotel_screen.dart';
import 'package:howver/screens/search/search_screen.dart';
import 'package:howver/utils/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: HomeController(),
      builder: (controller) => Scaffold(
        body: controller.homePages == HomePages.search
            ? const SearchScreen()
            : controller.homePages == HomePages.addHotelPage
                ? const AddHotelScreen()
                : controller.screens[controller.selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: controller.selectedIndex,
          backgroundColor: AppColors.greyColor,
          onTap: controller.onItemTapped,
          items: [
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/images/home.png',
                height: 25,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Image.asset('assets/images/plus.png', height: 25),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Image.asset('assets/images/profile.png', height: 25),
              label: '',
            ),
          ],
        ),
      ),
    );
  }
}
