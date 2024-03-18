import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    // userdetail();
  }

  // print firebase user details
  // void userdetail() {
  //   print("object");
  //   if (FirebaseAuth.instance.currentUser != null) {
  //     print("user : ${FirebaseAuth.instance.currentUser}");
  //   }
  // }
}
