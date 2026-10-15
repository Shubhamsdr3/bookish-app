import 'package:bookish/createpost/ui/create_post_screen_v2.dart';
import 'package:bookish/home/controller/home_screen_controller.dart';
import 'package:bookish/profile/ui/screens/user_profile_screen.dart';
import 'package:bookish/util/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../feed/ui/home_feed_screen.dart';

class HomeScreen extends GetView<HomeScreenController> {
  static String routeName = "/home";

  final List<Widget> _pages = [HomeFeedScreen(), CreatePostScreen(), UserProfileScreen()];

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => PopScope(
        canPop: AppState().tabIndex.value == 0,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          if (AppState().tabIndex.value == 1) {
            _showPostExitDialog();
          } else if (AppState().tabIndex.value > 0) {
            AppState().tabIndex.value = 0;
          }
        },
        child: Scaffold(
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [Expanded(child: Obx(() => _pages[AppState().tabIndex.value]))],
            ),
          ),
          bottomNavigationBar: Obx(
            () => BottomNavigationBar(
              showUnselectedLabels: true,
              currentIndex: AppState().tabIndex.value,
              backgroundColor: Colors.white,
              elevation: 10.r,
              onTap: (index) {
                AppState().tabIndex.value = index;
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.post_add),
                  label: 'Post',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _showBackDialog(BuildContext context) {
    return AlertDialog(
      content: Container(
          margin: const EdgeInsets.only(left: 7),
          height: MediaQuery.sizeOf(context).height * 0.13,
          child: Column(
            children: [
              const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Are you sure to exit ?",
                    style: TextStyle(fontSize: 18),
                  )),
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.03,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Align(
                        alignment: Alignment.bottomLeft,
                        child: TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                            child: const Text("Cancel"))),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Get.back();
                          AppState().tabIndex.value = 0;
                        },
                        icon: Container(),
                        label: const Text("Okay"),
                        style: ButtonStyle(
                            foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
                            backgroundColor: WidgetStateProperty.all<Color>(Colors.teal)),
                      ),
                    ),
                  ],
                ),
              )
            ],
          )),
    );
  }

  Future<bool> _showPostExitDialog() async {
    final context = Get.context!;
    return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return _showBackDialog(context);
          },
        ) ??
        false;
  }
}
