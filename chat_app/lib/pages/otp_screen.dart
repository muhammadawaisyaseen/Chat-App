import 'package:chat_app/utilities/utils.dart';
import 'package:chat_app/provider/auth_provider.dart';
import 'package:chat_app/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  @override
  Widget build(BuildContext context) {
    final isLoading =
        Provider.of<AuthProvider>(context, listen: true).isLoading;
    return Scaffold(
      backgroundColor: Color(0xFFf4f4f4),
      body: SafeArea(
        child: isLoading == true
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.purple,
                ),
              )
            : Consumer<AuthProvider>(
                builder: (context, AuthProvider authPro, _) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 26),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start, // |
                      crossAxisAlignment:
                          CrossAxisAlignment.center, // --------------
                      children: [
                        Row(
                          children: [
                            IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(Icons.arrow_back_ios)),
                            const SizedBox(
                              width: 60,
                            ),
                            const Center(
                              child: Text(
                                'OTP verification',
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
                        Center(
                          child: Text(
                            'Code is send to ${authPro.phoneNumber!.phoneNumber}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Pinput(
                          length: 6,
                          showCursor: true,
                          defaultPinTheme: PinTheme(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.grey,
                              ),
                            ),
                            textStyle: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          onCompleted: (String value) {
                            authPro.onPinPutCompleted(value);
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                "Didn't receive the OTP?",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Resend OTP",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.amber,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        CustomButton(
                                                textfontSize: 18,
                      textColor: Colors.white,
                          btnColor: Colors.amber,
                          width: 140,
                      height: 50,
                          text: 'VERIFY',
                          onpress: () {
                            if (authPro.otp != null) {
                              authPro.verifyOtpFun(context);
                            } else {
                              showSnackBar(context, 'Enter 6 digits code');
                            }
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
