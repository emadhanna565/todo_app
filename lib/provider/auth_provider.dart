import 'package:flutter/material.dart';
import 'package:todo_app/database/model/user.dart';

class AuthProvider extends ChangeNotifier {
  User? currentUser;

  void updateUser(User loggedInUser) {
    currentUser = loggedInUser;
    notifyListeners();
  }
}
