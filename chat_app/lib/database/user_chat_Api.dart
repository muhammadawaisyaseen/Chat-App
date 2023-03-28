import 'package:chat_app/database/auth_api.dart';
import 'package:chat_app/database/user_api.dart';
import 'package:chat_app/models/messege.dart';
import 'package:chat_app/models/user_info.dart';
import 'package:chat_app/pages/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserChatApi {
  static const String _collectionMessege = 'chat';
  // String get collection => _collectionMessege;
  // String _uid = getCurrentUser!.uid;
  // String _uid = AuthApi.getCurrentUser!.uid;

  goChat(UserInformation toUserData, BuildContext context) async {
    //If current user(I) trying to send messege to another person
    QuerySnapshot<Messege> fromMesseges = await UserApi.firestoreInstance
        .collection(_collectionMessege)
        .withConverter(
          fromFirestore: Messege.fromFirestore,
          toFirestore: (Messege msg, options) => msg.toFirestore(),
        )
        //FROM
        .where("senderId", isEqualTo: AuthApi().uid)
        //TO
        .where("friendId", isEqualTo: toUserData.id)
        .get();

    //If another person trying to send messege to current user(ME)
    QuerySnapshot<Messege> toMesseges = await UserApi.firestoreInstance
        .collection(_collectionMessege)
        .withConverter(
          fromFirestore: Messege.fromFirestore,
          toFirestore: (Messege msg, options) => msg.toFirestore(),
        )
        .where("senderId", isEqualTo: toUserData.id)
        .where("friendId", isEqualTo: AuthApi().uid)
        .get();

    // If there is no chat b/w them
    if (fromMesseges.docs.isEmpty && toMesseges.docs.isEmpty) {
      // String profile = await
      // UserInformation userData = UserInformation.fromMap()
      Messege msgData = Messege(
        senderId: AuthApi().uid,
        friendId: toUserData.id,
        senderName: AuthApi.getCurrentUser!.displayName.toString(),
        friendName: toUserData.name,
        lastMsg: "",
        lastTime: Timestamp.now(),
        msg_no: 0,
      );

      UserApi.firestoreInstance
          .collection(_collectionMessege)
          .withConverter(
              fromFirestore: Messege.fromFirestore,
              toFirestore: (Messege msg, options) => msg.toFirestore())
          .add(msgData)
          .then((DocumentReference<Messege> value) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatScreen(
                userName: toUserData.name,
                userImage: toUserData.profile,

                // :value.id
              ),
            ));
      });
    } else {
      // If there is chat b/w them
      if (fromMesseges.docs.isNotEmpty) {
        // ignore: use_build_context_synchronously
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatScreen(
                userName: toUserData.name,
                userImage: toUserData.profile,
              ),
            ));
      }
      if (toMesseges.docs.isNotEmpty) {
        // ignore: use_build_context_synchronously
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatScreen(
                userName: toUserData.name,
                userImage: toUserData.profile,
              ),
            ));
      }
    }
  }
}
