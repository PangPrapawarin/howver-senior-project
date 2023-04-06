import 'package:cloud_firestore/cloud_firestore.dart';

class Hotel {
  String id;
  String hotelName;
  String phone;
  String size;
  String starRate;
  String style;
  String facebook;
  String website;
  String location;
  String type;
  String detail;

  Hotel({
    required this.hotelName,
    required this.id,
    required this.phone,
    required this.size,
    required this.starRate,
    required this.style,
    required this.facebook,
    required this.website,
    required this.location,
    required this.type,
    required this.detail,
  });

  Map<String, dynamic> toJson() => {
        "hotelName": hotelName,
        "phone": phone,
        "size": size,
        "starRate": starRate,
        "style": style,
        "facebook": facebook,
        "website": website,
        "location": location,
        "id": id,
        "type": type,
        "detail": detail,
      };

  //from map
  factory Hotel.fromJson(Map<String, dynamic> json) => Hotel(
        hotelName: json["hotelName"],
        phone: json["phone"],
        size: json["size"],
        id: json["id"],
        starRate: json["starRate"],
        style: json["style"],
        facebook: json["facebook"],
        website: json["website"],
        location: json["location"],
        type: json["type"],
        detail: json["detail"],
      );

  static Hotel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Hotel(
        id: snapshot["id"],
        hotelName: snapshot["hotelName"],
        phone: snapshot["phone"],
        size: snapshot["size"],
        starRate: snapshot["starRate"],
        style: snapshot["style"],
        facebook: snapshot["facebook"],
        website: snapshot["website"],
        location: snapshot["location"],
        type: snapshot["type"],
        detail: snapshot["detail"]);
  }
}
