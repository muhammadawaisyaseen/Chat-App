import 'dart:io';
import 'package:chat_app/pages/chat_board.dart';
import 'package:chat_app/provider/auth_provider.dart';
import 'package:chat_app/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
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
                          text: 'REGISTER',
                          onpress: () async {
                            await authPro.onRegister(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatBoardScreen(),
                              ),
                            );
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
}
