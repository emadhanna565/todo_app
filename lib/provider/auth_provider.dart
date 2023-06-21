import 'package:flutter/material.dart';
import 'package:todo_app/database/model/task.dart';
import 'package:todo_app/database/model/user.dart';
import 'package:todo_app/database/my_database.dart';

class AuthProvider extends ChangeNotifier {
  User? currentUser;

  void updateUser(User loggedInUser) {
    currentUser = loggedInUser;
    notifyListeners();
  }

  void updateEdit(Task task) {
    MyDataBase.updateTask(currentUser!.id!, task).then((value) {
      print('edit is done');
      notifyListeners();
    });
  }
}
