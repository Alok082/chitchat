import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chitchat/core/models/message.dart';
import 'package:chitchat/core/models/user_data_model.dart';
import 'package:chitchat/features/chatscreen/chat_Controller.dart';
import 'package:chitchat/routes/app_routes.dart';
import 'package:chitchat/shared/widgets/date_time.dart';
import 'package:chitchat/shared/widgets/helper.dart';
import 'package:emoji_selector/emoji_selector.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../dependency_injection.dart';
import '../../../firebaseservises/firebaseservice.dart';
import '../widgets/bottomsheet_widget.dart';
import '../widgets/message_card.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({super.key});
  final UserData userdata = Get.arguments;
  final ScrollController _scrollController = ScrollController();
  //for handling messages
  TextEditingController messagecontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;
    // MediaQueryData mediaQuery = MediaQuery.of(context);

    var controller = locator<ChatController>();
    List<Message> list = [];

    return GestureDetector(
        onTap: () {
          if (controller.iswriting == true) {
            FocusManager.instance.primaryFocus!.unfocus();

            controller.settextfieldicon();
          }
          if (controller.showemogi == true) {
            controller.showEmogi();
          }
        },
        child: GetBuilder<ChatController>(
            init: ChatController(),
            builder: (_) {
              return Scaffold(
                appBar: AppBar(
                    leadingWidth: 30,
                    leading: IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: const Icon(Icons.navigate_before)),
                    backgroundColor: Colors.white,
                    automaticallyImplyLeading: false,
                    actions: [
                      Container(
                        height: height * 0.05,
                        width: height * 0.05,
                        margin: EdgeInsets.only(right: width * 0.04),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.black12)),
                        child: const Icon(Icons.more_vert),
                      )
                    ],
                    title: StreamBuilder(
                      stream: FirebaseServises.getUserInfo(userdata),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final datas = snapshot.data!.docs;

                          var list = datas
                              .map((e) => UserData.fromJson(e.data()))
                              .toList();

                          return InkWell(
                            onTap: () {
                              Get.toNamed(AppRoutes.viewOthersProfile,
                                  arguments: userdata);
                            },
                            child: Row(
                              children: [
                                Container(
                                  // padding: EdgeInsets.all(2.5),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      border: Border.all(
                                          color: Colors.amber, width: 2.3)),
                                  child: CircleAvatar(
                                    radius: 20,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: CachedNetworkImage(
                                        // height: ,
                                        fit: BoxFit.fill,
                                        imageUrl: list.isNotEmpty
                                            ? list[0].image
                                            : userdata.image,
                                        placeholder: (context, url) =>
                                            const CupertinoActivityIndicator(),
                                        errorWidget: (context, url, error) =>
                                            Image.asset(
                                          'asset/icons/applogo.png',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        list.isNotEmpty
                                            ? list[0].name
                                            : userdata.name,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 20),
                                      ),
                                      Text(
                                        list.isNotEmpty
                                            ? list[0].isOnline
                                                ? 'Online'
                                                : MyDateTime.getLastActiveTime(
                                                    context: context,
                                                    lastActive:
                                                        list[0].lastActive)
                                            : MyDateTime.getLastActiveTime(
                                                context: context,
                                                lastActive:
                                                    userdata.lastActive),
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                            color:
                                                Color.fromARGB(143, 0, 0, 0)),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else {
                          return CupertinoActivityIndicator();
                        }
                      },
                    )),
                body: Stack(
                  children: [
                    Column(
                      children: [
                        //
                        Expanded(
                          child: StreamBuilder(
                              stream:
                                  FirebaseServises.gettingallmessage(userdata),
                              builder: (context, snapshot) {
                                switch (snapshot.connectionState) {
                                  case ConnectionState.waiting:
                                  case ConnectionState.none:
                                    return const SizedBox();
                                  case ConnectionState.active:
                                  case ConnectionState.done:
                                    final datas = snapshot.data?.docs;
                                    list = datas!
                                        .map((e) => Message.fromJson(e.data()))
                                        .toList();
                                    // print(jsonEncode(datas![0].data()));
                                    // SchedulerBinding.instance
                                    //     .addPostFrameCallback((_) {
                                    //   _scrollController.animateTo(
                                    //     _scrollController.position.maxScrollExtent,
                                    //     duration: const Duration(milliseconds: 100),
                                    //     curve: Curves.linear,
                                    //   );
                                    // });

                                    if (list.isNotEmpty) {
                                      return ListView.builder(
                                          controller: _scrollController,
                                          shrinkWrap: true,
                                          reverse: true,
                                          itemCount: list.length,
                                          itemBuilder: (context, index) {
                                            // _scrollController.animateTo(
                                            //   _scrollController
                                            //       .position.maxScrollExtent,
                                            //   duration: Duration(milliseconds: 300),
                                            //   curve: Curves.easeOut,
                                            // );
                                            return MessageCard(
                                              message: list[index],
                                            );
                                          });
                                    } else {
                                      return const Center(
                                        child: Text(
                                          "Say Hi!",
                                          style: TextStyle(fontSize: 40),
                                        ),
                                      );
                                    }
                                }
                              }),
                        ),
                        if (controller.isUploading == true)
                          Container(
                            height: 50,
                            width: 200,
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 30, 29, 40),
                                borderRadius: BorderRadius.circular(18)),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Uploading",
                                  style: TextStyle(
                                      fontSize: 25, color: Colors.white),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                CupertinoActivityIndicator(
                                  color: Colors.white,
                                  radius: 15,
                                ),
                              ],
                            ),
                          ),
                        Container(
                          // margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color:
                                      const Color.fromARGB(255, 255, 255, 255)),
                              color: const Color.fromARGB(255, 255, 255, 255),
                              borderRadius: BorderRadius.circular(12)),
                          margin: const EdgeInsets.all(8),
                          // height: 50,
                          width: width * 1,
                          child: TextField(
                            keyboardAppearance: Brightness.dark,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            controller: messagecontroller,
                            onEditingComplete: () {
                              controller.settextfieldicon();
                              FocusManager.instance.primaryFocus!.unfocus();
                            },
                            onTap: () {
                              if (controller.iswriting == false) {
                                controller.settextfieldicon();
                                // controller.showEmogi();
                              }
                            },
                            decoration: InputDecoration(
                              prefixIcon: IconButton(
                                  onPressed: () {
                                    controller.showEmogi();
                                  },
                                  icon: const Icon(
                                    Icons.emoji_emotions_outlined,
                                    size: 25,
                                  )),
                              border: const OutlineInputBorder(
                                  borderSide: BorderSide.none),
                              suffixIcon: Container(
                                color: Colors.black12,
                                width: width * 0.25,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          ChatBottomsheet.showsheet(
                                              context, userdata);
                                        },
                                        icon: const Icon(
                                          Icons.add_circle_outline_rounded,
                                          size: 25,
                                        )),
                                    IconButton(
                                        onPressed: () {
                                          if (messagecontroller
                                              .text.isNotEmpty) {
                                            FirebaseServises.sendMessage(
                                                userdata,
                                                messagecontroller.text,
                                                Type.text);
                                            messagecontroller.text = '';
                                          } else {
                                            DynamicHelperWidget.show(
                                                "Message can't be empty");
                                          }
                                        },
                                        icon: const Icon(
                                          Icons.send,
                                          size: 25,
                                        )),
                                  ],
                                ),
                              ),

                              isDense: true,
                              contentPadding: const EdgeInsets.all(5),
                              // enabledBorder: OutlineInputBorder(
                              //     borderRadius: BorderRadius.circular(12),
                              //     borderSide: BorderSide.none),
                              hintText: 'Your message',
                              hintStyle: const TextStyle(
                                  color: Color.fromARGB(102, 0, 0, 0),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),
                        // if (controller.showemogi == true)
                        //   Container(
                        //     height: height * 0.4,
                        //     color: Colors.white,
                        //     // child: EmojiSelector(
                        //     //   rows: 4,
                        //     //   columns: 8,
                        //     //   padding: EdgeInsets.all(10),
                        //     //   withTitle: true,
                        //     //   onSelected: (emoji) {
                        //     //     messagecontroller.text =
                        //     //         messagecontroller.text + emoji.char;
                        //     //     print('Selected emoji ${emoji.char}');
                        //     //   },
                        //     // ),
                        //   )
                      ],
                    ),
                    if (controller.showemogi == true)
                      Positioned(child: emoji(context))
                  ],
                ),
              );
            }));
  }

  Widget emoji(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    // TODO: implement build
    return Container(
      color: Colors.blue,
      height: height * 0.4,
      child: EmojiSelector(
        rows: 4,
        columns: 8,
        padding: EdgeInsets.all(10),
        withTitle: true,
        onSelected: (emoji) {
          messagecontroller.text = messagecontroller.text + emoji.char;
          print('Selected emoji ${emoji.char}');
        },
      ),
    );
  }
}
