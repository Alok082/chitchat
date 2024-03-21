import 'package:get/get.dart';

import '../features/Splashscreen/screens/splashscreen.dart';
import '../features/authentication/screens/loginscreen.dart';
import '../features/chatscreen/chatscreen.dart';
import '../features/homescreen/screens/homescreen.dart';
import '../features/profile/screens/userprofile.dart';

class AppRoutes {
  static const String initialroute = '/splash';

  static const String chatScreen = '/ChatScreen';

  static const String homeScreen = '/HomeScreen';

  // static const String bottomnavigationbar = '/Bottomnavigationbar';

  static const String loginScreen = '/LoginScreen';

  // static const String signupScreen = '/SignupScreen';

  static const String userProfile = '/UserProfile';

  // static const String bookrides = '/bookrides';

  // static const String personalInformation = '/PersonalInformation';

  // static const String showDirection = '/ShowDirection';

  // static const String chooseVehicle = '/ChooseVehicle';

  static List<GetPage> pages = [
    GetPage(
      name: initialroute,
      page: () => SplashScreen(),
    ),
    GetPage(
      name: chatScreen,
      page: () => ChatScreen(),
    ),
    GetPage(
      name: homeScreen,
      page: () => HomeScreen(),
    ),
    // GetPage(
    //   name: bottomnavigationbar,
    //   page: () => Bottomnavigationbar(),
    // ),
    GetPage(
      name: loginScreen,
      page: () => LoginScreen(),
    ),
    // GetPage(
    //   name: signupScreen,
    //   page: () => Sign_Up_Screen(),
    // ),
    GetPage(
      name: userProfile,
      page: () => UserProfile(),
    ),
    // GetPage(
    //   name: bookrides,
    //   page: () => Book_Rides(),
    // ),
    // GetPage(
    //   name: personalInformation,
    //   page: () => PersonalInformation(),
    // ),
    // GetPage(
    //   name: showDirection,
    //   page: () => ShowDirection(),
    // ),
    // GetPage(
    //   name: chooseVehicle,
    //   page: () => ChooseVehicle(),
    // ),
  ];
}
