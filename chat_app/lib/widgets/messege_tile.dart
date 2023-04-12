// import 'package:chat_app/models/chat_info.dart';
import 'package:chat_app/database/auth_api.dart';
import 'package:chat_app/models/messege.dart';
import 'package:flutter/material.dart';

class MessegeTile extends StatelessWidget {
  const MessegeTile({
    required this.messege,
    super.key,
  });
  final Messege messege;
  @override
  Widget build(BuildContext context) {
    final bool isMe = messege.sendBy == AuthApi().uid;
    return Container(
      padding: EdgeInsets.only(
          top: 4, bottom: 4, left: isMe ? 0 : 24, right: isMe ? 24 : 0),
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.only(
          top: 17,
          bottom: 17,
          left: 40,
          right: 20,
        ),
        margin: isMe
            ? const EdgeInsets.only(left: 30)
            : const EdgeInsets.only(right: 30),
        decoration: BoxDecoration(
          borderRadius: isMe
              ? const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                )
              : const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
          color: isMe ? Theme.of(context).primaryColor : Colors.grey[700],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              messege.content.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
