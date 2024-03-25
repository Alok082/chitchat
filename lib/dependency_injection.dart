import 'package:chitchat/features/chatscreen/chat_Controller.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

import 'features/authentication/services/authcontroller.dart';
import 'features/homescreen/services/home_controller.dart';
import 'features/profile/services/profilecontroller.dart';
import 'features/splashscreen/services/splashcontroller.dart';

final locator = GetIt.instance;

void setup() {
  locator.registerSingleton(Get.put(SplashController()));
  locator.registerSingleton(Get.put(ProfileController()));
  locator.registerSingleton(Get.put(AuthController()));
  locator.registerSingleton(Get.put(HomeController()));
  locator.registerSingleton(Get.put(ChatController()));
}
