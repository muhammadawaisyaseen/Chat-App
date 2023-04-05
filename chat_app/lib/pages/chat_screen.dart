import 'package:chat_app/database/auth_api.dart';
import 'package:chat_app/database/user_api.dart';
import 'package:chat_app/database/user_chat_Api.dart';
import 'package:chat_app/models/messege_content.dart';
import 'package:chat_app/widgets/messege_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String userName;
  final String userImage;
  final String chatId;
  final String frndId;
  ChatScreen(
      {required this.userName,
      required this.userImage,
      required this.chatId,
      required this.frndId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messegeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFf4f4f4),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start, // |
          crossAxisAlignment: CrossAxisAlignment.start, // --------------
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 60,
              decoration: const BoxDecoration(
                color: Colors.amber,
              ),
              child: Row(
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.black,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(widget.userImage),
                          fit: BoxFit.cover),
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Text(
                    widget.userName,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: StreamBuilder(
                stream: UserChatApi().gettingChat(widget.chatId),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return const Center(
                        child: Text('Loading...'),
                      );
                    default:
                      return ListView.builder(
                        reverse: true,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (BuildContext context, int index) {
                          DocumentSnapshot document =
                              snapshot.data!.docs[index];
                          return MessegeTile(
                            content: document['content'],
                            sederId: document['senderId'],
                            sentByMe: AuthApi().uid == document['senderId'],
                          );
                        },
                      );
                  }
                },
              ),
            ),
            // Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(60),
                ),
                margin: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                ),
                child: Row(
                  children: [
                    Flexible(
                      child: TextField(
                        maxLines: null,
                        controller: _messegeController,
                        decoration: const InputDecoration.collapsed(
                            hintText: 'Send a message'),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: IconButton(
                          icon: const Icon(Icons.send),
                          onPressed: () {
                            MsgContent con = MsgContent(
                              senderId: AuthApi().uid,
                              content: _messegeController.text,
                              type: 'text',
                              addTime: Timestamp.now(),
                            );
                            UserChatApi()
                                .sendMessege(con, widget.chatId, widget.frndId);
                            _messegeController.clear();
                          }),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
