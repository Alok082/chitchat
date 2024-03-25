import 'package:chitchat/core/models/user_data_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../firebaseservises/firebaseservice.dart';

class HomeController extends GetxController {
  ScrollController scrollController = ScrollController();
  bool isTitleVisible = false;
  bool isSearching = false;
  List<UserData> userdatalist = [];
  bool viewprofile = false;
  String currentuserimage = 'asset/icons/applogo.png';

  @override
  void onInit() {
    super.onInit();

    FirebaseServises.storeuser();
    // updating status according to life cycle
    FirebaseServises.updateActiveStatus(true);
    SystemChannels.lifecycle.setMessageHandler((message) {
      // print("><><><><><><>Message :$message");
      if (FirebaseServises.auth.currentUser != null) {
        if (message.toString().contains('resumed')) {
          FirebaseServises.updateActiveStatus(true);
        }

        if (message.toString().contains('paused')) {
          FirebaseServises.updateActiveStatus(false);
        }
      }

      return Future.value(message);
    });
    scrollController.addListener(() {
      isTitleVisible = scrollController.offset >= 150;
      update();
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

  // view profile pic from home screen
  void viewpProfile(String image) {
    currentuserimage = image;
    viewprofile = true;
    update();
  }

  void setvisibilityprofile() {
    viewprofile = false;
    update();
  }
}
