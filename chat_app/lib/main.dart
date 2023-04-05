import 'package:chat_app/firebase_options.dart';
import 'package:chat_app/pages/chat_board.dart';
import 'package:chat_app/pages/number_screen.dart';
import 'package:chat_app/pages/recent_chat_screen.dart';
import 'package:chat_app/provider/auth_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'database/auth_api.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        // home: ChatBoardScreen(),
        home: AuthApi.getCurrentUser == null
            ? const NumberScreen()
            : const RecentChatScreen(),
      ),
    );
  }
}
