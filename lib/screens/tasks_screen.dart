import 'backup_choice_screen.dart';
import 'package:todoey/main.dart';
import 'package:todoey/widgets/list_bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todoey/theme.dart';
import 'package:todoey/widgets/tasks_list.dart';
import 'package:todoey/widgets/task_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:todoey/models/task_data.dart';

enum ListOption {
  makeNewList,
  deleteCheckedTasks,
  deleteAllTasks,
  deleteList,
  renameList,
  checkAll,
  unCheckAll,
  checkedToTop,
  checkedToBottom,
}

//class TasksScreen extends StatefulWidget {
class TasksScreen extends StatelessWidget {
  const TasksScreen(this.myTaskData, this.myThemeClass);

//  @override
//  _TasksScreenState createState() => _TasksScreenState();
//}
//
//class _TasksScreenState extends State<TasksScreen> {
//  List<TaskTile> tasks = [
//    TaskTile(taskText: 'Buy milk'),
//    TaskTile(taskText: 'Buy eggs'),
//  ];
//  List<Task> tasks = [
//    Task(taskText: 'Buy milk'),
//    Task(taskText: 'Buy eggs'),
//  ];

//  void addTask(String newTask){
//    print('Running addTask with newTask $newTask');
//    setState(() {
//      tasks.add(Task(taskText: newTask));
//    });
//    print('tasks is $tasks');
//    print('The last task in tasks is ${tasks[tasks.length-1].taskText}');
//  }
//TaskData myTaskListClassObject = TaskData();

// String currentList = 'List 1';
// Map<String, TasksList> mapOfToDoLists = {
//   'List 1': TasksList('List 1'),
// };

  final TaskData myTaskData;
  final MyThemeClass myThemeClass;

