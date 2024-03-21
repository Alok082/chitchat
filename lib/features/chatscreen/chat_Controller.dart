import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  var isKeyboardVisible = false;
  bool iswriting = false;
  void settextfieldicon() {
    iswriting = !iswriting;
    update();
  }

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

