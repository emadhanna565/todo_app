// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/database/model/task.dart';
import 'package:todo_app/database/my_database.dart';
import 'package:todo_app/provider/auth_provider.dart';
import 'package:todo_app/ui/component/custom_form_field.dart';
import 'package:todo_app/ui/dialog_utils.dart';
import 'package:todo_app/ui/home/home_screen.dart';

class EditTasksScreen extends StatefulWidget {
  static const String routeName = 'editTask';

  const EditTasksScreen({Key? key}) : super(key: key);

  @override
  State<EditTasksScreen> createState() => _EditTasksScreenState();
}

class _EditTasksScreenState extends State<EditTasksScreen> {
  TextEditingController? titleController;

  TextEditingController? descController;

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    Task task = ModalRoute.of(context)?.settings.arguments as Task;
    if (titleController == null || descController == null) {
      titleController = TextEditingController(text: task.title);
      descController = TextEditingController(text: task.desc);
      print(task.title);
      print(task.desc);
    }
    var authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            children: [
              AppBar(
                title: const Text('ToDo List '),
                backgroundColor: Colors.blue,
                flexibleSpace: SizedBox(
                  height: height * 0.3,
                ),
              )
            ],
          ),
          Positioned(
            top: height * 0.15,
            child: Container(
              height: height * 0.75,
              width: width * 0.8,
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Text(
                      'Edit Text',
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    SizedBox(
                      height: height * 0.03,
                    ),
                    CustomFormField(
                      label: 'task title ',
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'please enter task title ';
                        }
                        return null;
                      },
                      controller: titleController!,
                      hintText: 'Enter task title',
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    CustomFormField(
                      label: 'task description',
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'please enter task description ';
                        }
                        return null;
                      },
                      controller: descController!,
                      hintText: 'Enter task description',
                    ),
                    SizedBox(
                      height: height * 0.03,
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Selected Time',
                        style: Theme.of(context).textTheme.headline4,
                      ),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    InkWell(
                      onTap: () {
                        showTaskDatePicker(task);
                      },
                      child: Text(
                        '${task.dateTime?.day}-${task.dateTime?.month}-${task.dateTime?.year}',
                        style: Theme.of(context).textTheme.headline2,
                      ),
                    ),
                    SizedBox(
                      height: height * 0.15,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          task.title = titleController!.text;
                          task.desc = descController!.text;
                          DialogUtils.showLoadingDialog(context, 'Loading....');
                          MyDataBase.updateTask(
                                  authProvider.currentUser!.id!, task)
                              .then((value) {
                            DialogUtils.hideDialog(context);
                            DialogUtils.showMessage(
                                context, 'Task edited successfully....',
                                postActionName: 'Ok', postAction: () {
                              Navigator.pushNamed(
                                  context, HomeScreen.routeName);
                            });
                          }).catchError((onError) {
                            DialogUtils.showMessage(context, onError.toString(),
                                postActionName: "OK", postAction: () {
                              Navigator.pop(context);
                            });
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        fixedSize: Size(width * 0.5, height * 0.07),
                      ),
                      child: const Text('Save Change'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    titleController?.dispose();
    descController?.dispose();
  }

  void saveChange() {
    if (formKey.currentState!.validate()) {}
  }

  void showTaskDatePicker(Task task) {
    showDatePicker(
      context: context,
      initialDate: task.dateTime!,
      firstDate: task.dateTime!,
      lastDate: DateTime.now().add(const Duration(days: 365)),
    ).then((value) {
      if (value != null) {
        task.dateTime = value;
      }
    });
  }
}
