import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String name;
  String accountName;
  String profilePhoto;
  String email;
  String uid;
  String role;
  bool isFollowing;

  User({
    required this.isFollowing,
    required this.name,
    required this.accountName,
    required this.profilePhoto,
    required this.email,
    required this.uid,
    required this.role,
  });

  Map<String, dynamic> toJson() => {
        "name": name,
        "accountName": accountName,
        "profilePhoto": profilePhoto,
        "email": email,
        "uid": uid,
        "role": role,
        "isFollowing": isFollowing,
      };

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return User(
        email: snapshot['email'],
        isFollowing: snapshot['isFollowing'] ?? false,
        profilePhoto: snapshot['profilePhoto'],
        uid: snapshot['uid'],
        name: snapshot['name'],
        accountName: snapshot['accountName'],
        role: snapshot['role']);
  }
}
