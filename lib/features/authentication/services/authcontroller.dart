import 'package:chitchat/shared/widgets/helper.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthController extends GetxController {
  // firebase login function

  Future<UserCredential?> signInWithGoogle() async {
    try {
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
      return await FirebaseAuth.instance.signInWithCredential(credential);
      // } else {
      //   throw Exception("No internet Connection");
      // }
    } catch (e) {
      DynamicHelperWidget.show("Failed to connect to the server");
    }
    // Trigger the authentication flow
  }

  void signout() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
  }
}
