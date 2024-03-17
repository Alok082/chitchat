import 'package:chitchat/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';

import '../../authentication/screens/loginscreen.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));

    return AnimatedSplashScreen(
        duration: 3000,
        splash: Image.asset(
          "asset/icons/applogo.png",
          // height: 200,
        ),
        nextScreen: LoginScreen(),
        nextRoute: AppRoutes.loginScreen,
        animationDuration:
            Duration(milliseconds: 1000), // Adjust animation duration
        splashTransition: SplashTransition.sizeTransition,
        splashIconSize: 200,
        pageTransitionType: PageTransitionType.leftToRight,
        backgroundColor: Color.fromARGB(255, 168, 209, 241));
  }
}
