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
  final TextEditingController _nameController = TextEditingController();

  // String number;
  // String _imageUrl = '';

  File? image;

  //For selecting image
  void selectImage(BuildContext context) async {
    image = await pickImage(context);
    setState(() {});
  }

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
            : Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () => selectImage(context),
                      child: image == null
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
                              backgroundImage: FileImage(image!),
                              radius: 60,
                            ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),

                    // Container(
                    //   height: MediaQuery.of(context).size.height * 0.3,
                    //   width: MediaQuery.of(context).size.width * 0.3,
                    //   decoration: BoxDecoration(
                    //     shape: BoxShape.circle,
                    //     color: Colors.grey[400],
                    //   ),
                    //   child: IconButton(
                    //     onPressed: () async {
                    //       // 1)
                    //       //capture an image (image_picker)
                    //       ImagePicker imagePicker = ImagePicker();
                    //       XFile? file =
                    //           await imagePicker.pickImage(source: ImageSource.camera);
                    //       print('${file?.path}');
                    //       if (file == null) return;
                    //       // 2)
                    //       // upload an image to firebase storage(Even before uploading a file
                    //       //we have to create the reference of the file to be uploaded)

                    //       String uniqueFileName =
                    //           DateTime.now().microsecond.toString();

                    //       //Get a reference of storage root
                    //       Reference referenceRoot = FirebaseStorage.instance.ref();
                    //       Reference referenceDirImages =
                    //           referenceRoot.child('images');

                    //       //create the reference for a image to be stored
                    //       Reference referenceImageToUpload =
                    //           referenceDirImages.child(uniqueFileName);

                    //       // try {
                    //       // 2.1) store the file(image) to firebase
                    //       await referenceImageToUpload.putFile(File(file.path));
                    //       // await referenceImageToUpload.putFile(File(file.path));
                    //       // 3) get download url of image
                    //       _imageUrl = await referenceImageToUpload.getDownloadURL();
                    //       // } catch (error) {}

                    //       // store url on firestore database corresponding to item
                    //       // display data on ItemViewPage
                    //     },
                    //     icon: const Icon(Icons.camera_alt_outlined),
                    //   ),
                    // ),
                    TextField(
                      controller: _nameController,
                      decoration:
                          const InputDecoration(hintText: 'Enter your name'),
                      keyboardType: TextInputType.name,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomButton(
                      text: 'Continue',
                      onpress: () async {
                        storeData(context);
                        // UserInformation info = UserInformation(
                        //   name: _nameController.text.trim(),
                        //   profile: _imageUrl,
                        //   id: AuthApi.uid!,
                        //   // number: number,
                        // );
                        // await AuthApi().addData(info);
                      },
                    )
                    // ElevatedButton(
                    //   onPressed: () async {
                    //     UserInformation info = UserInformation(
                    //       name: _nameController.text.trim(),
                    //       profile: _imageUrl,
                    //       id: AuthApi.uid!,
                    //       // number: number,
                    //     );
                    //     await AuthApi().addData(info);
                    //   },
                    //   child: const Text('Next'),
                    // ),
                  ],
                ),
              ),
      ),
    );
  }

  void storeData(BuildContext context) async {
    print('STORE DATA FUN');
    final ap = Provider.of<AuthProvider>(context, listen: false);
    UserInformation info = UserInformation(
      name: _nameController.text.trim(),
      id: ap.uid!,
      number: ap.firebaseAuth.currentUser!.phoneNumber!,
      profile: ap.downloadUrlGetter,
    );
    if (image != null) {
      ap.saveUserDataToFirebase(
        context: context,
        info: info,
        profilePic: image!,
        // downloadUrl:ap.downloadUrlGetter,
        onSuccess: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatBoardScreen(),
              ));
        },
      );
    } else {
      showSnackBar(context, 'Please upload your profile photo');
    }
  }
}
