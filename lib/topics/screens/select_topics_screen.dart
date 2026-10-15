import 'package:bookish/util/enums.dart';
import 'package:bookish/util/utility.dart';
import 'package:bookish/widgets/bookish_error_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/chip_data.dart';
import '../controller/book_topics_controller.dart';

class SelectTopicsScreen extends GetView<SelectTopicController> {
  static String routeName = "/select-topics";

  @override
  Widget build(BuildContext context) {
    Get.put(SelectTopicController());
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
          title: Text("Select topics"), automaticallyImplyLeading: false),
      body: Stack(
        children: [
          DefaultTabController(
            length: 2,
            child: Builder(
              builder: (context) {
                final tabController = DefaultTabController.of(context);
                tabController.addListener(() {
                  controller.updateCurrentSelectedIndex(tabController.index);
                });
                return Column(
                  children: [
                    ColoredBox(
                      color: Colors.white,
                      child: TabBar(
                        labelPadding: EdgeInsets.all(8),
                        indicatorColor: Colors.black,
                        indicatorWeight: 4,
                        tabs: [
                          Text(
                            "Fiction",
                            style: GoogleFonts.roboto(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Colors.black),
                          ),
                          Text(
                            "Non-fiction",
                            style: GoogleFonts.roboto(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Colors.black),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 16.r,
                    ),
                    Expanded(
                      child: Obx(() {
                        if (controller.isLoading.value) {
                          return Center(
                            child: const CircularProgressIndicator(),
                          );
                        } else if (controller.fictionList.isNotEmpty &&
                            controller.nonFictionList.isNotEmpty) {
                          return _buildBookTopicsTab();
                        } else {
                          return BookishErrorWidget(
                              onRetryClicked: () {
                                controller.onRetryClicked();
                              },
                              errorMessage: "Something went wrong.");
                        }
                      }),
                    )
                  ],
                );
              },
            ),
          ),
          _buildSubmitButton()
        ],
      ),
    );
  }

  Widget _buildBookTopicsTab() {
    return Container(
      child: TabBarView(children: [
        _buildFictionCategory(controller.fictionList),
        _buildFictionCategory(controller.nonFictionList),
      ]),
    );
  }

  Widget _getFilterChip(ChipData chipData) {
    return FilterChip(
      selected: controller.isChipSelected(chipData),
      selectedColor: Colors.blue.shade800,
      disabledColor: Colors.blue.shade400,
      labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      label: Text(chipData.title ?? ""),
      onSelected: (bool value) {
        controller.onChipSelected(chipData, value);
      },
    );
  }

  Widget _buildFictionCategory(List<ChipData>? chipData) {
    if (chipData == null || chipData.isEmpty) {
      return Text('Unable to load categories');
    }
    return Padding(
      padding: EdgeInsets.only(left: 16.r, right: 16.r),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Wrap(
              spacing: 16.r,
              alignment: WrapAlignment.start,
              children: <Widget>[
                ...chipData.map((chip) => _getFilterChip(chip)).toList()
              ],
            ),
            // SizedBox(height: MediaQuery.sizeOf(context).height * 0.1,)
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Positioned(
      bottom: 16.r,
      left: 24.r,
      right: 24.r,
      child: Container(
        height: 48.r,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.r),
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey,
                foregroundColor: Colors.white),
            onPressed: () {
              if (controller.selectedFictionList.isNotEmpty ||
                  controller.selectedNonFictionList.isNotEmpty) {
                controller.subscribeUserTopics();
              } else {
                Utility.showSnackBar(
                    Get.context!, "Please select at-least one category");
              }
            },
            label: Text(
              "Done",
              style:
                  GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.w400),
            ),
            icon: controller.buttonState.value == ButtonState.loading
                ? _showLoader()
                : Container(),
          ),
        ),
      ),
    );
  }

  Widget _showLoader() {
    return Container(
      width: 24.r,
      height: 24.r,
      padding: const EdgeInsets.all(2.0),
      child: const CircularProgressIndicator(
        color: Colors.white,
        strokeWidth: 3,
      ),
    );
  }
}
