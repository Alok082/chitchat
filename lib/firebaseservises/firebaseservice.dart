import 'dart:io';

import 'package:chitchat/core/models/user_data_model.dart';
import 'package:chitchat/shared/widgets/helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

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
  // for checking the user exist or not
  static Future<bool> userexist() async {
    return (await firestore.collection('Users').doc(user.uid).get()).exists;
  }

  //for storing current user info
  static Future<void> storeuser() async {
    await firestore.collection('Users').doc(user.uid).get().then((user) async {
      if (user.exists) {
        me = UserData.fromJson(user.data()!);
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
    await ref.doc(time).set(message.toJson());
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
  //  static Stream<QuerySnapshot<Map<String, dynamic>>> getUserInfo(
  //     UserData userData) {

  // }
}
