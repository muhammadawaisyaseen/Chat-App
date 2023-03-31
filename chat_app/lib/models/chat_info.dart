// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class ChatInfo {
  String? chatId;
  String? senderId;
  String? friendId;
  String? lastMsg;
  Timestamp? lastTime;
  ChatInfo({
    required this.chatId,
    required this.senderId,
    required this.friendId,
    required this.lastMsg,
    required this.lastTime,
  });

  Map<String, dynamic> toFirestore() {
    return {
      if (chatId != null) 'chatId': chatId,
      if (senderId != null) 'senderId': senderId,
      if (friendId != null) 'friendId': friendId,
      if (lastMsg != null) 'lastMsg': lastMsg,
      if (lastTime != null) 'lastTime': lastTime,
    };
  }

  factory ChatInfo.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return ChatInfo(
      chatId: data?['chatId'] as String,
      senderId: data?['senderId'] as String,
      friendId: data?['friendId'] as String,
      lastMsg: data?['lastMsg'] as String,
      lastTime: data?['lastTime'] as Timestamp,
    );
  }
}
