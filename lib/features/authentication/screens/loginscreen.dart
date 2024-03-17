import 'package:chitchat/dependency_injection.dart';
import 'package:chitchat/features/authentication/services/authcontroller.dart';
import 'package:chitchat/shared/widgets/helper.dart';
import 'package:chitchat/shared/widgets/elavatedbutton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 0, 0, 0),
                  image: DecorationImage(
                      image: AssetImage("asset/icons/sliverapp_logo.png"))),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 100),
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
                  margin: EdgeInsets.symmetric(vertical: 160),
                  padding: EdgeInsets.all(10),
                  height: 70,
                  width: double.infinity,
                  child: ElavatedButton(
                      buttonicon: "asset/icons/google.png",
                      button_name: "Sign In With Google",
                      buttonaction: () {
                        DynamicHelperWidget.showprogressbar(context);
                        locator<AuthController>()
                            .signInWithGoogle()
                            .then((user) {
                          if (user != null) {
                            Get.offAndToNamed("/HomeScreen");
                          } else {
                            DynamicHelperWidget.show("Unable to Sign in");
                          }
                        });
                      })),
            )
          ],
        ));
  }
}
