// import 'package:chat_app/database/auth_api.dart';
import 'package:chat_app/database/auth_api.dart';
import 'package:chat_app/database/user_chat_Api.dart';
import 'package:chat_app/models/chat_info.dart';
import 'package:chat_app/models/messege.dart';
import 'package:chat_app/models/user_info.dart';
import 'package:chat_app/widgets/messege_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final UserInformation chatWith;
  final ChatInfo chat;
  ChatScreen({
    required this.chatWith,
    required this.chat,
  });

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
                          image: NetworkImage(widget.chatWith.profile),
                          fit: BoxFit.cover),
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Text(
                    widget.chatWith.name,
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
                stream:
                    UserChatApi().gettingChat(widget.chat.chatId.toString()),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return const Center(
                          child: Text('Loading...'),
                        );
                      default:
                        List<Messege>? messeges = snapshot.data ?? [];
                        return ListView.builder(
                          reverse: true,
                          itemCount: messeges.length,
                          itemBuilder: (BuildContext context, int index) {
                            return MessegeTile(
                              messege: messeges[index],
                            );
                          },
                        );
                    }
                  } else {
                    return const Center(child: CircularProgressIndicator());
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
                            // Messege con = Messege(
                            //   senderId: AuthApi().uid,
                            //   content: _messegeController.text,
                            //   type: 'text',
                            //   timeStamp: Timestamp.now(),
                            // );
                            widget.chat.lastMessage = Messege(
                              content: _messegeController.text,
                              type: 'text',
                              timeStamp: Timestamp.now(),
                              sendBy: AuthApi().uid,
                              sendTo: widget.chatWith.id,
                            );
                            // ChatInfo info=ChatInfo(chatId: chatId, persons: persons)
                            UserChatApi().sendMessege(chat: widget.chat);
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
