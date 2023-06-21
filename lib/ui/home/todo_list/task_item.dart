// ignore_for_file: use_key_in_widget_constructors, must_be_immutable, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/database/model/task.dart';
import 'package:todo_app/database/my_database.dart';
import 'package:todo_app/provider/auth_provider.dart';
import 'package:todo_app/ui/dialog_utils.dart';
import 'package:todo_app/ui/home/edit_task/edit_task.dart';

class TaskItem extends StatefulWidget {
  Task task;

  TaskItem(this.task);

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthProvider>(context);
    return InkWell(
      onTap: () {
        if (widget.task.isDone == false) {
          Navigator.pushNamed(context, EditTasksScreen.routeName,
              arguments: widget.task);
        } else {
          return;
        }
      },
      child: Container(
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
                        color: widget.task.isDone == false
                            ? Theme.of(context).primaryColor
                            : Color(0xff027971f),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Text('${widget.task.desc}'),
                  ],
                )),
                widget.task.isDone == true
                    ? Text(
                        'Done!',
                        style: Theme.of(context).textTheme.headline1,
                      )
                    : InkWell(
                        onTap: () {
                          widget.task.isDone = true;
                          authProvider.updateEdit(widget.task);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 7, horizontal: 21),
                          decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(12)),
                          child: Image.asset('assets/images/Icon_check.png'),
                        ),
                      ),
              ],
            ),
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
