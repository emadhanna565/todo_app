// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/MyDateUtils.dart';
import 'package:todo_app/database/model/task.dart';
import 'package:todo_app/database/my_database.dart';
import 'package:todo_app/provider/auth_provider.dart';
import 'package:todo_app/ui/component/custom_form_field.dart';
import 'package:todo_app/ui/dialog_utils.dart';

class AddTaskBottomSheet extends StatefulWidget {
  AddTaskBottomSheet({Key? key}) : super(key: key);

  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  TextEditingController titleController = TextEditingController();

  TextEditingController descriptionController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      padding: EdgeInsets.all(15),
      child: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                  child: Text(
                'Add New Task',
                style: Theme.of(context).textTheme.headline4,
              )),
              SizedBox(
                height: 12,
              ),
              CustomFormField(
                label: 'title',
                hintText: 'enter title of task',
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return 'please enter task title';
                  }
                  return null;
                },
                controller: titleController,
              ),
              SizedBox(
                height: 8,
              ),
              CustomFormField(
                label: 'description',
                hintText: 'enter description of task',
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return 'please enter description title';
                  }
                  return null;
                },
                controller: descriptionController,
                maxLine: 5,
              ),
              SizedBox(
                height: 12,
              ),
              Text('Task Date'),
              InkWell(
                onTap: () {
                  showTaskDatePiker();
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: 12),
                  padding: EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.black),
                    ),
                  ),
                  child: Text(
                    MyDateUtils.formatTaskDate(selectedDate),
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  addTask();
                },
                child: Text(
                  'Add Task',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void addTask() async {
    if (formKey.currentState?.validate() == false) {
      return;
    }
    DialogUtils.showLoadingDialog(context, 'Loading.......');
    Task task = Task(
      title: titleController.text,
      desc: descriptionController.text,
      dateTime: selectedDate,
    );
    var authProvider = Provider.of<AuthProvider>(context, listen: false);
    await MyDataBase.addTask(task, authProvider.currentUser?.id ?? "");
    DialogUtils.hideDialog(context);
    DialogUtils.showMessage(context, 'Task Added Successfully ',
        postActionName: 'Ok', postAction: () {
      DialogUtils.hideDialog(context);
    });
  }

  var selectedDate = DateTime.now();

  void showTaskDatePiker() async {
    var date = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (date == null) return;
    selectedDate = date;
    setState(() {});
  }
}
