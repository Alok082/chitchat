import 'package:chitchat/core/models/user_data_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseServises {
  //for authentication
  static FirebaseAuth auth = FirebaseAuth.instance;
  // for storing data in the firestore
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static User get user => auth.currentUser!;
  static Future<bool> userexist() async {
    return (await firestore.collection('Users').doc(user.uid).get()).exists;
  }

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
}
