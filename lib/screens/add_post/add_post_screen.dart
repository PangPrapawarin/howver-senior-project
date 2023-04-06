import 'dart:io';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:howver/controllers/add_post_controller.dart';
import 'package:howver/controllers/home_controller.dart';
import 'package:howver/models/hotel.dart';
import 'package:howver/utils/colors.dart';
import 'package:howver/widgets/custom_button.dart';
import 'package:image_picker/image_picker.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  String? selectedHotel;
  late Hotel hotel;
  File? _file;
  pickVideo(ImageSource src, BuildContext context) async {
    final video = await ImagePicker().pickVideo(source: src);
    if (video != null) {
      // UploadVideoController uploadVideoController = Get.put(UploadVideoController());
      _file = File(video.path);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.greyColor,
        elevation: 0.0,
        centerTitle: true,
        title: const Text('New Post', style: TextStyle(color: Colors.black)),
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : GetBuilder(
              init: AddPostController(),
              builder: (controller) {
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Container(
                                height: 200,
                                decoration: BoxDecoration(
                                  image: const DecorationImage(
                                    image: AssetImage('assets/images/bg.png'),
                                    fit: BoxFit.cover,
                                  ),
                                  border: Border.all(
                                    color: Colors.grey,
                                  ),
                                ),
                                child: SimpleDialogOption(
                                  onPressed: () =>
                                      pickVideo(ImageSource.gallery, context),
                                  padding: const EdgeInsets.all(40.0),
                                  child:
                                      Image.asset('assets/images/camera.png'),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              flex: 2,
                              child: TextField(
                                maxLines: 10,
                                minLines: 1,
                                controller: controller.caption,
                                decoration: const InputDecoration(
                                  hintText: 'Write a caption...',
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
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
                                child: DropdownSearch<String>(
                                  onChanged: (value) {
                                    if (controller.allHotelsList.isNotEmpty) {
                                      selectedHotel = value!;
                                      setState(() {});
                                    }
                                    selectedHotel == 'Add new hotel'
                                        ? Get.put(HomeController())
                                            .goToAddHotelPage()
                                        : null;
                                  },
                                  items: controller.allHotelsList.isEmpty
                                      ? ['Add new hotel']
                                      : List.generate(
                                          controller.allHotelsList.length,
                                          (index) => controller
                                              .allHotelsList[index].hotelName,
                                        ),
                                  dropdownDecoratorProps:
                                      DropDownDecoratorProps(
                                          dropdownSearchDecoration:
                                              InputDecoration(
                                    prefixIcon: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Image.asset(
                                          'assets/images/search.png'),
                                    ),
                                    hintText: 'Search...',
                                    contentPadding: const EdgeInsets.all(10),
                                    border: const OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black),
                                    ),
                                    focusedBorder: const OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black),
                                    ),
                                    enabledBorder: const OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black),
                                    ),
                                  )),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: CustomButton(
                            onPressed: () async {
                              loading = true;
                              setState(() {});
                              if (selectedHotel != null &&
                                  _file != null &&
                                  selectedHotel != 'Add new hotel' &&
                                  controller.caption.text.isNotEmpty) {
                                await controller.uploadVideo(
                                    controller.caption.text,
                                    _file!.path,
                                    selectedHotel!);
                              } else {
                                Get.snackbar('Error', 'Please fill all fields');
                                loading = false;
                                setState(() {});
                              }
                              loading = false;
                              setState(() {});
                            },
                            btnText: 'Share',
                            widthPercent: .22,
                            radius: 90,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
    );
  }
}
