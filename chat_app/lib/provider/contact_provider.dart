import 'package:fast_contacts/fast_contacts.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../database/user_api.dart';
import '../models/user_info.dart';

class ContactProvider with ChangeNotifier {
  List<Contact> contact = [];

  
}
