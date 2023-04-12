
import 'package:cloud_firestore/cloud_firestore.dart';

class Messege {
  final String? content;
  final String? type;
  final Timestamp? timeStamp;
  final String sendBy;
  final String sendTo;
  Messege({
    required this.content,
    required this.type,
    required this.timeStamp,
    required this.sendBy,
    required this.sendTo,
    
  });

  Map<String, dynamic> toMap() {
    return{
      'content': content,
      'type': type,
      'timeStamp': timeStamp,
      'sendBy':sendBy,
      'sendTo':sendTo
    };
  }

  factory Messege.fromMap(Map<String,dynamic> map) {
    return Messege(
      content: map['content'] as String,
      type: map['type'] as String,
      timeStamp: map['timeStamp'],
      sendBy:map['sendBy'],
      sendTo:map['sendTo'],
    );
  }
}
