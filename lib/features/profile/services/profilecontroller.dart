import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../firebaseservises/firebaseservice.dart';

class ProfileController extends GetxController {
  String? image;
  void updateProfilePicture(String fileimage) {
    image = fileimage;
    FirebaseServises.updateprofilepicture(File(image!));
    update();
    Get.back();
  }
}
