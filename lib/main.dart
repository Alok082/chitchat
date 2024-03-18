import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'core/theme/apptheme.dart';
import 'dependency_injection.dart';
import 'routes/app_routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((value) {
    setup();
    _initialisefirebase();
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
      darkTheme: ThemeData(colorScheme: darkColorScheme),
      initialRoute: AppRoutes.initialroute,
      getPages: AppRoutes.pages,
    );
  }
}

_initialisefirebase() async {
  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
              apiKey: "AIzaSyBJkpPGkE7b8H3MdK-b9oI_7lD5uekhMtw",
              appId: "1:942054459689:android:c2a184d8e1474b03c6cf38",
              messagingSenderId: "942054459689",
              projectId: "chit-chat-3e42a"))
      : await Firebase.initializeApp();

  runApp(const MyApp());
}
