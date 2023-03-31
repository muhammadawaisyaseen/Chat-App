import 'dart:async';

import 'package:chat_app/database/auth_api.dart';
import 'package:chat_app/database/user_api.dart';
import 'package:chat_app/models/chat_info.dart';
import 'package:chat_app/models/messege_content.dart';
import 'package:chat_app/models/user_info.dart';
import 'package:chat_app/pages/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class UserChatApi {
  // final uuid = Uuid().v4();

  static const String _chatCollection = 'chat';
  static const String _collectionMsgList = 'msgList';
  goChat(
      UserInformation toUserData, BuildContext context, String chatId) async {
    //If current user(I) trying to send messege to another person and click on messege
    QuerySnapshot<ChatInfo> fromMesseges = await UserApi.firestoreInstance
        .collection(_chatCollection)
        .withConverter(
          fromFirestore: ChatInfo.fromFirestore,
          toFirestore: (ChatInfo msg, options) => msg.toFirestore(),
        )
        //FROM
        .where("senderId", isEqualTo: AuthApi().uid)
        //TO
        .where("friendId", isEqualTo: toUserData.id)
        .get();

    //If another person trying to send messege to current user(ME)
    QuerySnapshot<ChatInfo> toMesseges = await UserApi.firestoreInstance
        .collection(_chatCollection)
        .withConverter(
          fromFirestore: ChatInfo.fromFirestore,
          toFirestore: (ChatInfo msg, options) => msg.toFirestore(),
        )
        .where("senderId", isEqualTo: toUserData.id)
        .where("friendId", isEqualTo: AuthApi().uid)
        .get();

    // If there is no chat b/w them
    if (fromMesseges.docs.isEmpty && toMesseges.docs.isEmpty) {
      ChatInfo chatData = ChatInfo(
        chatId: chatId,
        senderId: AuthApi().uid,
        friendId: toUserData.id,
        lastMsg: "",
        lastTime: Timestamp.now(),
      );
      UserApi.firestoreInstance
          .collection(_chatCollection)
          .withConverter(
              fromFirestore: ChatInfo.fromFirestore,
              toFirestore: (ChatInfo msg, options) => msg.toFirestore())
          .doc(chatData.chatId)
          .set(chatData)
          .then((value) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatScreen(
                userName: toUserData.name,
                userImage: toUserData.profile,
                chatId: chatId,
                frndId: toUserData.id,
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
                chatId: chatId,
                frndId: toUserData.id,
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
                chatId: chatId,
                frndId: toUserData.id,
              ),
            ));
      }
    }
  }

  //Send Messege
  sendMessege(MsgContent con, String chatId,String frndId) async {
    UserApi.firestoreInstance
        .collection(_chatCollection)
        .doc(chatId) //here current chat id
        .collection(_collectionMsgList)
        .withConverter(
            fromFirestore: MsgContent.fromFirestore,
            toFirestore: (MsgContent msgContent, options) =>
                msgContent.toFirestore())
        .add(con)
        .then(
          (DocumentReference value) => {},
        );
    await UserApi.firestoreInstance
        .collection(_chatCollection)
        .doc(chatId)
        .update({
      'lastMsg': con.content,
      'senderId': AuthApi().uid,
      'friendId':frndId,
    });
  }

//Generate chat ids
  String uniqueChatId({required String withChat}) {
    if (withChat.compareTo(AuthApi().uid) > 0) {
      return withChat + AuthApi().uid;
    } else {
      return AuthApi().uid + withChat;
    }
  }

  // String getfriendId(UserInformation info) {
  //   return info.id;
  // }
}
