import 'package:cached_network_image/cached_network_image.dart';
import 'package:chitchat/firebaseservises/firebaseservice.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../core/models/message.dart';
import '../../../shared/widgets/date_time.dart';

class MessageCard extends StatelessWidget {
  MessageCard({super.key, required this.message});
  final Message message;
  @override
  Widget build(BuildContext context) {
    return FirebaseServises.user.uid == message.fromId
        ? _bluemessage(context)
        : _blackmessage(context);
  }

  Widget _blackmessage(BuildContext context) {
    //update last read message if sender and reciever are different
    if (message.read.isEmpty) {
      FirebaseServises.updateReadStatus(message);
    }
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                message.type == Type.text
                    ? Text(
                        message.message,
                        style: TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(255, 255, 255, 255)),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CachedNetworkImage(
                          // height: ,
                          fit: BoxFit.fill,
                          imageUrl: message.message,
                          placeholder: (context, url) =>
                              CupertinoActivityIndicator(),
                          errorWidget: (context, url, error) => Image.asset(
                            'asset/icons/applogo.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                Visibility(
                  visible: message.read.isNotEmpty,
                  child: Icon(
                    Icons.done_all,
                    color: Color.fromARGB(255, 0, 245, 241),
                    size: 18,
                  ),
                )
              ],
            ),
          ),
        ),
        SizedBox(),
        Padding(
          padding: const EdgeInsets.only(right: 15.0),
          child: Text(
            MyDateTime.formattedDateTime(context: context, time: message.sent),
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(147, 14, 13, 13)),
          ),
        ),
      ],
    );
  }

  Widget _bluemessage(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: Text(
            MyDateTime.formattedDateTime(context: context, time: message.sent),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                message.type == Type.text
                    ? Text(
                        message.message,
                        style: TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(255, 255, 255, 255)),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CachedNetworkImage(
                          // height: ,
                          fit: BoxFit.fill,
                          imageUrl: message.message,
                          placeholder: (context, url) =>
                              CupertinoActivityIndicator(),
                          errorWidget: (context, url, error) => Image.asset(
                            'asset/icons/applogo.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                Visibility(
                  visible: message.read.isNotEmpty,
                  child: Icon(
                    Icons.done_all,
                    color: Color.fromARGB(255, 0, 245, 241),
                    size: 18,
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
