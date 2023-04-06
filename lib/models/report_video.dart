import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class ReportVideo {
  String videoId;
  String uid;
  String caption;
  String hotelName;
  String username;
  String videoURl;
  String thumbnailUrl;
  String photoUrl;
  bool? isDeleted;

  int comments;
  int reportCount;

  ReportVideo({
    required this.photoUrl,
    required this.videoId,
    required this.username,
    required this.uid,
    this.isDeleted,
    required this.caption,
    required this.hotelName,
    required this.comments,
    required this.reportCount,
    required this.videoURl,
    required this.thumbnailUrl,
  });

  //from snap
  static ReportVideo fromSnap(DocumentSnapshot snap) {
    log('from snap called');
    var snapshot = snap.data() as Map<String, dynamic>;

    return ReportVideo(
      videoId: snapshot['videoId'],
      photoUrl: snapshot['profilePhoto'],
      reportCount: snapshot['reportCount'],
      uid: snapshot['uid'],
      username: snapshot['username'],
      caption: snapshot['caption'],
      hotelName: snapshot['hotelName'],
      comments: snapshot['comments'],
      videoURl: snapshot['videoUrl'],
      thumbnailUrl: snapshot['thumbnail'],
      isDeleted: snapshot['isDeleted'] ?? false,
    );
  }

  factory ReportVideo.fromJson(Map<String, dynamic> json) => ReportVideo(
        videoId: json["video_id"],
        username: json["username"],
        uid: json["uid"],
        caption: json["caption"],
        comments: json["comments"],
        hotelName: json["hotelName"],
        photoUrl: json["profilePhoto"],
        reportCount: json["reportCount"],
        videoURl: json["videoURl"],
        thumbnailUrl: json["thumbnailUrl"],
      );

  Map<String, dynamic> toJson() => {
        "video_id": videoId,
        "username": username,
        "uid": uid,
        "caption": caption,
        "hotelName": hotelName,
        "videoURl": videoURl,
        "profilePhoto": photoUrl,
        "thumbnailUrl": thumbnailUrl,
        "reportCount": reportCount,
        "comments": comments,
      };
}
