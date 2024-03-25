import 'dart:io';
import 'dart:ui';

import 'package:chitchat/core/models/user_data_model.dart';
import 'package:chitchat/dependency_injection.dart';
import 'package:chitchat/features/authentication/services/authcontroller.dart';
import 'package:chitchat/features/profile/services/profilecontroller.dart';
import 'package:chitchat/firebaseservises/firebaseservice.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../widgets/bottomsheet.dart';

class UserProfile extends StatelessWidget {
  final formkey = GlobalKey<FormState>();
  final UserData userData = Get.arguments;

  UserProfile({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    var authcontroller = locator<AuthController>();
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
                  endDrawerEnableOpenDragGesture: false,
                  body: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Stack(
                      children: [
                        SingleChildScrollView(
                          child: Form(
                            key: formkey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(height: 22.0),
                                Stack(
                                  alignment: Alignment.bottomRight,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        profileController
                                            .changecontainerPosition();
                                      },
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
                                    Container(
                                      margin: const EdgeInsets.only(
                                          right: 10, bottom: 10),
                                      // padding: EdgeInsets.all(5),
                                      height: mq.height * 0.045,
                                      width: mq.width * 0.095,
                                      decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              255, 168, 209, 241),
                                          // border: Border.all(color: Colors.black),
                                          borderRadius:
                                              BorderRadius.circular(100)),
                                      child: FittedBox(
                                        child: IconButton(
                                          icon: const Icon(
                                            Icons.edit,
                                            size: 60,
                                          ),
                                          onPressed: () {
                                            Bottomsheet.showsheet(context);
                                            // Handle edit profile picture
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 30.0),
                                Text(
                                  userData.email,
                                  style: const TextStyle(
                                      fontSize: 24.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                                const SizedBox(height: 50.0),
                                TextFormField(
                                  onSaved: (newValue) {
                                    FirebaseServises.me.name = newValue ?? '';
                                  },
                                  validator: (val) {
                                    if (val != null && val.isNotEmpty) {
                                      return null;
                                    } else {
                                      return 'required field';
                                    }
                                  },
                                  initialValue: userData.name,
                                  // controller: controller,
                                  textAlign: TextAlign.start,
                                  style: const TextStyle(fontSize: 15),
                                  cursorHeight: 25,

                                  decoration: InputDecoration(
                                    hintText: "eg. Shivam pandey",
                                    label: const Text("Name"),
                                    isDense: true, // Added this
                                    contentPadding: const EdgeInsets.all(10),
                                    prefixIcon: const Icon(Icons.person),
                                    filled: true,
                                    fillColor: const Color.fromARGB(
                                        255, 168, 209, 241),
                                    disabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          color: Color.fromARGB(255, 6, 4, 4),
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          color: Color.fromARGB(255, 6, 4, 4),
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(12)),

                                    hintStyle: const TextStyle(
                                        color:
                                            Color.fromARGB(240, 100, 100, 100)),
                                    border: OutlineInputBorder(
                                      gapPadding: Checkbox.width * 0.1,
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: const BorderSide(
                                        color: Color.fromARGB(255, 201, 6, 6),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 30.0),
                                TextFormField(
                                  onSaved: (newValue) {
                                    FirebaseServises.me.about = newValue ?? '';
                                  },
                                  validator: (val) {
                                    if (val != null && val.isNotEmpty) {
                                      return null;
                                    } else {
                                      return 'required field';
                                    }
                                  },
                                  initialValue: userData.about,

                                  // controller: controller,
                                  textAlign: TextAlign.start,
                                  style: const TextStyle(fontSize: 15),
                                  cursorHeight: 25,

                                  decoration: InputDecoration(
                                    hintText: "Feeling Happy",
                                    label: const Text("About"),
                                    prefixIcon: const Icon(Icons.info_outline),

                                    isDense: true, // Added this
                                    contentPadding: const EdgeInsets.all(10),
                                    filled: true,
                                    fillColor: const Color.fromARGB(
                                        255, 168, 209, 241),

                                    enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          color: Color.fromARGB(255, 6, 4, 4),
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(12)),

                                    hintStyle: const TextStyle(
                                        color:
                                            Color.fromARGB(240, 100, 100, 100)),
                                    border: OutlineInputBorder(
                                      gapPadding: Checkbox.width * 0.1,
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: const BorderSide(
                                        color: Color.fromARGB(255, 201, 6, 6),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: mq.height * 0.15),
                                Container(
                                  width: mq.width * 1,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color.fromARGB(255, 19, 24, 28),
                                        Color.fromARGB(255, 14, 18, 20),
                                        Color.fromARGB(255, 0, 0, 0),
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                    borderRadius: BorderRadius.circular(25.0),
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        if (formkey.currentState!.validate()) {
                                          formkey.currentState!.save();
                                          FirebaseServises.updateuserinfo();

                                          print("updated");
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        alignment: Alignment.center,
                                        backgroundColor: Colors.transparent,
                                        // elevation: 12,
                                        elevation: 0.0,
                                        // padding: EdgeInsets.symmetric(horizontal: 10.0),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                        ),
                                      ),
                                      child: Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5.0),
                                        child: const Center(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                width: 8,
                                              ),
                                              Text(
                                                "Update",
                                                style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 255, 255, 255),
                                                  fontSize: 20.0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10.0),
                              ],
                            ),
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
                        Positioned(
                            right: mq.width * 0.01,
                            top: mq.height * 0.02,
                            child: IconButton(
                                onPressed: () {
                                  locator<AuthController>().signout();
                                },
                                icon: const Icon(Icons.logout))),
                        Visibility(
                          visible: authcontroller.isloading == true,
                          child: Container(
                            height: mq.height * 1,
                            width: mq.width * 1,
                            decoration: const BoxDecoration(),
                            child: BackdropFilter(
                              filter:
                                  ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                              child: Container(
                                color: const Color.fromARGB(255, 168, 209, 241)
                                    .withOpacity(
                                        0.4), // Adjust the opacity as needed
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                            visible: authcontroller.isloading == true,
                            child: const Center(
                                child: CupertinoActivityIndicator(
                              color: Color.fromARGB(255, 255, 255, 255),
                              radius: 15,
                            )))
                      ],
                    ),
                  )
                  // Center(
                  //     child: Container(
                  //   height: 50,
                  //   width: 200,
                  //   child: ElavatedButton(
                  //     button_name: "signout",
                  //     buttonaction: () {
                  //       locator<AuthController>().signout();
                  //     },
                  //   ),
                  // )),
                  );
            });
      }),
    );
  }
}
