import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:chitchat/core/models/user_data_model.dart';
import 'package:chitchat/shared/widgets/helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart';

import '../core/models/message.dart';

class FirebaseServises {
  //for authentication
  static FirebaseAuth auth = FirebaseAuth.instance;
  // for storing data in the firestore
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  // for storing data in the firestore
  static FirebaseStorage storege = FirebaseStorage.instance;
  // instance for current user
  static late UserData me;
  // currrent user getter
  static User get user => auth.currentUser!;

  //////firebase messaging stuff<><><><>>>>>><<<<<<<<<>>>>>>>>>>>>>

  // for firebase messaging in flutter
  static FirebaseMessaging fbmessaging = FirebaseMessaging.instance;
  // for getting token for messaging
  static Future<void> gettingMessagingToken() async {
    await fbmessaging.requestPermission();
    await fbmessaging.getToken().then((t) {
      if (t != null) {
        print('token ::: $t');
        me.pushToken = t;
      }
    });
    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //   log('Got a message whilst in the foreground!');
    //   log('Message data: ${message.data}');

    //   if (message.notification != null) {
    //     log('Message also contained a notification: ${message.notification}');
    //   }
    // });
  }

  // send push notification
  static Future<void> sendPushNotification(UserData users, String mesg) async {
    try {
      print("object????????");
      print(users.pushToken);
      final body = {
        "to": users.pushToken,
        "notification": {
          "title": users.name,
          "body": mesg,
          "android_channel_id": "chats",
        },
        "data": {
          "click_action": "FLUTTER_NOTIFICATION_CLICK",
        },
      };
      var response =
          await post(Uri.parse("https://fcm.googleapis.com/fcm/send"),
              headers: {
                HttpHeaders.contentTypeHeader: 'application/json',
                HttpHeaders.authorizationHeader:
                    'key=AAAA21bSSSk:APA91bEW-EldehBBJIAKSCuWjnwUlz5ZuF4-olbZdhBf5mQUruligj81YsOuvQzKAtGLRKIkHXDk2k0XR2zQbGBPGasxYE4S9u4chmcQ4_acEHilTKCzqOyayf4gKkzDd8hDhysKWRHn'
              },
              body: jsonEncode(body));
      print(response.body);
    } catch (e) {
      print('error::::::::$e');
    } finally {
      print("finally");
    }
    // print(await http.read(Uri.https('example.com', 'foobar.txt')));
  }

  //messaging stuff end .........,,,,,,,,,,,,>>>>>>>>>>>

  // for checking the user exist or not
  static Future<bool> userexist() async {
    return (await firestore.collection('Users').doc(user.uid).get()).exists;
  }

  //for storing current user info
  static Future<void> storeuser() async {
    await firestore.collection('Users').doc(user.uid).get().then((user) async {
      if (user.exists) {
        me = UserData.fromJson(user.data()!);
        await gettingMessagingToken();
        //for updating user status to active
        FirebaseServises.updateActiveStatus(true);
      } else {
        await createUser().then((value) => storeuser());
      }
    });
  }

// for creating a new user
  static Future<void> createUser() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final chatuser = UserData(
        image: user.photoURL.toString(),
        name: user.displayName.toString(),
        about: "hey i'm using chit chat",
        createdAt: time,
        isOnline: false,
        id: user.uid,
        lastActive: time,
        email: user.email.toString(),
        pushToken: '');
    return await firestore
        .collection('Users')
        .doc(user.uid)
        .set(chatuser.toJson());
  }

// for getting all user from fire store database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getalluser() {
    return firestore
        .collection('Users')
        .where('id', isNotEqualTo: user.uid)
        .snapshots();
  }

  // for updating the user exist or not
  static Future<void> updateuserinfo() async {
    await firestore
        .collection('Users')
        .doc(user.uid)
        .update({'name': me.name, 'about': me.about});
    DynamicHelperWidget.show("Profile updated successfully ");
  }

  //for updating profile picture
  static Future<void> updateprofilepicture(File file) async {
    final ext = file.path.split(".").last;

    //storage file reference with path
    final ref = storege.ref().child('profile_picture/${user.uid}.$ext');

    // uploading images
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      print("Data Transferred : ${p0.bytesTransferred / 1000} kb");
    });
    //updating image in firebase database
    me.image = await ref.getDownloadURL();
    await firestore
        .collection('Users')
        .doc(user.uid)
        .update({'image': me.image});
  }

  //<><><><><><><><><********************>><><><><><><><><><><*************<><><><><><><><<>//
  /////////--------------Chat Screen related methods and api calls------------------/////////

  // for getting conversation id
  static String getConversationId(String id) => user.uid.hashCode <= id.hashCode
      ? '${user.uid}_$id'
      : '${id}_${user.uid}';
  //for getting the all message from firebase
  static Stream<QuerySnapshot<Map<String, dynamic>>> gettingallmessage(
      UserData userData) {
    return firestore
        .collection('chats/${getConversationId(userData.id)}/message/')
        .orderBy('sent', descending: true)
        .snapshots();
  }

  // for sending message
  static Future<void> sendMessage(
      UserData userdata, String msg, Type type) async {
    //message sending time and also use for doc id
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    // message to send

    final Message message = Message(
        toId: userdata.id,
        read: '',
        message: msg,
        type: type,
        sent: time,
        fromId: user.uid);
    final ref = firestore
        .collection('chats/${getConversationId(userdata.id)}/message/');
    await ref.doc(time).set(message.toJson()).then((value) =>
        sendPushNotification(userdata, type == Type.text ? msg : 'image'));
  }

  // update message read status
  static Future<void> updateReadStatus(Message msg) async {
    firestore
        .collection('chats/${getConversationId(msg.fromId)}/message/')
        .doc(msg.sent)
        .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
  }

  // get only last message of specific chat
  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(
      UserData userData) {
    return firestore
        .collection('chats/${getConversationId(userData.id)}/message/')
        .orderBy('sent', descending: true)
        .limit(1)
        .snapshots();
  }

  //send chat image
  static Future<void> sendChatImage(UserData userdata, File file) async {
    final ext = file.path.split(".").last;

    //storage file reference with path
    final ref = storege.ref().child(
        'images/${getConversationId(userdata.id)}/${DateTime.now().millisecondsSinceEpoch}.$ext');

    // uploading images
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      print("Data Transferred : ${p0.bytesTransferred / 1000} kb");
    });
    //updating image in firebase database
    final imageurl = await ref.getDownloadURL();
    await sendMessage(userdata, imageurl, Type.image);
  }

  //online and last seen
  static Stream<QuerySnapshot<Map<String, dynamic>>> getUserInfo(
      UserData userData) {
    return firestore
        .collection('Users')
        .where('id', isEqualTo: userData.id)
        .snapshots();
  } //update active status

  static Future<void> updateActiveStatus(bool isonline) async {
    firestore.collection('Users').doc(user.uid).update({
      'is_online': isonline,
      'last_active': DateTime.now().millisecondsSinceEpoch.toString(),
      'push_token': me.pushToken
    });
  }
}
