// ignore_for_file: avoid_unnecessary_containers

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todo_app/MyDateUtils.dart';
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
  DateTime selectedDate = DateTime.now();
  DateTime focusedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthProvider>(context);
    return Container(
      child: Column(
        children: [
          /*CalendarTimeline(
            initialDate: selectedDate,
            firstDate: DateTime.now().subtract(Duration(days: 365)),
            lastDate: DateTime.now().add(Duration(days: 365)),
            onDateSelected: (date) {
              setState(() {
                selectedDate = date;
              });
            },
            leftMargin: 20,
            monthColor: Colors.blueGrey,
            dayColor: Colors.teal[200],
            activeDayColor: Colors.white,
            activeBackgroundDayColor: Colors.redAccent[100],
            dotsColor: const Color(0xFF333A47),
            locale: 'en_ISO',
          ),*/
          TableCalendar(
            focusedDay: focusedDate,
            firstDay: DateTime.now().subtract(Duration(days: 365)),
            lastDay: DateTime.now().add(Duration(days: 365 * 2)),
            calendarFormat: CalendarFormat.week,
            selectedDayPredicate: (day) {
              return isSameDay(selectedDate, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                this.selectedDate = selectedDay;
                focusedDate = focusedDay; // update `_focusedDay` here as well
              });
            },
            onPageChanged: (focusedDay) {
              focusedDate = focusedDay;
            },
          ),
          Expanded(
              child: StreamBuilder<QuerySnapshot<Task>>(
            stream: MyDataBase.getTasksRealTimeUpdates(
                authProvider.currentUser?.id ?? "",
                MyDateUtils.dayOnly(selectedDate).millisecondsSinceEpoch),
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
