import 'package:flutter/material.dart';
import 'package:todo_app/ui/home/todo_list/task_item.dart';

class TodoListTap extends StatelessWidget {
  const TodoListTap({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                return TaskItem();
              },
              itemCount: 5,
            ),
          ),
        ],
      ),
    );
  }
}
