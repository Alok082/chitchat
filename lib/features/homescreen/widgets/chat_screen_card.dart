import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/models/user_data_model.dart';

// ignore: must_be_immutable
class ChatUserCard extends StatelessWidget {
  final UserData userdata;
  ChatUserCard({super.key, required this.userdata});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: Color.fromARGB(255, 14, 13, 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              // padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(10),
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(60)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(60),
                child: CachedNetworkImage(
                  // height: ,
                  fit: BoxFit.fill,
                  imageUrl: userdata.image,
                  placeholder: (context, url) => CupertinoActivityIndicator(),
                  errorWidget: (context, url, error) => Image.asset(
                    'asset/icons/applogo.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userdata.name,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                Text(userdata.about,
                    style: TextStyle(
                      color: Colors.white,
                    )),
              ],
            ),
            Spacer(),
            Icon(
              Icons.circle,
              color: Colors.lightGreenAccent,
              size: 15,
            ),
            // Text("5:20 AM",
            //     style: TextStyle(
            //       color: Colors.white,
            //     )),
            SizedBox(
              width: 15,
            )
          ],
        ),
      ),
    );
  }
}
