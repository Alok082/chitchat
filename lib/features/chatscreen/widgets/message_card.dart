import 'package:chitchat/firebaseservises/firebaseservice.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../core/models/message.dart';

class MessageCard extends StatelessWidget {
  MessageCard({super.key, required this.message});
  final Message message;
  @override
  Widget build(BuildContext context) {
    return FirebaseServises.user.uid == message.fromId
        ? _bluemessage()
        : _blackmessage();
  }

  Widget _blackmessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Container(
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 19, 23, 16),
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30),
                    topLeft: Radius.circular(30),
                    bottomLeft: Radius.zero,
                    bottomRight: Radius.circular(30))),
            padding: const EdgeInsets.all(10.0),
            child: Text(
              message.message * 10,
              style: TextStyle(
                  fontSize: 16, color: Color.fromARGB(255, 255, 255, 255)),
            ),
          ),
        ),
        SizedBox(),
        Padding(
          padding: const EdgeInsets.only(right: 15.0),
          child: Text(
            message.sent,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(147, 14, 13, 13)),
          ),
        ),
      ],
    );
  }

  Widget _bluemessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: Text(
            message.sent,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(147, 14, 13, 13)),
          ),
        ),
        Flexible(
          child: Container(
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 70, 153, 186),
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30),
                    topLeft: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.zero)),
            padding: const EdgeInsets.all(10.0),
            child: Text(
              message.message,
              style: TextStyle(
                  fontSize: 16, color: Color.fromARGB(255, 255, 255, 255)),
            ),
          ),
        ),
      ],
    );
  }
}
