import 'package:chat_app/database/user_api.dart';
import 'package:chat_app/models/user_info.dart';
import 'package:chat_app/pages/chat_screen.dart';
import 'package:chat_app/provider/auth_provider.dart';
import 'package:chat_app/widgets/custom_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fast_contacts/fast_contacts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class ChatBoardScreen extends StatefulWidget {
  ChatBoardScreen({super.key});

  @override
  State<ChatBoardScreen> createState() => _ChatBoardScreenState();
}

class _ChatBoardScreenState extends State<ChatBoardScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFFf4f4f4),
        body: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start, // |
            crossAxisAlignment: CrossAxisAlignment.start, // --------------
            children: [
              Row(
                children: const [
                  Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.black,
                  ),
                  SizedBox(
                    width: 120,
                  ),
                  Text(
                    'Contacts',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.grey.shade100,
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const TextField(
                  // onChanged: (value) => ,
                  decoration: InputDecoration(
                    hintText: 'Search Contacts...',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                    ),
                    border: InputBorder.none,
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.grey,
                      size: 25,
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  ),

                  keyboardType: TextInputType.name,
                ),
              ),
              const SizedBox(
                height: 20,
              ),

              // My Chat App Contacts

              const Text(
                'My App Contacts',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),

              Expanded(
                child: FutureBuilder(
                  future: getAppContacts(),
                  builder: (context, AsyncSnapshot<List<String>> snapshot) {
                    if (snapshot.data == null) {
                      return const SizedBox(
                        height: 60,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    } else if (snapshot.hasData) {
                      List<String> appContacts = snapshot.data ?? [];
                      return ListView.builder(
                        itemCount: snapshot.data?.length ?? 0,
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: const BoxDecoration(
                              color: Color(0xFFf4f4f4),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(14),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.person,
                                    color: Colors.blue,
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Text(appContacts[index]),
                                  const Spacer(),
                                  CustomButton(
                                    textfontSize: 14,
                                    textColor: Colors.grey,
                                    btnColor: Color(0xFFe2eff5),
                                    width: 60,
                                    height: 40,
                                    text: 'Send',
                                    onpress: () {},
                                  ),
                                  const SizedBox(
                                    width: 12,
                                  ),
                                  CustomButton(
                                    textfontSize: 14,
                                    textColor: Color.fromARGB(255, 56, 35, 35),
                                    btnColor: Colors.amber,
                                    width: 80,
                                    height: 40,
                                    text: 'Messege',
                                    onpress: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ChatScreen(),
                                          ));
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return const SizedBox(
                        height: 60,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                  },
                ),
              ),

              // Invite to My Chat App

              const Text(
                'Invite to my Chatt App',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              Consumer<AuthProvider>(
                builder: (context, AuthProvider authPro, child) {
                  return Expanded(
                    child: FutureBuilder<List<Contact>>(
                      future: FastContacts.getAllContacts(),
                      builder:
                          (context, AsyncSnapshot<List<Contact>> snapshot) {
                        if (snapshot.hasError) {
                          return Text('Something goes wrong ${snapshot.error}');
                        }
                        if (snapshot.hasData) {
                          final List<Contact> myContacts = snapshot.data ?? [];
                          // print('My Contacts $myContacts');
                          return ListView.builder(
                            itemCount: myContacts.length,
                            itemBuilder: (context, index) {
                              Contact contact = myContacts[index];
                              return Container(
                                decoration: const BoxDecoration(
                                  color: Color(0xFFf4f4f4),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(14),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.person_pin_rounded,
                                        color: Colors.blue,
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(contact.displayName),
                                          Text(contact.phones[0].number),
                                        ],
                                      ),
                                      const Spacer(),
                                      CustomButton(
                                        textfontSize: 14,
                                        textColor: Colors.white,
                                        btnColor: Colors.amber,
                                        width: 80,
                                        height: 40,
                                        text: 'Invite',
                                        onpress: () {},
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        } else {
                          return const SizedBox(
                            height: 60,
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                      },
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

Future<List<Contact>> getContacts() async {
  bool isGranted = await Permission.contacts.status.isGranted;
  if (!isGranted) {
    isGranted = await Permission.contacts.request().isGranted;
  }
  if (isGranted) {
    return await FastContacts.getAllContacts();
  }
  return [];
}

Future<List<String>> getAppContacts() async {
  List<Contact> contact = await getContacts();
  List<UserInformation> userList = await UserApi().retrieveData();
  List<String> dummy = [];
  for (int i = 0; i < contact.length; i++) {
    for (int j = 0; j < userList.length; j++) {
      if (contact[i].phones[0].number.startsWith('0')) {
        if (contact[i]
                .phones[0]
                .number
                .replaceAll(' ', '')
                .replaceFirst('0', '+92') ==
            userList[j].number) {
          print('Matched NO: ${contact[i].phones[0].number}');
          dummy.add(userList[j].id);
        }
      }
    }
  }
  return dummy;
}
