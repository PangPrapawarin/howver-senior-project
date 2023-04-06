import 'package:cloud_firestore/cloud_firestore.dart';

class Video {
  String username;
  String uid;
  String id;
  List likes;
  int commentCount;
  String caption;
  String videoUrl;
  String thumbnail;
  String profilePhoto;
  int reportCount;
  String statusCheck;
  List userSavedVideo;
  String hotelName;
  String hotelId;

  Video({
    required this.username,
    required this.hotelId,
    required this.uid,
    required this.id,
    required this.likes,
    required this.commentCount,
    required this.caption,
    required this.videoUrl,
    required this.thumbnail,
    required this.profilePhoto,
    required this.reportCount,
    required this.statusCheck,
    required this.hotelName,
    required this.userSavedVideo,
  });

  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "id": id,
        "likes": likes,
        "commentCount": commentCount,
        "caption": caption,
        "hotelId": hotelId,
        "videoUrl": videoUrl,
        "thumbnail": thumbnail,
        "profilePhoto": profilePhoto,
        "reportCount": reportCount,
        "statusCheck": statusCheck,
        "userSavedVideo": userSavedVideo,
        "hotelName": hotelName,
      };

  static Video fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Video(
        username: snapshot['username'],
        uid: snapshot['uid'],
        hotelId: snapshot['hotelId'],
        id: snapshot['id'],
        hotelName: snapshot['hotelName'],
        likes: snapshot['likes'],
        commentCount: snapshot['commentCount'],
        caption: snapshot['caption'],
        videoUrl: snapshot['videoUrl'],
        thumbnail: snapshot['thumbnail'],
        profilePhoto: snapshot['profilePhoto'],
        reportCount: snapshot['reportCount'],
        statusCheck: snapshot['statusCheck'],
        userSavedVideo: snapshot['userSavedVideo']);
  }
}
