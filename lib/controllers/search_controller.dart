import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:howver/models/video.dart';
import 'package:howver/utils/constants.dart';

class SearchController extends GetxController {

  final Rx<List<Video>> _searchedVideos = Rx<List<Video>>([]);
  
  List<Video> get searchedVideos => _searchedVideos.value;
  searchVideo(String typedVideo) async {
    _searchedVideos.bindStream(
      firestore
          .collection('videos')
          .where('hotelName', isEqualTo: typedVideo)
          .snapshots()
          .map(
        (QuerySnapshot query) {
          List<Video> retVal = [];
          for (var element in query.docs) {
            retVal.add(Video.fromSnap(element));
          }
          return retVal;
        },
      ),
    );
  }
}
