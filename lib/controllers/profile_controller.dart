import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:howver/models/user.dart';
import 'package:howver/models/video.dart';
import 'package:howver/utils/constants.dart';

class ProfileController extends GetxController {
  final Rx<Map<String, dynamic>> _user = Rx<Map<String, dynamic>>({});
  Map<String, dynamic> get user => _user.value;

  Rx<User>? otherPersonData;

  final Rx<String> _uid = "".obs;

  Rx<bool> isEditMode = false.obs;
  setEditMode(bool value) {
    isEditMode.value = value;
    update();
  }

  updateUserId(String uid) {
    _uid.value = uid;
    getUserData();
  }

  getOtherPersonProfile(String uid) {
    firestore.collection('users').doc(uid).get().then((value) {
      otherPersonData = User.fromSnap(value).obs;
      update();
    });
  }

  final Rx<List<Video>> _myVideosList = Rx<List<Video>>([]);
  List<Video> get myVideosList => _myVideosList.value;

  getMyVideos() {
    _myVideosList.bindStream(firestore
        .collection('videos')
        .where('uid', isEqualTo: authController.user.uid)
        .snapshots()
        .map((QuerySnapshot query) {
      List<Video> retVal = [];
      for (var element in query.docs) {
        retVal.add(
          Video.fromSnap(element),
        );
      }
      return retVal;
    }));
  }

  bool isFollowing = false;
  getUserData() async {
    List<String> thumbnails = [];
    var myVideos = await firestore
        .collection('videos')
        .where('uid', isEqualTo: _uid.value)
        .get();

    for (int i = 0; i < myVideos.docs.length; i++) {
      thumbnails.add((myVideos.docs[i].data() as dynamic)['thumbnail']);
    }

    DocumentSnapshot userDoc =
        await firestore.collection('users').doc(_uid.value).get();
    final userData = userDoc.data()! as dynamic;
    String name = userData['name'];
    String profilePhoto = userData['profilePhoto'];
    String accountName = userData['accountName'];
    int likes = 0;
    int followers = 0;
    int following = 0;

    for (var item in myVideos.docs) {
      likes += (item.data()['likes'] as List).length;
    }
    var followerDoc = await firestore
        .collection('users')
        .doc(_uid.value)
        .collection('followers')
        .get();
    var followingDoc = await firestore
        .collection('users')
        .doc(_uid.value)
        .collection('following')
        .get();
    followers = followerDoc.docs.length;
    following = followingDoc.docs.length;

    firestore
        .collection('users')
        .doc(_uid.value)
        .collection('followers')
        .doc(authController.user.uid)
        .get()
        .then((value) {
      if (value.exists) {
        isFollowing = true;
        update();
      } else {
        isFollowing = false;
        update();
      }
    });

    _user.value = {
      'followers': followers.toString(),
      'following': following.toString(),
      'isFollowing': isFollowing,
      'likes': likes.toString(),
      'profilePhoto': profilePhoto,
      'name': name,
      'thumbnails': thumbnails,
      'accountName': accountName,
    };
    update();
  }

  followUser() async {
    var doc = await firestore.collection('users').doc(_uid.value)
        .collection('followers').doc(authController.user.uid).get();

    if (!doc.exists) {
      await firestore
          .collection('users').doc(_uid.value).collection('followers')
          .doc(authController.user.uid).set({});
      await firestore
          .collection('users').doc(authController.user.uid)
          .collection('following').doc(_uid.value).set({});
      _user.value.update(
        'followers',
        (value) => (int.parse(value) + 1).toString(),
      );
    } else {
      await firestore
          .collection('users').doc(_uid.value).collection('followers')
          .doc(authController.user.uid).delete();
      await firestore
          .collection('users').doc(authController.user.uid)
          .collection('following').doc(_uid.value).delete();
      _user.value.update(
        'followers',
        (value) => (int.parse(value) - 1).toString(),
      );
    }
    _user.value.update('isFollowing', (value) => !value);
    update();
  }

  @override
  void onInit() {
    getMyVideos();

    super.onInit();
  }
}
