import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:howver/controllers/auth_controller.dart';
import 'package:howver/screens/auth/login_screen.dart';
import 'package:howver/screens/home/home_screen.dart';

import 'controllers/add_hotel_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().then((value) {
    Get.put(AuthController());
    Get.put(AddHotelController());
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HOWVER',
      theme: ThemeData(
        fontFamily: GoogleFonts.inter().fontFamily,
        scaffoldBackgroundColor: Colors.white,
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(),
    );
  }
}
