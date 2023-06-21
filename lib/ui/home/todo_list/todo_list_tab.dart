// ignore_for_file: avoid_unnecessary_containers

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/database/model/task.dart';
import 'package:todo_app/database/my_database.dart';
import 'package:todo_app/provider/auth_provider.dart';
import 'package:todo_app/ui/home/todo_list/task_item.dart';

class TodoListTap extends StatefulWidget {
  const TodoListTap({Key? key}) : super(key: key);

  @override
  State<TodoListTap> createState() => _TodoListTapState();
}

class _TodoListTapState extends State<TodoListTap> {
  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthProvider>(context);
    return Container(
      child: Column(
        children: [
          Expanded(
              child: StreamBuilder<QuerySnapshot<Task>>(
            stream: MyDataBase.getTasksRealTimeUpdates(
                authProvider.currentUser?.id ?? ""),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              var taskList =
                  snapshot.data?.docs.map((doc) => doc.data()).toList();
              if (taskList?.isEmpty == true) {
                return const Center(
                  child: Text("you don't have any tasks yet"),
                );
              }
              return ListView.builder(
                itemBuilder: (context, index) {
                  return TaskItem(taskList![index]);
                },
                itemCount: taskList?.length ?? 0,
              );
            },
          )),
        ],
      ),
    );
  }
}