  @override
  Widget build(BuildContext context) {
    print('Building TasksScreen');
    //I dunno why this doesn't seem to be needed...
    //And now it just seems to be needed again! *facepalm* :
    TaskData _myTaskData = Provider.of<TaskData>(context);

    // todo: Perhaps remove the default ToDo list if it's empty, when retrieving backup... Maybe check for a file and if it's not there, default list can go...? Coz it means no activity yet...
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(top: 13, left: 30, right: 13),
              // padding: EdgeInsets.only(top: 60, left: 30, right: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // GestureDetector(
                  //   child:
                  // Settings cogwheel:
                  Align(
                    child: PopupMenuButton(
                      itemBuilder: (context) {
                        List<PopupMenuItem> _themesAndBackup = [
                          PopupMenuItem(
                              child: Text(
                            'Change theme:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ))
                        ];
                        for (String color in MyThemeClass.themeColors.keys) {
                          // for (String list in myTaskData.toDoLists){
                          // for (String list in Provider.of<TaskData>(context, listen: false).toDoLists){
                          double luminance = MyThemeClass.themeColors[color]!.computeLuminance();
                          // print('luminance of $color is $luminance');
                          _themesAndBackup.add(
                            PopupMenuItem(
                                child: Container(
                                  color: MyThemeClass.themeColors[color],
                                  child: Center(
                                      child: Text(color,
                                          style: TextStyle(color: luminance < 0.1 ? Colors.white : Colors.black /*, fontWeight: FontWeight.bold*/))),
                                  height: 50,
                                  // height: double.infinity,
                                ),
                                value: color),
                          );
                        }

                        _themesAndBackup.add(
                          PopupMenuItem(
                            child: Text(
                              'Back up',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            value: 'back_up',
                          ),
                        );

                        return _themesAndBackup;
                        // return [PopupMenuItem(child: Text('...'))];
                      },
                      onSelected: (value) {
                      // onSelected: (colorString) {
                        String colorString = '';
                        if (value is String) colorString = value;
                        if (colorString == 'back_up') {
                          Navigator.push(context, MaterialPageRoute(builder: (context) {
                            return BackupChoiceScreen(_myTaskData);
                          }));
                        } else
                          myThemeClass.changeTheme(colorString);
                      },
                      padding: EdgeInsets.all(0),
                      icon: Icon(Icons.settings, color: Colors.white),
                    ),
                    alignment: Alignment.centerRight,
                  ),
                  // List button:
                  CircleAvatar(
                    child: PopupMenuButton(
                      itemBuilder: (context) {
                        // Start with a non-clickeable text that says "All lists:"
                        List<PopupMenuItem> lists = [
                          PopupMenuItem(
                              child: Text(
                            'All lists:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ))
                        ];
                        // Then add all the user's lists:
                        for (String list in myTaskData.lists) {
                          // for (String list in myTaskData.toDoLists){
                          // for (String list in Provider.of<TaskData>(context, listen: false).toDoLists){
                          lists.add(PopupMenuItem(child: Text(list), value: list));
                        }
                        // Finally the "Make new list" option:
                        lists.add(
                          PopupMenuItem(
                            child: Text('Make new list', style: TextStyle(fontStyle: FontStyle.italic)),
                            value: ListOption.makeNewList,
                          ),
                        );

                        return lists;
                      },
                      onSelected: (value) {
                        print('Selected $value');
                        if (value is String) {
                          myTaskData.changeCurrentList(value);
                        } else if (value == ListOption.makeNewList) {
                          showListBottomSheet(context, adding: true);
                        }
                      },
                      icon: Icon(Icons.list, size: 30
                        /*, color: kColorOfEverything*/,
                      // TODO: Take the below back into the theme again...:
                      color: MyThemeClass.kColorOfEverything,),
                    ),
                    // icon: Icon(Icons.list, size: 30, color: Colors.amber)),
                    // child: Icon(Icons.list, size: 50, color: Colors.white),
                    // child: Icon(Icons.list, size: 30, color: kColorOfEverything),
                    radius: 30,
                    backgroundColor: Colors.white,
                  ),
//                   onTap: () {
// //                    print('Setting state');
// //                    setState(() {});
//                   },
//                 ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ToDo', style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: Colors.white)),
//                    Text('${tasks.length} Tasks', style: TextStyle(fontSize: 20, color: Colors.white)),
                      Text(
//                      '${context.read<TaskListClass>().tasks.length} Tasks',
//                      '${Provider.of<TaskData>(context).tasks.length} Tasks',
//                       '${myTaskData.taskCount} Tasks',
                        '${_myTaskData.taskCount} Tasks',
                        // '${Provider.of<TaskData>(context).taskCount} Tasks',
                        // 'x tasks',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ),
            Expanded(
              child: Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(child: TasksList()),
                    PopupMenuButton(
                      // iconSize: 5,
                      itemBuilder: (context) {
                        return [
                          PopupMenuItem(child: Text('Check all'), value: ListOption.checkAll),
                          PopupMenuItem(child: Text('Uncheck all'), value: ListOption.unCheckAll),
                          PopupMenuItem(child: Text('Checked to top'), value: ListOption.checkedToTop),
                          PopupMenuItem(child: Text('Checked to bottom'), value: ListOption.checkedToBottom),
                          PopupMenuItem(child: Text('Delete all tasks'), value: ListOption.deleteAllTasks),
                          PopupMenuItem(child: Text('Delete all checked'), value: ListOption.deleteCheckedTasks),
                          PopupMenuItem(child: Text('Rename list'), value: ListOption.renameList),
                          PopupMenuItem(child: Text('Delete list'), value: ListOption.deleteList),
                        ];
                      },
                      onSelected: (value) {
                        switch (value) {
                          case ListOption.checkAll:
                            {
                              print('Selected $value');
                              _myTaskData.checkAll();
                            }
                            break;
                          case ListOption.unCheckAll:
                            {
                              print('Selected $value');
                              _myTaskData.unCheckAll();
                            }
                            break;
                          case ListOption.checkedToTop:
                            {
                              print('Selected $value');
                              _myTaskData.checkedToTop();
                            }
                            break;
                          case ListOption.checkedToBottom:
                            {
                              print('Selected $value');
                              _myTaskData.checkedToBottom();
                            }
                            break;
                          case ListOption.deleteAllTasks:
                            {
                              print('Selected $value');
                              _myTaskData.deleteAllTasks(context);
                            }
                            break;
                          case ListOption.deleteCheckedTasks:
                            {
                              print('Selected $value');
                              _myTaskData.deleteCheckedTasks(context);
                            }
                            break;
                          case ListOption.deleteList:
                            {
                              print('Selected $value');
                              _myTaskData.deleteList(context);
                            }
                            break;
                          case ListOption.renameList:
                            {
                              print('Selected $value');
                              // myTaskData.editListName(context, 'xxxy list');
                              showListBottomSheet(context, listName: currentList);
                            }
                        }
                      },
                      padding: EdgeInsets.all(0),
                      // padding: EdgeInsets.all(0),
                      // color: Colors.red,
                      // padding: EdgeInsets.fromLTRB(0, 8, 8, 8),
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                ),
              ),
            ),
            // SizedBox(height: 30),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showTaskBottomSheet(context, adding: true);
        },
        child: Icon(Icons.add, size: 35),
        // backgroundColor: kColorOfEverything,
      ),
      // backgroundColor: kColorOfEverything,
    );
  }
}
