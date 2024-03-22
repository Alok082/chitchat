import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chitchat/core/models/message.dart';
import 'package:chitchat/core/models/user_data_model.dart';
import 'package:chitchat/features/chatscreen/chat_Controller.dart';
import 'package:chitchat/shared/widgets/helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../dependency_injection.dart';
import '../../firebaseservises/firebaseservice.dart';
import 'widgets/bottomsheet_widget.dart';
import 'widgets/message_card.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({super.key});
  final UserData userdata = Get.arguments;
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;
    MediaQueryData mediaQuery = MediaQuery.of(context);
    //for handling messages
    TextEditingController messagecontroller = TextEditingController();

    var _controller = locator<ChatController>();
    List<Message> _list = [];

    return GestureDetector(
      onTap: () {
        if (_controller.iswriting == true) {
          FocusManager.instance.primaryFocus!.unfocus();
          _controller.settextfieldicon();
        }
      },
      child: LayoutBuilder(builder: (context, constraints) {
        if (mediaQuery.viewInsets.bottom > 0) {
          // Keyboard is visible
          // _chatController.isKeyboardVisible.value = true;
        } else {
          // Keyboard is not visible
          // _chatController.isKeyboardVisible.value = false;
        }
        return GetBuilder<ChatController>(
            init: ChatController(),
            builder: (_) {
              return Scaffold(
                appBar: AppBar(
                  leadingWidth: 30,
                  leading: IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: Icon(Icons.navigate_before)),
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
                      child: Icon(Icons.more_vert),
                    )
                  ],
                  title: Row(
                    children: [
                      Container(
                        // padding: EdgeInsets.all(2.5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            border:
                                Border.all(color: Colors.amber, width: 2.3)),
                        child: CircleAvatar(
                          radius: 20,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: CachedNetworkImage(
                              // height: ,
                              fit: BoxFit.fill,
                              imageUrl: userdata.image,
                              placeholder: (context, url) =>
                                  CupertinoActivityIndicator(),
                              errorWidget: (context, url, error) => Image.asset(
                                'asset/icons/applogo.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userdata.name,
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 20),
                            ),
                            Text(
                              "Online",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: Color.fromARGB(143, 0, 0, 0)),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                body: Column(
                  children: [
                    //
                    Expanded(
                      child: StreamBuilder(
                          stream: FirebaseServises.gettingallmessage(userdata),
                          builder: (context, snapshot) {
                            switch (snapshot.connectionState) {
                              case ConnectionState.waiting:
                              case ConnectionState.none:
                                return SizedBox();
                              case ConnectionState.active:
                              case ConnectionState.done:
                                final datas = snapshot.data?.docs;
                                _list = datas!
                                    .map((e) => Message.fromJson(e.data()))
                                    .toList();
                                // print(jsonEncode(datas![0].data()));

                                if (_list.isNotEmpty) {
                                  return ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: _list.length,
                                      itemBuilder: (context, index) {
                                        return MessageCard(
                                          message: _list[index],
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
                    Container(
                      // margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Color.fromARGB(255, 255, 255, 255)),
                          color: const Color.fromARGB(255, 255, 255, 255),
                          borderRadius: BorderRadius.circular(12)),
                      margin: EdgeInsets.all(8),
                      // height: 50,
                      width: width * 1,
                      child: TextField(
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        controller: messagecontroller,
                        onEditingComplete: () {
                          _controller.settextfieldicon();
                          FocusManager.instance.primaryFocus!.unfocus();
                        },
                        onTap: () {
                          if (_controller.iswriting == false) {
                            _controller.settextfieldicon();
                          }
                        },
                        decoration: InputDecoration(
                          prefixIcon: IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.emoji_emotions_outlined,
                                size: 25,
                              )),
                          border:
                              OutlineInputBorder(borderSide: BorderSide.none),
                          suffixIcon: _controller.iswriting
                              ? IconButton(
                                  onPressed: () {
                                    if (messagecontroller.text.isNotEmpty) {
                                      print("started");
                                      FirebaseServises.sendMessage(
                                          userdata, messagecontroller.text);
                                      messagecontroller.text = '';
                                    } else {
                                      DynamicHelperWidget.show(
                                          "Message can't be empty");
                                    }
                                  },
                                  icon: Icon(
                                    Icons.send,
                                    size: 25,
                                  ))
                              : IconButton(
                                  onPressed: () {
                                    ChatBottomsheet.showsheet(context);
                                  },
                                  icon: Icon(
                                    Icons.add_circle_outline_rounded,
                                    size: 25,
                                  )),
                          isDense: true,
                          contentPadding: EdgeInsets.all(5),
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
                  ],
                ),
              );
            });
      }),
    );
  }
}
