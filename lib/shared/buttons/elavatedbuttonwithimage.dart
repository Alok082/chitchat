import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ElavatedButtonWithImage extends StatelessWidget {
  String button_name;
  Function() buttonaction;
  String buttonicon;

  ElavatedButtonWithImage({
    super.key,
    required this.button_name,
    required this.buttonaction,
    required this.buttonicon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width * 1,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color.fromARGB(255, 168, 209, 241),
            Color.fromARGB(255, 139, 178, 208),
            Color.fromARGB(255, 107, 143, 170),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: Material(
        color: Colors.transparent,
        child: ElevatedButton(
          onPressed: () {
            buttonaction();
          },
          style: ElevatedButton.styleFrom(
            alignment: Alignment.center,
            backgroundColor: Colors.transparent,
            // elevation: 12,
            elevation: 0.0,
            // padding: EdgeInsets.symmetric(horizontal: 10.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    buttonicon,
                    height: 30,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    button_name,
                    style: const TextStyle(
                      color: Color.fromARGB(255, 25, 17, 17),
                      fontSize: 20.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
