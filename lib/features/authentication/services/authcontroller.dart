import 'dart:io';

import 'package:chitchat/shared/widgets/helper.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../core/constants/constant.dart';
import '../../../firebaseservises/firebaseservice.dart';

class AuthController extends GetxController {
  bool isloading = false;
  // firebase login function

  Future<UserCredential?> signInWithGoogle() async {
    try {
      isloading = true;
      update();
      await InternetAddress.lookup("google.com");

      // var connectivityResult = await Connectivity().checkConnectivity();
      // if (connectivityResult != ConnectivityResult.none) {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await FirebaseServises.auth.signInWithCredential(credential);

      // } else {
      //   throw Exception("No internet Connection");
      // }
    } catch (e) {
      DynamicHelperWidget.show("Check Your Internet Connection");
      isloading = false;
      update();
      return null;
    } finally {
      isloading = false;
      update();
    }
    // Trigger the authentication flow
  }

  void signout() async {
    try {
      isloading = true;
      update();
      await InternetAddress.lookup("google.com");
      await FirebaseServises.auth.signOut().then((value) async {
        await GoogleSignIn().signOut().then((value) {
          Get.offAndToNamed("/LoginScreen");
          isloading = false;
          update();
          DynamicHelperWidget.show("Succeccfully Logged Out");
        });
      });
    } catch (e) {
      DynamicHelperWidget.show("Check Your Internet Connection");
      isloading = false;
      update();
    } finally {
      isloading = false;
      update();
    }
  }

  void loadingfalse() {
    isloading = false;
    update();
  }
}
