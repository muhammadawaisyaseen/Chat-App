import 'package:chat_app/database/user_chat_Api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// class ChatScreen extends StatefulWidget {
//   ChatScreen({
//     // required this.userId, required this.userName,
//      super.key});
//   // String userId;
//   // String userName;

//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   // Stream<QuerySnapshot> chats;

//   // getChats() {
//   //   UserChat().getChats(widget.userId).
//   // }

//   @override
//   // void initState() {
//   //   getChats();
//   //   // TODO: implement initState
//   //   super.initState();
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Chat screen'),
//       ),
//     );
//   }
// }

class ChatScreen extends StatefulWidget {
  final String userName;
  final String userImage;

  ChatScreen({required this.userName, required this.userImage});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  void _handleSubmitted(String text) {
    _messegeController.clear();
    setState(() {
      // messages.insert(0, text);
    });
  }

  TextEditingController _messegeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFFf4f4f4),
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
            const Spacer(),
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
                        controller: _messegeController,
                        // onSubmitted: ,
                        decoration: const InputDecoration.collapsed(
                            hintText: 'Send a message'),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: IconButton(
                          icon: const Icon(Icons.send),
                          onPressed: () =>
                              _handleSubmitted(_messegeController.text)),
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
