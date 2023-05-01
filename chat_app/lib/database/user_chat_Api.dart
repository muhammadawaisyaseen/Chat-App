import 'package:chat_app/database/auth_api.dart';
import 'package:chat_app/database/user_api.dart';
import 'package:chat_app/models/chat_info.dart';
import 'package:chat_app/models/messege.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_info.dart';

class UserChatApi {
  static const String _chatCollection = 'chat';
  static const String _collectionMsgList = 'msgList';

  // Getting chat to display
  Stream<List<Messege>> gettingChat(String chatId) {
    return UserApi.firestoreInstance
        .collection(_chatCollection)
        .doc(chatId)
        .collection(_collectionMsgList)
        .orderBy('timeStamp', descending: true)
        .snapshots()
        .map((event) {
      final List<Messege> messege = [];
      for (DocumentSnapshot<Map<String, dynamic>> element in event.docs) {
        final Messege temp = Messege.fromMap(element.data()!);
        messege.add(temp);
      }
      return messege;
    });
  }

  // goChat(
  //     UserInformation toUserData, BuildContext context, String chatId) async {
  //If current user(I) trying to send messege to another person and click on messege
  // QuerySnapshot<ChatInfo> fromMesseges = await UserApi.firestoreInstance
  //     .collection(_chatCollection)
  //     .withConverter(
  //       fromFirestore: ChatInfo.fromFirestore,
  //       toFirestore: (ChatInfo msg, options) => msg.toFirestore(),
  //     )
  //     //FROM
  //     .where("senderId", isEqualTo: AuthApi().uid)
  //     //TO
  //     .where("friendId", isEqualTo: toUserData.id)
  //     .get();

  //If another person trying to send messege to current user(ME)
  // QuerySnapshot<ChatInfo> toMesseges = await UserApi.firestoreInstance
  //     .collection(_chatCollection)
  //     .withConverter(
  //       fromFirestore: ChatInfo.fromFirestore,
  //       toFirestore: (ChatInfo msg, options) => msg.toFirestore(),
  //     )
  //     .where("senderId", isEqualTo: toUserData.id)
  //     .where("friendId", isEqualTo: AuthApi().uid)
  //     .get();

  // If there is no chat b/w them
  // if (fromMesseges.docs.isEmpty && toMesseges.docs.isEmpty) {
  //   ChatInfo chatData = ChatInfo(
  //     chatId: chatId,
  //     senderId: AuthApi().uid,
  //     friendId: toUserData.id,
  //     lastMsg: "",
  //     lastTime: Timestamp.now(),
  //   );
  //   UserApi.firestoreInstance
  //       .collection(_chatCollection)
  //       .withConverter(
  //           fromFirestore: ChatInfo.fromFirestore,
  //           toFirestore: (ChatInfo msg, options) => msg.toFirestore())
  //       .doc(chatData.chatId)
  //       .set(chatData)
  //       .then((value) {
  //     Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => ChatScreen(
  //             userName: toUserData.name,
  //             userImage: toUserData.profile,
  //             chatId: chatId,
  //             frndId: toUserData.id,
  //           ),
  //         ));
  //   });
  // }
  // else {
  // If there is chat b/w them
  //   if (fromMesseges.docs.isNotEmpty) {
  //     // ignore: use_build_context_synchronously
  //     Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => ChatScreen(
  //             userName: toUserData.name,
  //             userImage: toUserData.profile,
  //             chatId: chatId,
  //             frndId: toUserData.id,
  //           ),
  //         ));
  //   }
  //   if (toMesseges.docs.isNotEmpty) {
  //     // ignore: use_build_context_synchronously
  //     Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => ChatScreen(
  //             userName: toUserData.name,
  //             userImage: toUserData.profile,
  //             chatId: chatId,
  //             frndId: toUserData.id,
  //           ),
  //         ));
  //   }
  //   // }
  // }

