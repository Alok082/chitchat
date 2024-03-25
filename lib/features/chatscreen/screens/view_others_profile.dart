import 'dart:io';
import 'dart:ui';

import 'package:chitchat/core/models/user_data_model.dart';
import 'package:chitchat/dependency_injection.dart';
import 'package:chitchat/features/authentication/services/authcontroller.dart';
import 'package:chitchat/features/profile/services/profilecontroller.dart';
import 'package:chitchat/firebaseservises/firebaseservice.dart';
import 'package:chitchat/shared/widgets/date_time.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ViewOthersProfile extends StatelessWidget {
  final formkey = GlobalKey<FormState>();
  final UserData userData = Get.arguments;

  ViewOthersProfile({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    var profileController = locator<ProfileController>();

    var mq = MediaQuery.sizeOf(context);
    return GestureDetector(
      onTap: () {
        if (profileController.visible == true) {
          profileController.changecontainerPosition();
        }
        FocusScope.of(context).unfocus();
      },
      child: GetBuilder<AuthController>(
          // init: AuthController(),
          builder: (_) {
        return GetBuilder<ProfileController>(
            init: ProfileController(),
            builder: (__) {
              return Scaffold(
                  appBar: AppBar(
                    backgroundColor: const Color.fromARGB(255, 168, 209, 241),
                  ),
                  endDrawerEnableOpenDragGesture: false,
                  body: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Stack(
                      children: [
                        SingleChildScrollView(
                          child: Form(
                            key: formkey,
                            child: Column(children: [
                              const SizedBox(height: 22.0),
                              Stack(
                                alignment: Alignment.bottomRight,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      profileController
                                          .changecontainerPosition();
                                    },
                                    child: Align(
                                      alignment: Alignment.topCenter,
                                      child: Container(
                                        padding: const EdgeInsets.all(5),
                                        height: mq.height * 0.22,
                                        width: mq.height * 0.22,
                                        decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.black),
                                            borderRadius:
                                                BorderRadius.circular(100)),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          child: profileController.image != null
                                              ? Image.file(
                                                  File(
                                                      profileController.image!),
                                                  fit: BoxFit.cover,
                                                )
                                              : CachedNetworkImage(
                                                  // height: ,
                                                  fit: BoxFit.fill,
                                                  imageUrl: userData.image,
                                                  placeholder: (context, url) =>
                                                      const CupertinoActivityIndicator(),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Image.asset(
                                                    'asset/icons/applogo.png',
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Container(
                                  //   margin: const EdgeInsets.only(
                                  //       right: 10, bottom: 10),
                                  //   // padding: EdgeInsets.all(5),
                                  //   height: mq.height * 0.045,
                                  //   width: mq.width * 0.095,
                                  //   decoration: BoxDecoration(
                                  //       color: const Color.fromARGB(
                                  //           255, 168, 209, 241),
                                  //       // border: Border.all(color: Colors.black),
                                  //       borderRadius:
                                  //           BorderRadius.circular(100)),
                                  //   child: FittedBox(
                                  //     child: IconButton(
                                  //       icon: const Icon(
                                  //         Icons.edit,
                                  //         size: 60,
                                  //       ),
                                  //       onPressed: () {
                                  //         Bottomsheet.showsheet(context);
                                  //         // Handle edit profile picture
                                  //       },
                                  //     ),
                                  //   ),
                                  // ),
                                ],
                              ),
                              const SizedBox(height: 30.0),
                              Text(
                                userData.name,
                                style: const TextStyle(
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                              const SizedBox(height: 10.0),
                              Text(
                                userData.about,
                                textAlign: TextAlign.justify,
                                style: const TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54),
                              ),
                              SizedBox(
                                height: mq.height * 0.40,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Joined Date: ",
                                    style: const TextStyle(
                                        fontSize: 22.0,
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromARGB(255, 29, 29, 29)),
                                  ),
                                  Text(
                                    MyDateTime.lastMessageTime(
                                        showyear: true,
                                        context: context,
                                        time: userData.createdAt),
                                    style: const TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w400,
                                        color: Color.fromARGB(255, 54, 53, 53)),
                                  ),
                                ],
                              ),
                            ]),
                          ),
                        ),
                        AnimatedContainer(
                            margin: const EdgeInsets.symmetric(vertical: 150),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25)),
                            height:
                                profileController.visible ? mq.height * 0.6 : 0,
                            width:
                                profileController.visible ? mq.height * 0.8 : 0,
                            alignment: Alignment.center,
                            curve: Curves.linear,
                            duration: const Duration(milliseconds: 1000),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(25),
                              child: profileController.image != null
                                  ? Image.file(
                                      File(profileController.image!),
                                      fit: BoxFit.cover,
                                    )
                                  : CachedNetworkImage(
                                      // height: ,
                                      fit: BoxFit.cover,
                                      imageUrl: userData.image,
                                      placeholder: (context, url) =>
                                          const CupertinoActivityIndicator(),
                                      errorWidget: (context, url, error) =>
                                          Image.asset(
                                        'asset/icons/applogo.png',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                            )),

                        // Visibility(
                        //   visible: authcontroller.isloading == true,
                        //   child: Container(
                        //     height: mq.height * 1,
                        //     width: mq.width * 1,
                        //     decoration: const BoxDecoration(),
                        //     child: BackdropFilter(
                        //       filter:
                        //           ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                        //       child: Container(
                        //         color: const Color.fromARGB(255, 168, 209, 241)
                        //             .withOpacity(
                        //                 0.4), // Adjust the opacity as needed
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        // Visibility(
                        //     visible: authcontroller.isloading == true,
                        //     child: const Center(
                        //         child: CupertinoActivityIndicator(
                        //       color: Color.fromARGB(255, 255, 255, 255),
                        //       radius: 15,
                        //     )))
                      ],
                    ),
                  ));
            });
      }),
    );
  }
}
