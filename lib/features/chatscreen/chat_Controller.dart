import 'dart:io';

import 'package:chitchat/core/models/user_data_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../firebaseservises/firebaseservice.dart';
import '../../shared/widgets/helper.dart';

class ChatController extends GetxController {
  bool isUploading = false;
  // for showing the emogi
  bool showemogi = false;
  var isKeyboardVisible = false;
  bool iswriting = false;

  void settextfieldicon() {
    iswriting = !iswriting;

    update();
  }

  void showEmogi() {
    showemogi = !showemogi;
    update();
  }

  // for sending the message
  String? image;
  void sendimage(String fileimage, UserData userdata) async {
    try {
      isUploading = true;
      update();
      image = fileimage;
      await FirebaseServises.sendChatImage(userdata, File(image!));
      update();
    } catch (e) {
      DynamicHelperWidget.show("Unable to send images");
    } finally {
      isUploading = false;
      update();
    }

    // DynamicHelperWidget.show("Profile Picture Updated Successfully");
  }

  void uploading() {}

  // void addChatMessage(String sender, String text, String time) {
  //   ChatMessage newMessage = ChatMessage(
  //     sender: sender,
  //     text: text,
  //     timestamp: time,
  //   );

  //   chatMessages.add(newMessage);
  //   update();
  // }

  // List<ChatMessage> chatMessages = [
  //   ChatMessage(
  //     sender: 'John Doe',
  //     text:
  //         "Thank you for contacting GTCA Please choose the option that best describes your reason for contact today",
  //     timestamp: "3:02 AM",
  //   ),
  //   ChatMessage(
  //     sender: 'self',
  //     text: 'Hi ',
  //     timestamp: "5:02 PM",
  //   ),
  //   ChatMessage(
  //     sender: 'John Doe',
  //     text: 'That\'s good to hear!',
  //     timestamp: "8:02 AM",
  //   ),
  //   ChatMessage(
  //     sender: 'self',
  //     text: 'Hey guys, what\'s up?',
  //     timestamp: "9:45 PM",
  //   ),
  //   ChatMessage(
  //     sender: 'John Doe',
  //     text: 'Not much, just chilling. How about you?',
  //     timestamp: "8:12 AM",
  //   ),
  //   ChatMessage(
  //       sender: 'self',
  //       text: 'Just got back from work, feeling tired.',
  //       timestamp: "5:02 AM"),
  //   ChatMessage(
  //       sender: 'John Doe',
  //       text: 'Just got back from work, feeling tired.',
  //       timestamp: "7:02 AM"),
  //   ChatMessage(
  //       sender: 'self',
  //       text: 'Just got back from work, feeling tired.',
  //       timestamp: "1:02 PM"),
  // ];
}

//model class for chat screen
