import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:howver/controllers/add_hotel_controller.dart';
import 'package:howver/controllers/home_controller.dart';
import 'package:howver/utils/colors.dart';
import 'package:howver/utils/constants.dart';
import 'package:howver/widgets/custom_button.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';

class AddHotelScreen extends StatefulWidget {
  const AddHotelScreen({super.key});

  @override
  State<AddHotelScreen> createState() => _AddHotelScreenState();
}

class _AddHotelScreenState extends State<AddHotelScreen> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController facebookController = TextEditingController();
  TextEditingController websiteController = TextEditingController();
  double rating = 0.0;
  String? typeOfAccommodation;
  String? styleOfAccommodation;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.greyColor,
        elevation: 0.0,
        centerTitle: true,
        title: const Text('New Hotel', style: TextStyle(color: Colors.black)),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                Get.put(HomeController()).onItemTapped(1);
                Get.back();
              },
              child: Image.asset(
                'assets/images/arrow_back.png',
              ),
            ),
          ),
        ],
      ),
      body: GetBuilder(
          init: AddHotelController(),
          builder: (controller) {
            return controller.isLoading.value
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text(
                                'Hotel Name',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: SizedBox(
                                  height: 40,
                                  child: TextField(
                                    controller: controller.hotelNameController,
                                    decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.all(10),
                                      hintText: 'Name of accommodation',
                                      border: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              const Text(
                                'Star Rate',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(width: 10),
                              SmoothStarRating(
                                allowHalfRating: true,
                                onRatingChanged: (v) {
                                  rating = v;
                                  setState(() {});
                                },
                                starCount: 5,
                                rating: rating,
                                size: 40.0,
                                defaultIconData: Icons.star_outline_rounded,
                                filledIconData: Icons.star_rounded,
                                halfFilledIconData: Icons.star_half_rounded,
                                color: Colors.black,
                                borderColor: Colors.black,
                                spacing: 0.0,
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          //type of accomodation dropdown
                          Row(
                            children: [
                              const Text(
                                'Type',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(width: 10),
                              //dropdown

                              CustomDropDown(
                                hint: 'Type of accommodation',
                                dropdownValue: typeOfAccommodation,
                                list: const [
                                  'Standard Room',
                                  'Deluxe Room',
                                  'Suite Room',
                                  'Villa',
                                ],
                                onChanged: (String? newValue) {
                                  setState(() {
                                    typeOfAccommodation = newValue;
                                  });
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          //type of accomodation dropdown
                          Row(
                            children: [
                              const Text(
                                'Style',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(width: 10),
                              //dropdown

                              CustomDropDown(
                                dropdownValue: styleOfAccommodation,
                                hint: 'Style of accommodation',
                                list: const [
                                  'Traditional Rooms',
                                  'Contemporary Rooms',
                                  'Boutique Rooms',
                                ],
                                onChanged: (String? newValue) {
                                  setState(() {
                                    styleOfAccommodation = newValue;
                                  });
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Size',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                Radio(
                                  activeColor: Colors.black,
                                  value: 0,
                                  groupValue: controller.sizeGroupValue.value,
                                  onChanged: controller.onSizeGroupChanged,
                                ),
                                const Text('small'),
                                Radio(
                                  activeColor: Colors.black,
                                  value: 1,
                                  groupValue: controller.sizeGroupValue.value,
                                  onChanged: controller.onSizeGroupChanged,
                                ),
                                const Text('medium'),
                                Radio(
                                  activeColor: Colors.black,
                                  value: 2,
                                  groupValue: controller.sizeGroupValue.value,
                                  onChanged: controller.onSizeGroupChanged,
                                ),
                                const Text('large'),
                                Radio(
                                  activeColor: Colors.black,
                                  value: 3,
                                  groupValue: controller.sizeGroupValue.value,
                                  onChanged: controller.onSizeGroupChanged,
                                ),
                                const Text('very large'),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Text(
                                'Location',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: SizedBox(
                                  height: 40,
                                  child: TextField(
                                    controller: controller.locationController,
                                    decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.all(10),
                                      hintText: 'Location',
                                      border: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Contact',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Image.asset(
                                'assets/images/site.png',
                                height: 30,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: SizedBox(
                                  height: 40,
                                  child: TextField(
                                    controller: websiteController,
                                    decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.all(10),
                                      hintText: 'Link for website',
                                      border: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Image.asset(
                                'assets/images/fb.png',
                                height: 30,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: SizedBox(
                                  height: 40,
                                  child: TextField(
                                    controller: facebookController,
                                    decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.all(10),
                                      hintText: 'Link for Facebook Page',
                                      border: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Image.asset(
                                'assets/images/call.png',
                                height: 30,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: SizedBox(
                                  height: 40,
                                  child: TextField(
                                    controller: phoneController,
                                    decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.all(10),
                                      hintText: 'Phone number',
                                      border: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: CustomButton(
                              onPressed: () {
                                if (controller
                                        .hotelNameController.text.isNotEmpty &&
                                    typeOfAccommodation != null &&
                                    styleOfAccommodation != null &&
                                    controller.sizeGroupValue.value != -1 &&
                                    controller
                                        .locationController.text.isNotEmpty) {
                                  controller.onSubmitHotel(
                                    hotelName:
                                        controller.hotelNameController.text,
                                    stars: rating,
                                    phoneNum: phoneController.text,
                                    linkWebsite: websiteController.text,
                                    linkFB: facebookController.text,
                                    type: typeOfAccommodation!,
                                    location:
                                        controller.locationController.text,
                                    style: styleOfAccommodation!,
                                    size: controller.sizeToString(),
                                    uid: authController.user.uid,
                                  );
                                } else {
                                  Get.snackbar(
                                      'Error', 'Please fill all the fields');
                                }
                              },
                              btnText: 'SUBMIT',
                              widthPercent: .25,
                              radius: 90,
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  );
          }),
    );
  }
}

class CustomDropDown extends StatelessWidget {
  final String? dropdownValue;
  final String hint;
  final void Function(String?)? onChanged;
  final List<String> list;
  const CustomDropDown(
      {super.key,
      required this.dropdownValue,
      this.onChanged,
      required this.list,
      required this.hint});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButton<String?>(
        underline: const SizedBox(),
        hint: Text('$hint     '),
        value: dropdownValue,
        icon: const Icon(
          Icons.arrow_drop_down_circle_outlined,
        ),
        items: list.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}
