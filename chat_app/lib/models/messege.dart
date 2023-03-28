// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Messege {
  String senderId;
  String friendId;
  String senderName;
  String friendName;
  String lastMsg;
  Timestamp lastTime;
  int msg_no;
  Messege({
    required this.senderId,
    required this.friendId,
    required this.senderName,
    required this.friendName,
    required this.lastMsg,
    required this.lastTime,
    required this.msg_no,
  });

  Map<String, dynamic> toFirestore() {
    return{
      if(senderId!=null) 'senderId': senderId,
      if(friendId!=null)'friendId': friendId,
      if(senderName!=null)'senderName': senderName,
      if(friendName!=null)'friendName': friendName,
      if(lastMsg!=null)'lastMsg': lastMsg,
      if(lastTime!=null)'lastTime': lastTime,
      if(msg_no!=null)'msg_no': msg_no,
    };
  }

  factory Messege.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Messege(
      senderId: data?['senderId'] as String,
      friendId: data?['friendId'] as String,
      senderName: data?['senderName'] as String,
      friendName: data?['friendName'] as String,
      lastMsg: data?['lastMsg'] as String,
      lastTime: data?['lastTime'] as Timestamp,
      msg_no: data?['msg_no'] as int,
    );
  }
}
