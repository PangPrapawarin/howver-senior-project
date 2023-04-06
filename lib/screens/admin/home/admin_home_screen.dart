import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:howver/controllers/admin_home_controller.dart';
import 'package:howver/utils/colors.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: AdminHomeController(),
      builder: (controller) => Scaffold(
        body: controller.screens[controller.selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: controller.selectedIndex,
          backgroundColor: AppColors.greyColor,
          onTap: controller.onItemTapped,
          items: [
            BottomNavigationBarItem(
              icon: Image.asset('assets/images/home.png', height: 25),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Image.asset('assets/images/hotel.png', height: 25),
              label: '',
            ),
          ],
        ),
      ),
    );
  }
}
