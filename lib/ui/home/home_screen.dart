// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:todo_app/ui/home/add_task_bottom_sheet.dart';
import 'package:todo_app/ui/home/settings/settings_list_tab.dart';
import 'package:todo_app/ui/home/todo_list/todo_list_tab.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = 'home';

  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme
            .of(context)
            .primaryColor,
        title: Text('ToDo App'),
      ),
      body: tabs[selectedIndex],
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 8,
        child: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: (index) {
            selectedIndex = index;
            setState(() {

            });
          },
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.list), label: ''),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings, size: 32), label: ''),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: StadiumBorder(
            side: BorderSide(
              color: Colors.white,
              width: 4,
            )
        ),
        onPressed: () {
          showAddTaskSheet();
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  void showAddTaskSheet() {
    showModalBottomSheet(context: context, builder: (context) {
      return AddTaskBottomSheet();
    });
  }

  List<Widget> tabs = [
    TodoListTap(),
    SettingsListTap(),
  ];
}

