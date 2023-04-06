import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:howver/controllers/search_controller.dart';
import 'package:howver/screens/profile/user_videos_screen.dart';

class VideosSearchScreen extends StatelessWidget {
  final String searchText;
  const VideosSearchScreen({super.key, required this.searchText});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: SearchController(),
        builder: (controller) {
          controller.searchVideo(searchText);
          return Obx(
            () => Padding(
              padding: const EdgeInsets.all(0.0),
              child: GridView.builder(
                itemCount: controller.searchedVideos.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.0,
                  mainAxisSpacing: 0.0,
                  crossAxisSpacing: 0.0,
                  mainAxisExtent: 250,
                ),
                itemBuilder: (context, index) {
                  var video = controller.searchedVideos[index];
                  return GestureDetector(
                    onTap: () {
                      Get.to(
                          () => UserVideoScreen(uid: video.uid, index: index));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black.withOpacity(0.3),
                        ),
                        image: DecorationImage(
                          image: NetworkImage(
                            video.thumbnail,
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                      padding: const EdgeInsets.only(bottom: 5, left: 4),
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: const Color(0xffB2CBE5),
                            backgroundImage: NetworkImage(
                              video.profilePhoto,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  video.username,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    shadows: [
                                      Shadow(
                                        blurRadius: 10,
                                      )
                                    ],
                                    fontSize: 12,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  video.caption,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    shadows: [
                                      Shadow(
                                        blurRadius: 10,
                                      )
                                    ],
                                    fontSize: 12,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                //location icon
                                Row(
                                  children: [
                                    Image.asset(
                                      'assets/images/location.png',
                                      height: 20,
                                      color: Colors.white,
                                    ),
                                    Expanded(
                                      child: Text(
                                        video.hotelName,
                                        style: const TextStyle(
                                          shadows: [
                                            Shadow(
                                              blurRadius: 10,
                                            )
                                          ],
                                          fontSize: 12,
                                          overflow: TextOverflow.ellipsis,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Image.asset(
                                'assets/images/liked.png',
                                height: 15,
                                color: Colors.white,
                              ),
                              Text(
                                video.likes.length.toString(),
                                style: const TextStyle(
                                  shadows: [
                                    Shadow(
                                      blurRadius: 10,
                                    )
                                  ],
                                  fontSize: 12,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 10),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        });
  }
}
