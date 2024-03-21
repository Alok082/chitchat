import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ChatBottomsheet {
  static void showsheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25), topRight: Radius.circular(25))),
      builder: (context) {
        return ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(12),
          children: [
            // Text(
            //   textAlign: TextAlign.center,
            //   "Choose profile picture",
            //   style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            // ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      // Pick an image.
                      final XFile? image = await picker.pickImage(
                          source: ImageSource.gallery, imageQuality: 80);
                      if (image != null) {
                        // locator<ProfileController>()
                        //     .updateProfilePicture(image.path);
                      }
                    },
                    child: Image.asset(
                      "asset/icons/gallery_icon.png",
                      height: 100,
                    )),
                ElevatedButton(
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      // Pick an image.
                      final XFile? image = await picker.pickImage(
                          source: ImageSource.camera, imageQuality: 80);
                      if (image != null) {
                        // locator<ProfileController>()
                        //     .updateProfilePicture(image.path);
                      }
                    },
                    child: Image.asset(
                      "asset/icons/camera.png",
                      height: 100,
                    ))
              ],
            ),
            SizedBox(
              height: 50,
            )
          ],
        );
      },
    );
  }
}
