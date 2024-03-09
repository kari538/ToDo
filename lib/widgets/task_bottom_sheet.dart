import 'package:todoey/widgets/my_raised_button.dart';
import 'package:todoey/models/task.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todoey/models/task_data.dart';
import 'package:todoey/theme.dart';
import 'package:provider/provider.dart';

void showTaskBottomSheet(BuildContext context, {required bool adding, int? index, String? taskText})
{
  assert (adding == true || index != null, throw ('Unless adding is true, an index must be provided.'));
  showModalBottomSheet(
    context: context,
//            builder: (context) => TaskBottomSheet(addTask: addTask),
//            builder: (context) => TaskBottomSheet(addTask: myTaskListClassObject.addTask, taskListClassObject: myTaskListClassObject),  //Doesn't notify listeners
//            builder: (context) => TaskBottomSheet(addTask: (context).read<TaskListClass>().addTask),  //crash
    builder: adding == true
        ? (context) => TaskBottomSheet(addTask: (context).watch<TaskData>().addTask)  //Suggested by error log. Works!
        : (context) => TaskBottomSheet(editTaskText: (context).watch<TaskData>().editTaskText, index: index!, taskText: taskText!),
    isScrollControlled: true,
  );
}


/// Either addTask or editTaskText must be provided.
/// If editTaskText is provided, an index of the task must also be provided.
class TaskBottomSheet extends StatefulWidget {
  const TaskBottomSheet({
    this.addTask,
    this.editTaskText,
    this.index,
    this.taskText,
//    this.taskListClassObject,
  });

  final Function? addTask;
  final Function? editTaskText;
  final int? index;
  final String? taskText;

  @override
  State<TaskBottomSheet> createState() => _TaskBottomSheetState();
}

class _TaskBottomSheetState extends State<TaskBottomSheet> {
//  final TaskData taskListClassObject;
  final TextEditingController controller = TextEditingController();
  bool? adding;
  String? inputText;

  @override
  void initState() {
    super.initState();
    assert (widget.addTask != null || widget.editTaskText != null, throw ('Either addTask or editText '
        'must be provided'));
    assert (widget.addTask != null || (widget.editTaskText != null && widget.index != null && widget.taskText != null),
    throw ('If editTaskText is provided, an index and a text of the task '
        'must also be provided.'));
    adding = widget.addTask != null;
    controller.text = widget.taskText ?? '';
    inputText = widget.taskText;
  }

  void execute(String? _inputText){
    adding == true ? widget.addTask!(Task(taskText: _inputText!)) : widget.editTaskText!(index: widget.index, newTaskText: _inputText);
    // adding ? addTask(inputText) : editTaskText(index: index, newTaskText: inputText);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    print('Building TaskBottomSheet');
    controller.text = inputText ?? '';
    // Move cursor to the end of the written text, rather than the start:
    controller.selection = TextSelection.fromPosition(TextPosition(offset: controller.text.length));

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Padding(
          padding: EdgeInsets.only(left: 30, top: 30, right: 30, bottom: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(adding == true ? 'Add Task' : 'Edit Task', style: TextStyle(color: MyThemeClass.kColorOfEverything, fontSize: 30), textAlign: TextAlign.center),
              TextField(
//            style: TextStyle(color: Colors.pinkAccent),
                onChanged: (value) {
                  inputText = value;
                  // controller.text = value;
                  // controller.
                  // inputText = value;
                },
                onSubmitted: execute,
                // onSubmitted: (inputText){
                //   adding ? addTask(inputText) : editTaskText(index: index, newTaskText: inputText);
                //   Navigator.pop(context);
                // },
                controller: controller,
                autofocus: true,
                mouseCursor: MouseCursor.uncontrolled,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              adding == true ?                   MyRaisedButton(
                textColor: Colors.white,
                child: Text('Add', style: TextStyle(inherit: true)),
                onPressed: () {
                  // execute(controller.text);
                  execute(inputText);
//                   adding ? addTask(inputText) : editTaskText(index, inputText);
// //                  print('Length of list in new instance of TaskListClass is ${TaskListClass().tasks.length}');  //New instance, default values
// //                  print('Length of list in myTaskListClassObject is ${taskListClassObject.tasks.length}');  //list is updated but not listeners
// //                  print('Length of list in Provider.of is ${Provider.of<TaskListClass>(context).tasks.length}');  //crash
// //                  print('Length of task list with (context).read is ${(context).read<TaskListClass>().tasks.length}');  //works
//                   Navigator.pop(context);
                },
              )
                  : Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MyRaisedButton(
                    textColor: Colors.white,
                    child: Text('Cancel', style: TextStyle(inherit: true)),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  MyRaisedButton(
                    textColor: Colors.white,
                    child: Text('Ok', style: TextStyle(inherit: true)),
                    onPressed: () {
                      // adding ? addTask(inputText) : editTaskText;
                      widget.editTaskText!(index: widget.index, newTaskText: controller.text);
                      // editTaskText(index: index, newTaskText: inputText);
//                  print('Length of list in new instance of TaskListClass is ${TaskListClass().tasks.length}');  //New instance, default values
//                  print('Length of list in myTaskListClassObject is ${taskListClassObject.tasks.length}');  //list is updated but not listeners
//                  print('Length of list in Provider.of is ${Provider.of<TaskListClass>(context).tasks.length}');  //crash
//                  print('Length of task list with (context).read is ${(context).read<TaskListClass>().tasks.length}');  //works
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ],
          ),
//      decoration: BoxDecoration(
//        color: Colors.transparent,
//        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
      ),
    );
  }
}
