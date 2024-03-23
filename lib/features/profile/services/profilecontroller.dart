import 'dart:io';

import 'package:chitchat/main.dart';
import 'package:chitchat/shared/widgets/helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../firebaseservises/firebaseservice.dart';
import '../screens/userprofile.dart';

class ProfileController extends GetxController {
  bool visible = false;
  // double containerheight = Get.height * 1;
  // double containerwidth = Get.width * 1;
  String? image;
  void updateProfilePicture(String fileimage) {
    image = fileimage;
    FirebaseServises.updateprofilepicture(File(image!));
    update();
    DynamicHelperWidget.show("Profile Picture Updated Successfully");
    Get.back();
  }

  void changecontainerPosition() {
    visible = !visible;

    update();
  }
}
