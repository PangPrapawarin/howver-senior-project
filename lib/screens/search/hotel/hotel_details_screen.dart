import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:howver/controllers/add_hotel_controller.dart';
import 'package:howver/controllers/home_controller.dart';
import 'package:howver/screens/profile/user_videos_screen.dart';
import 'package:howver/utils/colors.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';

class HotelDetailsScreen extends StatefulWidget {
  final String hotelName;
  final String location;
  final double rating;
  final String fb;
  final String website;
  final String phone;
  final String id;

  const HotelDetailsScreen(
      {super.key,
      required this.hotelName,
      required this.location,
      required this.rating,
      required this.fb,
      required this.website,
      required this.phone,
      required this.id});

  @override
  State<HotelDetailsScreen> createState() => _HotelDetailsScreenState();
}

class _HotelDetailsScreenState extends State<HotelDetailsScreen> {
  var homeController = Get.put(HomeController());
  bool isFollowing = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        homeController.onHotelDetailsBack();
        return Future.value(false);
      },
      child: GetBuilder(
          init: AddHotelController(),
          builder: (controller) {
            return Scaffold(
              body: SafeArea(
                child: Column(
                  children: [
                    Container(
                      color: AppColors.greyColor,
                      child: Column(
                        children: [
                          ListTile(
                            title: Text(
                              widget.hotelName,
                              style: const TextStyle(
                                fontSize: 17,
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            subtitle: Row(
                              children: [
                                const Text(
                                  'Rating from user',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Expanded(
                                  child: SmoothStarRating(
                                    rating: widget.rating,
                                    color: Colors.black,
                                    borderColor: Colors.black,
                                    filledIconData: Icons.star_rate_rounded,
                                    defaultIconData: Icons.star_border_rounded,
                                    size: 16,
                                  ),
                                ),
                              ],
                            ),
                            trailing: GestureDetector(
                              onTap: () {
                                Get.back();
                              },
                              child: Image.asset(
                                'assets/images/arrow_back.png',
                                height: 35,
                              ),
                            ),
                          ),
                          SizedBox(height: Get.height * 0.02),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    //location
                                    InkWell(
                                      onTap: () {
                                        Get.put(HomeController())
                                            .goToHotelLocationPage();
                                      },
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            'assets/images/location.png',
                                            height: 20,
                                          ),
                                          const SizedBox(width: 5),
                                          Text(
                                            widget.location,
                                            style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    //contact
                                    const Text(
                                      'Contact',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const SizedBox(height: 10),

                                    GestureDetector(
                                      onTap: () {
                                        //show dilog for site, fb and call
                                        Get.dialog(
                                          AlertDialog(
                                            title: const Text('Contact'),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                //site
                                                InkWell(
                                                  onTap: () {
                                                    Get.back();
                                                  },
                                                  child: Row(
                                                    children: [
                                                      Image.asset(
                                                        'assets/images/site.png',
                                                        height: 25,
                                                      ),
                                                      const SizedBox(width: 5),
                                                      Text(
                                                        widget.website,
                                                        style: const TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                                //fb
                                                InkWell(
                                                  onTap: () {
                                                    Get.back();
                                                  },
                                                  child: Row(
                                                    children: [
                                                      Image.asset(
                                                        'assets/images/fb.png',
                                                        height: 25,
                                                      ),
                                                      const SizedBox(width: 5),
                                                      Text(
                                                        widget.fb,
                                                        style: const TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                                //call
                                                InkWell(
                                                  onTap: () {
                                                    Get.back();
                                                  },
                                                  child: Row(
                                                    children: [
                                                      Image.asset(
                                                        'assets/images/call.png',
                                                        height: 25,
                                                      ),
                                                      const SizedBox(width: 5),
                                                      Text(
                                                        widget.phone,
                                                        style: const TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            'assets/images/site.png',
                                            height: 25,
                                          ),
                                          const SizedBox(width: 5),
                                          Image.asset(
                                            'assets/images/fb.png',
                                            height: 25,
                                          ),
                                          const SizedBox(width: 5),
                                          Image.asset(
                                            'assets/images/call.png',
                                            height: 25,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                    Expanded(
                      child: GetBuilder(
                          init: AddHotelController(),
                          builder: (controller) {
                            controller.getHotelVideos(widget.id);
                            return Obx(
                              () => GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  mainAxisExtent: 200,
                                ),
                                itemCount: controller.hotelVideos.length,
                                itemBuilder: (context, index) =>
                                    GestureDetector(
                                  onTap: () {
                                    Get.to(
                                      () => UserVideoScreen(
                                        uid: controller.hotelVideos[index].uid,
                                        index: index,
                                      ),
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: NetworkImage(
                                          controller
                                              .hotelVideos[index].thumbnail,
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                      border: Border.all(
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
