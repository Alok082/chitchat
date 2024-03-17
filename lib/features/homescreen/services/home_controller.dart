import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  ScrollController scrollController = ScrollController();
  bool isTitleVisible = false;

  void onInit() {
    super.onInit();
    scrollController.addListener(() {
      isTitleVisible = scrollController.offset >= 150;
    });
  }
}
