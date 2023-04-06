import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:howver/models/user.dart' as model;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:howver/screens/admin/home/admin_home_screen.dart';
import 'package:howver/screens/auth/login_screen.dart';
import 'package:howver/screens/home/home_screen.dart';
import 'package:howver/utils/constants.dart';
import 'package:image_picker/image_picker.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();

  late Rx<File?> _pickImage;
  late Rx<User?> _user;

  File? get profilePhoto => _pickImage.value;

  User get user => _user.value!;

  @override
  void onReady() {
    super.onReady();
    _pickImage = Rx<File?>(null); // initialize _pickImage to null
    _user = Rx<User?>(firebaseAuth.currentUser);
    _user.bindStream(firebaseAuth.authStateChanges());
    ever(_user, _setInitialScreen);
  }

  _setInitialScreen(User? user) async {
    if (user == null) {
      Get.offAll(() => LoginScreen());
    } else {
      print(user.uid);
      DocumentSnapshot? userRole =
          await firestore.collection('users').doc(user.uid).get();
      if (userRole != null && userRole.exists) {
        if ((userRole.data()! as dynamic)['role'].contains('admin')) {
          Get.offAll(() => const AdminHomeScreen());
        } else {
          Get.offAll(() => const HomeScreen());
        }
      }
    }
  }

  void pickImage() async {
    final pickImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickImage != null) {
      Get.snackbar('Profile Picture',
          'You have successfully selected your profile picture!');
      _pickImage.value = File(
          pickImage.path); // use the value property to update the Rx variable
    }
  }

  Future<String> _uploadToStorage(File image, String userId) async {
    try {
      Reference ref = firebaseStorage.ref().child('profilePics').child(userId);

      UploadTask uploadTask = ref.putFile(image);
      TaskSnapshot snap = await uploadTask;
      String downloadUrl = await snap.ref.getDownloadURL();
      print('download URL: $downloadUrl');
      return downloadUrl;
    } catch (e) {
      print('Error uploading image to Firebase Storage: $e');
      rethrow; // rethrow the exception so that it can be caught by the try-catch block in registerUser
    }
  }

  void registerUser(
    String username,
    String email,
    String password,
    String confirmPassword,
    String accountName,
    File? image,
  ) async {
    try {
      if (username.isNotEmpty &&
          email.isNotEmpty &&
          password.isNotEmpty &&
          confirmPassword.isNotEmpty &&
          accountName.isNotEmpty &&
          password == confirmPassword &&
          image != null) {
        UserCredential cred = await firebaseAuth.createUserWithEmailAndPassword(
            email: email, password: password);
        String downloadUrl = await _uploadToStorage(image, cred.user!.uid);
        print(downloadUrl);
        print(email);
        print(username);
        print(accountName);
        print(cred.user!.uid);
        model.User user = model.User(
          email: email,
          name: username,
          isFollowing: false,
          accountName: accountName,
          uid: cred.user!.uid,
          profilePhoto: downloadUrl,
          role: 'user',
        );
        firestore.collection('users').doc(cred.user!.uid).set(user.toJson());
        DocumentSnapshot? userRole =
            await firestore.collection('users').doc(user.uid).get();

        if (userRole != null && userRole.exists) {
          if ((userRole.data()! as dynamic)['role'].contains('admin')) {
            Get.offAll(() => const AdminHomeScreen());
          } else {
            Get.offAll(() => const HomeScreen());
          }
        }
      } else if (password != confirmPassword) {
        Get.snackbar('Error Creating Account',
            'Your confirm password and password are not match.');
      } else if (image == null) {
        Get.snackbar(
            'Error Creating Account', 'Please select the profile photo.');
      } else {
        Get.snackbar('Error Creating Account', 'Please enter all the fields.');
      }
    } catch (e) {
      Get.snackbar('Error Creating Account', e.toString());
    }
  }

  void loginUser(String email, String password) async {
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        var cred = await firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password);
        print('login success');

        DocumentSnapshot? userRole =
            await firestore.collection('users').doc(user.uid).get();

        if (userRole != null && userRole.exists) {
          if ((userRole.data()! as dynamic)['role'].contains('admin')) {
            Get.offAll(() => const AdminHomeScreen());
          } else {
            Get.offAll(() => const HomeScreen());
          }
        }
      } else {
        Get.snackbar('Error Logging in', 'Please enter all the fields');
      }
    } catch (e) {
      Get.snackbar('Error Logging in', e.toString());
    }
  }

  void signOut() async {
    log('message');
    await firebaseAuth
        .signOut()
        .then((value) => Get.offAll(() => LoginScreen()));
  }

  Rx<bool> isLoading = Rx<bool>(false);
  Future updateAccountName(String accountName) async {
    isLoading(true);
    update();
    await firestore.collection('users').doc(_user.value!.uid).update({
      'name': accountName,
    });
    isLoading(false);
    update();
  }
}
