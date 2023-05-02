import 'package:chat_app/database/auth_api.dart';
import 'package:chat_app/database/user_api.dart';
import 'package:chat_app/database/user_chat_Api.dart';
import 'package:chat_app/models/chat_info.dart';
import 'package:chat_app/models/user_info.dart';
import 'package:chat_app/pages/chat_board.dart';
import 'package:chat_app/provider/auth_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RecentChatScreen extends StatelessWidget {
  const RecentChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.black,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(
                    width: 110,
                  ),
                  const Text(
                    'Messeges',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(
                    width: 70,
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ChatBoardScreen(),
                          ));
                    },
                    icon: const Icon(Icons.message),
                  )
                ],
              ),
            ),
            Expanded(
                child: StreamBuilder<List<ChatInfo>>(
              stream: UserChatApi().gettingRecentChatData(),
              builder: (context, snapshot) {
                List<ChatInfo>? chat = snapshot.data ?? [];
                print('Chat List: ${chat.length}');
                if (snapshot.hasError) {
                  return Text('Error is => : ${snapshot.error}');
                } else if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: chat.length,
                    itemBuilder: (context, index) {
                      return FutureBuilder<UserInformation?>(
                        future: UserChatApi().getUserDpAndName(chat[index]
                            .persons
                            .where((element) => element != AuthApi().uid)
                            .first),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else if (snapshot.hasData) {
                            UserInformation? data = snapshot.data;
                            return Container(
                              decoration: const BoxDecoration(
                                color: Color(0xFFf4f4f4),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(14),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: NetworkImage(
                                                data!.profile.toString()
                                                // 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTGewlc-5bqNx4S8F6wt4UDQQUXdZ3yOJq4Bg&usqp=CAU' // doc['profile'].toString(),

                                                ),
                                            fit: BoxFit.cover),
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          data.name.toString(),
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(chat[index]
                                            .lastMessage!
                                            .content
                                            .toString()),
                                        // Text(chat[index].lastMsg.toString()),
                                      ],
                                    ),
                                    const Spacer(),
                                    Text(chat[index].lastTime.toString()),
                                  ],
                                ),
                              ),
                            );
                          } else {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                        },
                      );
                    },
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ))
          ],
        ),
      ),
    );
  }
}
