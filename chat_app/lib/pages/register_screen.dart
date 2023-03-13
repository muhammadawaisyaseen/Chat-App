// import 'dart:html';

import 'dart:io';

import 'package:chat_app/database/auth_api.dart';
import 'package:chat_app/models/user_info.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});
  final TextEditingController _nameController = TextEditingController();
  // String number;
  String _imageUrl = '';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Register'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: MediaQuery.of(context).size.width * 0.3,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[400],
                  ),
                  child: IconButton(
                    onPressed: () async {
                      // 1)
                      //capture an image (image_picker)
                      ImagePicker imagePicker = ImagePicker();
                      XFile? file = await imagePicker.pickImage(
                          source: ImageSource.camera);
                      print('${file?.path}');
                      if (file == null) return;
                      // 2)
                      // upload an image to firebase storage(Even before uploading a file
                      //we have to create the reference of the file to be uploaded)

                      String uniqueFileName =
                          DateTime.now().microsecond.toString();

                      //Get a reference of storage root
                      Reference referenceRoot = FirebaseStorage.instance.ref();
                      Reference referenceDirImages =
                          referenceRoot.child('images');

                      //create the reference for a image to be stored
                      Reference referenceImageToUpload =
                          referenceDirImages.child(uniqueFileName);

                      // try {
                      // 2.1) store the file(image) to firebase
                      await referenceImageToUpload.putFile(File(file.path));
                      // await referenceImageToUpload.putFile(File(file.path));
                      // 3) get download url of image
                      _imageUrl = await referenceImageToUpload.getDownloadURL();
                      // } catch (error) {}

                      // store url on firestore database corresponding to item
                      // display data on ItemViewPage
                    },
                    icon: const Icon(Icons.camera_alt_outlined),
                  ),
                ),
                TextField(
                  controller: _nameController,
                  decoration:
                      const InputDecoration(hintText: 'Enter your name'),
                  keyboardType: TextInputType.name,
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () async {
                    UserInformation info = UserInformation(
                      name: _nameController.text.trim(),
                      profile: _imageUrl,
                      id: AuthApi.uid!,
                      // number: number,
                    );
                    await AuthApi().addData(info);
                  },
                  child: const Text('Next'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
