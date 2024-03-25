import 'package:cached_network_image/cached_network_image.dart';
import 'package:chitchat/core/models/message.dart';
import 'package:chitchat/features/homescreen/services/home_controller.dart';
import 'package:chitchat/firebaseservises/firebaseservice.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/models/user_data_model.dart';
import '../../../dependency_injection.dart';
import '../../../shared/widgets/date_time.dart';

// ignore: must_be_immutable
class ChatUserCard extends StatelessWidget {
  final UserData userdata;
  ChatUserCard({super.key, required this.userdata});
  // last message (if null no message )
  Message? messages;
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder(
          stream: FirebaseServises.getLastMessage(userdata),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.none:
                return const Center(
                  child: CircularProgressIndicator(),
                );
              case ConnectionState.active:
              case ConnectionState.done:
                final datas = snapshot.data?.docs;

                final list =
                    datas!.map((e) => Message.fromJson(e.data())).toList();
                if (list.isNotEmpty) {
                  messages = list[0];
                }
                return Card(
                  color: const Color.fromARGB(255, 19, 28, 23),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        // padding: EdgeInsets.all(10),
                        margin: const EdgeInsets.all(10),
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(60)),
                        child: InkWell(
                          onTap: () {
                            locator<HomeController>().viewpProfile(
                              userdata.image,
                            );
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(60),
                            child: CachedNetworkImage(
                              // height: ,
                              fit: BoxFit.fill,
                              imageUrl: userdata.image,
                              placeholder: (context, url) =>
                                  const CupertinoActivityIndicator(),
                              errorWidget: (context, url, error) => Image.asset(
                                'asset/icons/applogo.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userdata.name,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                              messages != null
                                  ? messages!.type == Type.image
                                      ? 'image'
                                      : messages!.message
                                  : userdata.about,
                              maxLines: 1,
                              style: const TextStyle(
                                  color: Colors.white,
                                  overflow: TextOverflow.ellipsis)),
                        ],
                      ),
                      const Spacer(),
                      if (messages != null) // Add this conditional statement
                        messages!.read.isEmpty &&
                                messages!.fromId != FirebaseServises.user.uid
                            ? const Icon(
                                Icons.circle,
                                color: Colors.lightGreenAccent,
                                size: 15,
                              )
                            : Text(
                                MyDateTime.lastMessageTime(
                                    context: context, time: messages!.sent),
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                      const SizedBox(
                        width: 15,
                      )
                    ],
                  ),
                );
            }
          },
        )

        //
        );
  }
}
