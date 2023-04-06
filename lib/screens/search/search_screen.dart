import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:howver/controllers/home_controller.dart';
import 'package:howver/controllers/search_controller.dart';
import 'package:howver/enums/home_pages_enum.dart';
import 'package:howver/screens/search/videos/videos_search_screen.dart';
import 'package:howver/utils/colors.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  var homeController = Get.put(HomeController());
  TextEditingController searchTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: SearchController(),
      builder: (controller) {
        return WillPopScope(
          onWillPop: () async {
            homeController.goBackToHomePage();

            return homeController.homePages != HomePages.search;
          },
          child: DefaultTabController(
            length: 3,
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: AppColors.greyColor,
                elevation: 0.0,
                leading: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Image.asset('assets/images/search.png'),
                ),
                title: SizedBox(
                  height: 40,
                  child: TextField(
                    controller: searchTextController,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.all(10.0),
                      hintText: 'Searching for...',
                      hintStyle: TextStyle(
                        color: Color(0xff5B5B5B),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                        borderSide: BorderSide(color: Colors.black, width: 1.2),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1.2),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1.2),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        homeController.goBackToHomePage();
                        homeController.homePages != HomePages.search
                            ? Get.back()
                            : null;
                      },
                      child: Image.asset(
                        'assets/images/arrow_back.png',
                      ),
                    ),
                  ),
                ],
              ),
              body: ValueListenableBuilder(
                  valueListenable: searchTextController,
                  builder: (context, val, c) {
                    return searchTextController.text.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [],
                            ),
                          )
                        :
                        VideosSearchScreen(
                            searchText: searchTextController.text,
                          );
                  }),
            ),
          ),
        );
      },
    );
  }
}
