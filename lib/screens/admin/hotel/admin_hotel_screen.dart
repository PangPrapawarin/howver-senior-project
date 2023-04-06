import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:howver/controllers/admin_home_controller.dart';
import 'package:howver/models/hotel.dart';
import 'package:howver/screens/admin/hotel/edit_hotel_screen.dart';
import 'package:howver/screens/auth/login_screen.dart';
import 'package:howver/utils/colors.dart';
import 'package:howver/widgets/custom_button.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';

class AdminHotelScreen extends StatefulWidget {
  const AdminHotelScreen({super.key});

  @override
  State<AdminHotelScreen> createState() => _AdminHotelScreenState();
}

class _AdminHotelScreenState extends State<AdminHotelScreen> {
  @override
  void initState() {
    Get.put(AdminHomeController()).getAllHotels();
    super.initState();
  }

  double getStars(Hotel hotel) {
    switch (hotel.starRate) {
      case '1.0':
        return 1.0;
      case '1.5':
        return 1.5;

      case '2.0':
        return 2.0;
      case '2.5':
        return 2.5;

      case '3.0':
        return 3.0;
      case '3.5':
        return 3.5;

      case '4.0':
        return 4.0;
      case '4.5':
        return 4.5;

      case '5.0':
        return 5.0;

      default:
        return 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: AdminHomeController(),
        builder: (controller) {
          return RefreshIndicator(
            onRefresh: () async {
              controller.getAllHotels();
            },
            child: Scaffold(
              appBar: AppBar(
                elevation: 0.0,
                backgroundColor: AppColors.greyColor,
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: CustomButton(
                      onPressed: () {
                        Get.offAll(() => LoginScreen());
                      },
                      radius: 10,
                      btnText: 'Logout',
                      widthPercent: 0.24,
                    ),
                  ),
                ],
                title: const Text(
                  'Hotel Detail',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              body: Obx(
                () => ListView.builder(
                  itemCount: controller.allHotels.length,
                  itemBuilder: (context, index) {
                    var hotel = controller.allHotels[index];
                    return HotelDetailItem(
                      hotelName: hotel.hotelName,
                      onEdit: () {
                        Get.to(
                          () => EditHotelScreen(
                            hotel: hotel,
                          ),
                        );
                      },
                      stars: double.parse(hotel.starRate),
                      type: hotel.type,
                      style: hotel.style,
                      size: hotel.size,
                      websiteLink: hotel.website,
                      fbLink: hotel.facebook,
                      phoneNumber: hotel.phone,
                    );
                  },
                ),
              ),
            ),
          );
        });
  }
}

class HotelDetailItem extends StatelessWidget {
  final String hotelName;
  final double stars;
  final String type;
  final String style;
  final String size;
  final String websiteLink;
  final String fbLink;
  final String phoneNumber;
  final VoidCallback onEdit;

  const HotelDetailItem({
    super.key,
    required this.hotelName,
    required this.stars,
    required this.type,
    required this.style,
    required this.size,
    required this.websiteLink,
    required this.fbLink,
    required this.phoneNumber,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.greyColor,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                hotelName,
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
              const Spacer(),
              SizedBox(
                height: 30,
                child: ElevatedButton(
                  onPressed: onEdit,
                  style: ElevatedButton.styleFrom(
                    elevation: 0.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: Colors.black,
                  ),
                  child: const Text(
                    'EDIT',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Text(
                'Star Rate',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: SmoothStarRating(
                  rating: stars,
                  color: Colors.black,
                  borderColor: Colors.black,
                  filledIconData: Icons.star_rate_rounded,
                  defaultIconData: Icons.star_border_rounded,
                  size: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text('$type | $style | $size'),
          const SizedBox(height: 10),
          Row(
            children: [
              Image.asset('assets/images/site.png', height: 16),
              const SizedBox(width: 5),
              Text(websiteLink),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Image.asset('assets/images/fb.png', height: 16),
              const SizedBox(width: 5),
              Text(fbLink),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Image.asset('assets/images/call.png', height: 16),
              const SizedBox(width: 5),
              Text(phoneNumber),
              const Spacer(),
              Image.asset('assets/images/location.png', height: 16),
              Text(hotelName),
            ],
          ),
        ],
      ),
    );
  }
}
