// ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'dart:convert';

import 'package:chat_app/models/messege.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatInfo {
  final String? chatId;
  // final String? senderId;
  // final String? friendId;
  // final String? lastMsg;
  final Timestamp? lastTime;
  final List<String> persons;
  Messege? lastMessage;
  ChatInfo({
    required this.chatId,
    // required this.senderId,
    // required this.friendId,
    //  this.lastMsg,
    this.lastTime,
    required this.persons,
    this.lastMessage,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'chatId': chatId,
      // if (senderId != null) 'senderId': senderId,
      // if (friendId != null) 'friendId': friendId,
      // 'lastMsg': lastMsg,
      'lastTime': lastTime,
      'persons': persons,
      'lastMessage': lastMessage!.toMap(),
    };
  }

  // factory Chat.fromMap(Map<String, dynamic> map) {
  //   return Chat(
  //     chatID: map['chat_id'] ?? '',
  //     persons: List<String>.from(map['persons']),
  //     unseenMessages: map['unseen_messages'] == null
  //         ? <Message>[]
  //         : List<Message>.from(
  //             map['unseen_messages']?.map((dynamic x) => Message.fromMap(x))),
  //     isGroup: map['is_group'] ?? false,
  //     groupInfo: map['group_info'] != null
  //         ? ChatGroupInfo.fromMap(map['group_info'])
  //         : null,
  //     pid: map['pid'],
  //     prodIsVideo: map['prod_is_video'] ?? true,
  //     lastMessage: Message.fromMap(map['last_message']),
  //     timestamp: map['timestamp'] ?? 0,
  //   );
  // }

  factory ChatInfo.fromMap(Map<String, dynamic> map) {
    return ChatInfo(
      chatId: map['chatId'] ?? '',
      // senderId: data?['senderId'] as String,
      // friendId: data?['friendId'] as String,
      // lastMsg: map['lastMsg'] as String,
      lastTime: map['lastTime'] as Timestamp,
      persons: List<String>.from(map['persons']),
      lastMessage: Messege.fromMap(map['lastMessage']),
    );
  }
}
