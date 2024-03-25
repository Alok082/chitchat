import 'package:chitchat/dependency_injection.dart';
import 'package:chitchat/features/splashscreen/services/splashcontroller.dart';
import 'package:chitchat/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:page_transition/page_transition.dart';

import '../../../firebaseservises/firebaseservice.dart';
import '../../authentication/screens/loginscreen.dart';
import '../../homescreen/screens/homescreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var controllers = locator<SplashController>();
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
        duration: 3000,
        splash: Image.asset(
          "asset/icons/applogo.png",
          // height: 200,
        ),
        nextScreen: FirebaseServises.auth.currentUser != null
            ? HomeScreen()
            : const LoginScreen(),
        nextRoute: FirebaseServises.auth.currentUser != null
            ? AppRoutes.homeScreen
            : AppRoutes.loginScreen,
        animationDuration:
            const Duration(milliseconds: 1000), // Adjust animation duration
        splashTransition: SplashTransition.sizeTransition,
        splashIconSize: 200,
        pageTransitionType: PageTransitionType.leftToRight,
        backgroundColor: const Color.fromARGB(255, 168, 209, 241));
  }
}
