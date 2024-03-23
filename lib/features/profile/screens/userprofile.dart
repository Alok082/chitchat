import 'dart:io';
import 'dart:ui';

import 'package:chitchat/core/models/user_data_model.dart';
import 'package:chitchat/dependency_injection.dart';
import 'package:chitchat/features/authentication/services/authcontroller.dart';
import 'package:chitchat/features/profile/services/profilecontroller.dart';
import 'package:chitchat/firebaseservises/firebaseservice.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../shared/buttons/elavatedbutton.dart';
import '../widgets/bottomsheet.dart';

class UserProfile extends StatelessWidget {
  final formkey = GlobalKey<FormState>();
  final UserData userData = Get.arguments;

  UserProfile({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    var _authcontroller = locator<AuthController>();
    var _profileController = locator<ProfileController>();

    var mq = MediaQuery.sizeOf(context);
    return GestureDetector(
      onTap: () {
        if (_profileController.visible == true) {
          _profileController.changecontainerPosition();
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
                                SizedBox(height: 22.0),
                                Stack(
                                  alignment: Alignment.bottomRight,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        _profileController
                                            .changecontainerPosition();
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(5),
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
                                          child: _profileController.image !=
                                                  null
                                              ? Image.file(
                                                  File(_profileController
                                                      .image!),
                                                  fit: BoxFit.cover,
                                                )
                                              : CachedNetworkImage(
                                                  // height: ,
                                                  fit: BoxFit.fill,
                                                  imageUrl: userData.image,
                                                  placeholder: (context, url) =>
                                                      CupertinoActivityIndicator(),
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
                                      margin: EdgeInsets.only(
                                          right: 10, bottom: 10),
                                      // padding: EdgeInsets.all(5),
                                      height: mq.height * 0.045,
                                      width: mq.width * 0.095,
                                      decoration: BoxDecoration(
                                          color: Color.fromARGB(
                                              255, 168, 209, 241),
                                          // border: Border.all(color: Colors.black),
                                          borderRadius:
                                              BorderRadius.circular(100)),
                                      child: FittedBox(
                                        child: IconButton(
                                          icon: Icon(
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
                                SizedBox(height: 30.0),
                                Text(
                                  userData.email,
                                  style: TextStyle(
                                      fontSize: 24.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                                SizedBox(height: 50.0),
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
                                  style: TextStyle(fontSize: 15),
                                  cursorHeight: 25,

                                  decoration: InputDecoration(
                                    hintText: "eg. Shivam pandey",
                                    label: Text("Name"),
                                    isDense: true, // Added this
                                    contentPadding: EdgeInsets.all(10),
                                    prefixIcon: Icon(Icons.person),
                                    filled: true,
                                    fillColor:
                                        Color.fromARGB(255, 168, 209, 241),
                                    disabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color.fromARGB(255, 6, 4, 4),
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color.fromARGB(255, 6, 4, 4),
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(12)),

                                    hintStyle: TextStyle(
                                        color:
                                            Color.fromARGB(240, 100, 100, 100)),
                                    border: OutlineInputBorder(
                                      gapPadding: Checkbox.width * 0.1,
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: BorderSide(
                                        color: Color.fromARGB(255, 201, 6, 6),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 30.0),
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
                                  style: TextStyle(fontSize: 15),
                                  cursorHeight: 25,

                                  decoration: InputDecoration(
                                    hintText: "Feeling Happy",
                                    label: Text("About"),
                                    prefixIcon: Icon(Icons.info_outline),

                                    isDense: true, // Added this
                                    contentPadding: EdgeInsets.all(10),
                                    filled: true,
                                    fillColor:
                                        Color.fromARGB(255, 168, 209, 241),

                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color.fromARGB(255, 6, 4, 4),
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(12)),

                                    hintStyle: TextStyle(
                                        color:
                                            Color.fromARGB(240, 100, 100, 100)),
                                    border: OutlineInputBorder(
                                      gapPadding: Checkbox.width * 0.1,
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: BorderSide(
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
                                        child: Center(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                width: 8,
                                              ),
                                              Text(
                                                "Update",
                                                style: const TextStyle(
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
                                SizedBox(height: 10.0),
                              ],
                            ),
                          ),
                        ),
                        AnimatedContainer(
                            margin: EdgeInsets.symmetric(vertical: 150),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25)),
                            height: _profileController.visible
                                ? mq.height * 0.6
                                : 0,
                            width: _profileController.visible
                                ? mq.height * 0.8
                                : 0,
                            alignment: Alignment.center,
                            curve: Curves.linear,
                            duration: Duration(milliseconds: 1000),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(25),
                              child: _profileController.image != null
                                  ? Image.file(
                                      File(_profileController.image!),
                                      fit: BoxFit.cover,
                                    )
                                  : CachedNetworkImage(
                                      // height: ,
                                      fit: BoxFit.fill,
                                      imageUrl: userData.image,
                                      placeholder: (context, url) =>
                                          CupertinoActivityIndicator(),
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
                                icon: Icon(Icons.logout))),
                        Visibility(
                          visible: _authcontroller.isloading == true,
                          child: Container(
                            height: mq.height * 1,
                            width: mq.width * 1,
                            decoration: BoxDecoration(),
                            child: BackdropFilter(
                              filter:
                                  ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                              child: Container(
                                color: Color.fromARGB(255, 168, 209, 241)
                                    .withOpacity(
                                        0.4), // Adjust the opacity as needed
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                            visible: _authcontroller.isloading == true,
                            child: Center(
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
