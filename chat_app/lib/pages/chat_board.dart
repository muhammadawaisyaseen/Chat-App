import 'package:chat_app/database/user_api.dart';
import 'package:chat_app/models/user_info.dart';
import 'package:chat_app/provider/auth_provider.dart';
import 'package:chat_app/widgets/custom_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fast_contacts/fast_contacts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class ChatBoardScreen extends StatelessWidget {
  const ChatBoardScreen({super.key});
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
                  future: UserApi().retrieveData(),
                  builder:
                      (context, AsyncSnapshot<List<UserInformation>> snapshot) {
                    if (snapshot.data == null) {
                      const SizedBox(
                        height: 60,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    List<UserInformation> user = snapshot.data ?? [];
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
                                Text(user[index].name),
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
                                  textColor: Colors.white,
                                  btnColor: Colors.amber,
                                  width: 80,
                                  height: 40,
                                  text: 'Messege',
                                  onpress: () {},
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
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
                      future: authPro.getContacts(),
                      builder:
                          (context, AsyncSnapshot<List<Contact>> snapshot) {
                        if (snapshot.data == null) {
                          const SizedBox(
                            height: 60,
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                        return ListView.builder(
                          itemCount: snapshot.data?.length ?? 0,
                          itemBuilder: (context, index) {
                            Contact contact = snapshot.data![index];
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
                                    Text(contact.displayName),
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
