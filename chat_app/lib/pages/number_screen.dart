import 'package:chat_app/constants/routes.dart';
import 'package:chat_app/database/auth_api.dart';
import 'package:chat_app/pages/otp_screen.dart';
import 'package:chat_app/provider/auth_provider.dart';
import 'package:chat_app/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

class NumberScreen extends StatelessWidget {
  NumberScreen({super.key});
  final TextEditingController _phoneNumberController = TextEditingController();
  // PhoneNumber? number;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Consumer<AuthProvider>(
          builder: (context, AuthProvider authPro, _) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 26),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start, // |
                crossAxisAlignment: CrossAxisAlignment.start, // --------------
                children: [
                  Row(
                    children: const [
                      Icon(Icons.arrow_back_ios),
                      SizedBox(
                        width: 140,
                      ),
                      Center(
                        child: Text(
                          'Number',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Center(
                    child: Text(
                      'Enter your phone number',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                      ),
                    ),
                    child: InternationalPhoneNumberInput(
                      textFieldController: _phoneNumberController,
                      onInputChanged: (PhoneNumber value) {
                          authPro.onPhoneNumberChange(value);
                          print('PHONE NUMBER:${authPro.phoneNumber}');
                      },
                      inputBorder: InputBorder.none,
                    ),
                  ),
                  const Spacer(),
                  Center(
                    child: CustomButton(
                      text: 'Send',
                      onpress: () {
                        authPro.verifyPhoneNum(context);
                        // print('In Button ${number!}');
                      },
                    ),

                    // ElevatedButton(
                    //   onPressed: () {
                    //     final ap =
                    //         Provider.of<AuthProvider>(context, listen: false);
                    //     ap.signInWithPhone(context, number!);
                    //     print('In ElevatedButton ${number!}');
                    // AuthApi().verifyNumber(context,number!);
                    // },
                    // onPressed: () async {
                    //   await FirebaseAuth.instance.verifyPhoneNumber(
                    //       phoneNumber: number?.phoneNumber,
                    //       verificationCompleted: (_) {
                    //         print('DONE');
                    //       },
                    //       verificationFailed: (e) {
                    //         print('ERROR: ${e.code}');
                    //       },
                    //       codeSent: (String verificationId, int? token) {
                    //         Navigator.push(
                    //           context,
                    //           MaterialPageRoute(
                    //             builder: (context) =>
                    //                 OtpVerify(verificationId: verificationId),
                    //           ),
                    //         );
                    //       },
                    //       codeAutoRetrievalTimeout: (e) {
                    //         print(e.hashCode);
                    //       });
                    //   FirebaseAuth.instance.currentUser!.uid;
                    // },
                    // child: Text('Login'),
                    // ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // void sendPhoneNumber() {
  //   final ap = Provider.of<AuthProvider>(context, listen: false);
  // String phoneNumber
  // }
}
