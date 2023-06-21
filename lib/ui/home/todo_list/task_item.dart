// ignore_for_file: use_key_in_widget_constructors, must_be_immutable, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/database/model/task.dart';
import 'package:todo_app/database/my_database.dart';
import 'package:todo_app/provider/auth_provider.dart';
import 'package:todo_app/ui/dialog_utils.dart';

class TaskItem extends StatefulWidget {
  Task task;

  TaskItem(this.task);

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      child: Slidable(
        startActionPane: ActionPane(
          extentRatio: 0.25,
          motion: const DrawerMotion(),
          children: [
            SlidableAction(
              onPressed: (context) {
                deleteTask();
              },
              icon: Icons.delete,
              backgroundColor: Colors.red,
              label: 'Delete',
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(18),
                  bottomLeft: Radius.circular(18)),
            )
          ],
        ),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(4)),
                width: 8,
                height: 80,
              ),
              const SizedBox(
                width: 12,
              ),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.task.title!,
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Text('${widget.task.desc}'),
                ],
              )),
              Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.access_time),
                      Text('${widget.task.dateTime}'),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 7, horizontal: 21),
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(12)),
                    child: Image.asset('assets/images/Icon_check.png'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void deleteTask() {
    DialogUtils.showMessage(context, 'Do yo want to delete this task ',
        postActionName: 'Yes',
        postAction: () async {
          deleteTaskFromDataBAse();
        },
        nagActionName: 'Cancel',
        nagAction: () {
          Navigator.pop(context);
        });
  }

  void deleteTaskFromDataBAse() async {
    var authProvider = Provider.of<AuthProvider>(context, listen: false);
    try {
      await MyDataBase.deleteTask(
          authProvider.currentUser?.id ?? "", widget.task.id ?? "");
      DialogUtils.showMessage(context, 'Task deleted successfully',
          postActionName: 'Ok');
    } catch (e) {
      DialogUtils.showMessage(context, e.toString(), postActionName: 'hide',
          postAction: () {
        Navigator.pop(context);
      });
    }
  }
}
