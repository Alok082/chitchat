import 'dart:ui';

import 'package:chitchat/dependency_injection.dart';
import 'package:chitchat/features/authentication/services/authcontroller.dart';
import 'package:chitchat/firebaseservises/firebaseservice.dart';
import 'package:chitchat/shared/buttons/elavatedbuttonwithimage.dart';
import 'package:chitchat/shared/widgets/helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.sizeOf(context);
    var controller = locator<AuthController>();
    return GetBuilder<AuthController>(
        init: AuthController(),
        builder: (context) {
          return Scaffold(
              // backgroundColor: const Color.fromARGB(255, 7, 6, 5),
              body: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 7, 6, 5),
                    image: DecorationImage(
                        image: AssetImage("asset/icons/sliverapp_logo.png"))),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 100),
                  child: Image.asset(
                    "asset/icons/login.png",
                    height: 100,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 160),
                    padding: const EdgeInsets.all(10),
                    height: 70,
                    width: double.infinity,
                    child: ElavatedButtonWithImage(
                        buttonicon: "asset/icons/google.png",
                        button_name: "Sign In With Google",
                        buttonaction: () {
                          controller.signInWithGoogle().then((user) async {
                            if (user != null) {
                              if ((await FirebaseServises.userexist())) {
                                controller.loadingfalse;
                                Get.offAndToNamed("/HomeScreen");
                              } else {
                                await FirebaseServises.createUser()
                                    .then((value) {
                                  controller.loadingfalse;
                                  Get.offAndToNamed("/HomeScreen");
                                });
                              }
                            } else {
                              DynamicHelperWidget.show("Unable To Sign In");
                            }
                          });
                        })),
              ),
              Visibility(
                visible: controller.isloading,
                child: Container(
                  height: mq.height * 1,
                  width: mq.width * 1,
                  decoration: const BoxDecoration(),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                    child: Container(
                      color: const Color.fromARGB(255, 168, 209, 241)
                          .withOpacity(0.4), // Adjust the opacity as needed
                    ),
                  ),
                ),
              ),
              Visibility(
                  visible: controller.isloading,
                  child: const Center(
                      child: CupertinoActivityIndicator(
                    color: Color.fromARGB(255, 255, 255, 255),
                    radius: 15,
                  )))
            ],
          ));
        });
  }
}
