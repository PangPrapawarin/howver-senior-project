import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:howver/controllers/auth_controller.dart';
// import 'package:howver/screens/profile/add_video_screen.dart';
// import 'package:howver/screens/profile/search_screen.dart';
// import 'package:howver/screens/profile/video_screen.dart';

List pages = [
  // ProfileScreen(uid: authController.user.uid),
];

//Colors
const backgroundColor = Colors.black;
var buttonColor = const Color(0xFF5B5B5B);
const componentColor = Color(0xFFD9D9D9);
const borderColor = Color(0xFFB2CBE5);

//Firebase
var firebaseAuth = FirebaseAuth.instance;
var firebaseStorage = FirebaseStorage.instance;
var firestore = FirebaseFirestore.instance;

//Controller
var authController = AuthController.instance;