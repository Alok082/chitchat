import 'package:chitchat/core/models/user_data_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  ScrollController scrollController = ScrollController();
  bool isTitleVisible = false;
  bool isSearching = false;
  List<UserData> userdatalist = [];

  void onInit() {
    super.onInit();
    scrollController.addListener(() {
      isTitleVisible = scrollController.offset >= 150;
    });
  }

  void changeSearch() {
    isSearching = !isSearching;
    update();
  }

  // for implementing search functionality
  final List<UserData> searchlist = [];
  void searching(String val) {
    searchlist.clear();
    update();
    for (var i in userdatalist) {
      if (i.name.toLowerCase().contains(val.toLowerCase()) ||
          i.email.toLowerCase().contains(val.toLowerCase())) {
        searchlist.add(i);
        update();
      }
    }
  }
}
