// import 'dart:html';

import 'dart:io';
// import 'dart:js';

import 'package:chat_app/database/auth_api.dart';
import 'package:chat_app/utilities/utils.dart';
import 'package:chat_app/models/user_info.dart';
import 'package:chat_app/pages/chat_board.dart';
import 'package:chat_app/provider/auth_provider.dart';
import 'package:chat_app/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // final TextEditingController _nameController = TextEditingController();

  // String number;
  // String _imageUrl = '';

  // File? image;

  // //For selecting image
  // void selectImage(BuildContext context) async {
  //   image = await pickImage(context);
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    final isLoading =
        Provider.of<AuthProvider>(context, listen: true).isLoading;

    return Scaffold(
      body: SafeArea(
        child: isLoading == true
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.blue,
                ),
              )
            : Consumer<AuthProvider>(
                builder: (context, AuthProvider authPro, _) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () => authPro.selectImage(context),
                          child: authPro.image == null
                              ? const CircleAvatar(
                                  backgroundColor: Colors.blue,
                                  radius: 60,
                                  child: Icon(
                                    Icons.camera_alt_outlined,
                                    size: 50,
                                    color: Colors.white,
                                  ),
                                )
                              : CircleAvatar(
                                  backgroundImage: FileImage(authPro.image!),
                                  radius: 60,
                                ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextField(
                          controller: authPro.nameController,
                          decoration: const InputDecoration(
                              hintText: 'Enter your name'),
                          keyboardType: TextInputType.name,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        CustomButton(
                          text: 'Register',
                          onpress: () async {
                            authPro.onRegister(context);
                            // onRegister(context);
                          },
                        )
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }

  // void storeData(BuildContext context) async {
  //   print('STORE DATA FUN');
  //   final ap = Provider.of<AuthProvider>(context, listen: false);
  //   UserInformation info = UserInformation(
  //     name: _nameController.text.trim(),
  //     id: ap.uid!,
  //     number: ap.firebaseAuth.currentUser!.phoneNumber!,
  //     profile: ap.downloadUrlGetter,
  //   );
  //   if (image != null) {
  //     ap.saveUserDataToFirebase(
  //       context: context,
  //       info: info,
  //       profilePic: image!,
  //       // downloadUrl:ap.downloadUrlGetter,
  //       onSuccess: () {
  //         Navigator.push(
  //             context,
  //             MaterialPageRoute(
  //               builder: (context) => ChatBoardScreen(),
  //             ));
  //       },
  //     );
  //   } else {
  //     showSnackBar(context, 'Please upload your profile photo');
  //   }
  // }
}
