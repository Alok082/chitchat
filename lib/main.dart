import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_notification_channel/flutter_notification_channel.dart';
import 'package:flutter_notification_channel/notification_importance.dart';
import 'package:get/get.dart';

import 'core/theme/apptheme.dart';
import 'dependency_injection.dart';
import 'routes/app_routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(
          options: const FirebaseOptions(
              apiKey: "AIzaSyBJkpPGkE7b8H3MdK-b9oI_7lD5uekhMtw",
              appId: "1:942054459689:android:c2a184d8e1474b03c6cf38",
              messagingSenderId: "942054459689",
              projectId: "chit-chat-3e42a",
              storageBucket: "chit-chat-3e42a.appspot.com"))
      .then(
    (value) async {
      var result =
          await FlutterNotificationChannel().registerNotificationChannel(
        description: 'For Showing Message Notification',
        id: 'chats',
        importance: NotificationImportance.IMPORTANCE_HIGH,
        name: 'Chit_Chat',
      );

      log(result);
      setup();
      runApp(const MyApp());
    },
  );
  // SystemChrome.setPreferredOrientations(
  //         [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
  //     .then((value) {

  // _initialisefirebase();
  // });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
      // darkTheme: ThemeData(colorScheme: darkColorScheme),
      initialRoute: AppRoutes.initialroute,
      getPages: AppRoutes.pages,
    );
  }
}

_initialisefirebase() async {
  // Platform.isAndroid
  //     ? await Firebase.initializeApp(
  // options: const FirebaseOptions(
  //     apiKey: "AIzaSyBJkpPGkE7b8H3MdK-b9oI_7lD5uekhMtw",
  //     appId: "1:942054459689:android:c2a184d8e1474b03c6cf38",
  //     messagingSenderId: "942054459689",
  //     projectId: "chit-chat-3e42a",
  //     storageBucket: "chit-chat-3e42a.appspot.com"))
  //     : null;

  runApp(const MyApp());
}
