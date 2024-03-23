import 'package:chitchat/core/models/user_data_model.dart';
import 'package:chitchat/dependency_injection.dart';
import 'package:chitchat/features/chatscreen/chat_Controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ChatBottomsheet {
  static void showsheet(BuildContext context, UserData user) {
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
                      final List<XFile?> images =
                          await picker.pickMultiImage(imageQuality: 80);
                      if (images.isNotEmpty) {
                        Get.back();

                        for (var i in images) {
                          locator<ChatController>().sendimage(i!.path, user);
                        }
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
                        Get.back();

                        locator<ChatController>().sendimage(image.path, user);
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
