import 'package:collection/collection.dart';
import 'list_bottom_sheet.dart';
import 'package:todoey/screens/tasks_screen.dart';
import 'package:todoey/theme.dart';
import 'task_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:todoey/widgets/task_tile.dart';
import 'package:provider/provider.dart';
import 'package:todoey/models/task_data.dart';

//class TasksList extends StatefulWidget {
class TasksList extends StatelessWidget {
  // const TasksList(this.currentList);
  // final String currentList;
//  const TasksList();
//
//  @override
//  _TasksListState createState() => _TasksListState();
//}
//
// class _TasksListState extends State<TasksList> {
//   @override
//   String toString({DiagnosticLevel minLevel}){
//     return 'Task list: ${Provider.of<TaskData>(context).tasks}';
//   }

  @override
  Widget build(BuildContext context) {
    print('Building TasksList');
    TaskData myTaskData = Provider.of<TaskData>(context);
    bool noTasksYet = myTaskData.tasks.isEmpty;
    // print('Building TasksList with tasks ${Provider.of<TaskData>(context).tasks}');

    return Consumer<TaskData>(builder: (context, _myTaskData, child) {
      // print('myTaskData.tasks is ${_myTaskData.tasks}');
      return Padding(
        padding: EdgeInsets.fromLTRB(32, 0, 0, 0),
        // padding: EdgeInsets.fromLTRB(30, 0, 0, 80),
        child: noTasksYet
            ? Column(
                children: [
                  TaskListView(_myTaskData),
                  Expanded(
                    child: Padding(
                      // color: Colors.blue,
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 80),
                      child: Center(
                        child: Text('<no tasks>', style: TextStyle(color: Colors.black38)),
                      ),
                    ),
                  )
                ],
              )
            : TaskListView(_myTaskData),
      );
    });
  }
}

class TaskListView extends StatelessWidget {
  const TaskListView(this._myTaskData);

  final TaskData _myTaskData;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            // padding: const EdgeInsets.only(right: 20),
            padding: const EdgeInsets.fromLTRB(0, 40, 0, 15),
            // padding: const EdgeInsets.only(right: 30),
            child: Text(
              '$currentList:',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 26,
                // color: MyThemeClass.kColorOfEverything.withOpacity(0.8),
                // color: MyThemeClass.kColorOfEverything.withOpacity(1),
                color: MyThemeClass.kColorOfEverything,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
                decorationThickness: 2,
                // decorationColor: MyThemeClass.kColorOfEverything.withOpacity(1), // The underline
                decorationColor: MyThemeClass.kColorOfEverything, // The underline
              ),
            ),
          );
        } else {
          // print('myTaskData.tasks.length != 0');
          final int taskIndex = index - 1;
          final currentTask = _myTaskData.tasks[taskIndex];
          final bool isFirst = taskIndex == 0;
          final bool isLast = taskIndex == _myTaskData.taskCount - 1;
          return Padding(
            padding: isLast ? const EdgeInsets.only(bottom: 80) : const EdgeInsets.only(right: 0),
            child: TaskTile(
              taskText: currentTask.taskText,
              isChecked: currentTask.isDone,
              beingEdited: currentTask.beingEdited,
              first: isFirst,
              last: isLast,
              onTapCheckbox: () {
                _myTaskData.checkTask(currentTask);
//              setState(() {
//                Provider.of<TaskData>(context).tasks[index].toggleDone(); //crash
//                (context).watch().tasks[index].toggleDone();  //crash
//                Provider.of<TaskData>(context, listen: false).tasks[index].toggleDone(); //Suggested by provider pkg. Works!
//                hi.tasks[index].toggleDone(); //I'm supposed to be able to remove setState and make stateless but then isChecked does not listen
//              });
              },
              onLongPress: () {
                _myTaskData.editTask(currentTask);
                // myTaskData.deleteTask(context, currentTask);
              },
              onTapEditText: () {
                showTaskBottomSheet(context, adding: false, index: taskIndex, taskText: currentTask.taskText);
              },
              onTapDelete: () {
                _myTaskData.deleteTask(context, currentTask);
              },
              onTapArrowDown: () {
                _myTaskData.moveTaskDown(currentTask, taskIndex);
              },
              onLongPressArrowDown: () {
                _myTaskData.moveTaskToEnd(currentTask, taskIndex);
              },
              onTapArrowUp: () {
                _myTaskData.moveTaskUp(currentTask, taskIndex);
              },
              onLongPressArrowUp: () {
                _myTaskData.moveTaskToTop(currentTask, taskIndex);
              },
            ),
          );
        }
      },
//      itemCount: Provider.of<TaskData>(context).taskCount,
      itemCount: _myTaskData.taskCount + 1,
    );
  }
}
