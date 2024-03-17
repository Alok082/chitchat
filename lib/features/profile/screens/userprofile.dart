import 'package:chitchat/dependency_injection.dart';
import 'package:chitchat/features/authentication/services/authcontroller.dart';
import 'package:flutter/material.dart';

import '../../../shared/widgets/elavatedbutton.dart';

class UserProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: ElavatedButton(
        button_name: "signout",
        buttonaction: () {
          locator<AuthController>().signout();
        },
      )),
    );
  }
}
