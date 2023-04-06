// ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class MsgContent {
  String? senderId;
  String? content;
  String? type;
  Timestamp? addTime;
  MsgContent({
    required this.senderId,
    required this.content,
    required this.type,
    required this.addTime,
  });

  Map<String, dynamic> toFirestore() {
    return{
      if(senderId!=null)'senderId': senderId,
      if(content!=null)'content': content,
      if(type!=null)'type': type,
      if(addTime!=null)'addTime': addTime,
    };
  }

  factory MsgContent.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return MsgContent(
      senderId: data?['senderId'] as String,
      content: data?['content'] as String,
      type: data?['type'] as String,
      addTime: data?['addTime'],
    );
  }
}