  // Future<void> sendMessage({
  //   required Chat chat,
  //   required AppUser receiver,
  //   required AppUser sender,
  // }) async {
  //   final Message? newMessage = chat.lastMessage;
  //   try {
  //     if (newMessage != null) {
  //       await _instance
  //           .collection(_collection)
  //           .doc(chat.chatID)
  //           .collection(_subCollection)
  //           .doc(newMessage.messageID)
  //           .set(newMessage.toMap());
  //     }
  //     await _instance
  //         .collection(_collection)
  //         .doc(chat.chatID)
  //         .set(chat.toMap());
  //     if (receiver.deviceToken.isNotEmpty) {
  //       await NotificationsServices().sendSubsceibtionNotification(
  //         deviceToken: receiver.deviceToken,
  //         messageTitle: sender.displayName ?? 'App User',
  //         messageBody: newMessage!.text ?? 'Send you a message',
  //         data: <String>['chat', 'message', 'personal'],
  //       );
  //     }
  //   } catch (e) {
  //     CustomToast.errorToast(message: e.toString());
  //   }
  // }

//Recent chat screen
  // Stream<List<Chat>> chats() {
  //   return _instance
  //       .collection(_collection)
  //       .where('persons', arrayContains: AuthMethods.uid)
  //       .where('is_group', isEqualTo: false)
  //       .orderBy('timestamp', descending: true)
  //       .snapshots()
  //       .asyncMap((QuerySnapshot<Map<String, dynamic>> event) {
  //     List<Chat> chats = <Chat>[];
  //     for (DocumentSnapshot<Map<String, dynamic>> element in event.docs) {
  //       final Chat temp = Chat.fromMap(element.data()!);
  //       chats.add(temp);
  //     }
  //     return chats;
  //   });
  // }

//Recent chat screen()
  Stream<List<ChatInfo>> gettingRecentChatData() {
    return UserApi.firestoreInstance
        .collection(_chatCollection)
        .where('persons', arrayContains: AuthApi().uid)
        .orderBy('timeStamp', descending: true)
        .snapshots()
        .asyncMap((QuerySnapshot<Map<String, dynamic>> event) {
      List<ChatInfo> chats = [];
      for (DocumentSnapshot<Map<String, dynamic>> element in event.docs) {
        chats.add(ChatInfo.fromMap(element.data()!));
      }
      return chats;
    });
  }

// Getting user DP and Name to display on RecentChatScreen
  Future<UserInformation> getUserDpAndName(String info) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await AuthApi()
        .firestoreInstance
        .collection(UserApi().collection)
        .doc(info)
        .get();
    return UserInformation.fromMap(snapshot);
  }

// Send Messege
  Future<void> sendMessege({required ChatInfo chat}) async {
    final Messege? newMessege = chat.lastMessage;
    try {
      if (newMessege != null) {
        await UserApi.firestoreInstance
            .collection(_chatCollection)
            .doc(chat.chatId)
            .collection(_collectionMsgList)
            .doc()
            .set(newMessege.toMap());
      }
      await UserApi.firestoreInstance
          .collection(_chatCollection)
          .doc(chat.chatId)
          .set(chat.toMap());
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }

// Getting chat to display

  // Stream<List<Message>> messages(String chatID) {
  //   return _instance
  //       .collection(_collection)
  //       .doc(chatID)
  //       .collection(_subCollection)
  //       .orderBy('timestamp', descending: true)
  //       .snapshots()
  //       .map((QuerySnapshot<Map<String, dynamic>> event) {
  //     final List<Message> messages = <Message>[];
  //     for (DocumentSnapshot<Map<String, dynamic>> element in event.docs) {
  //       final Message temp = Message.fromMap(element.data()!);
  //       messages.add(temp);
  //     }
  //     return messages;
  //   });
  // }



//Generate chat ids it will remain same for both users
  String uniqueChatId({required String withChat}) {
    if (withChat.compareTo(AuthApi().uid) > 0) {
      return withChat + AuthApi().uid;
    } else {
      return AuthApi().uid + withChat;
    }
  }
}
