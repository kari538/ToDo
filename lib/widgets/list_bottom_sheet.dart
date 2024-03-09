import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todoey/models/task_data.dart';
import 'package:todoey/theme.dart';
import 'package:provider/provider.dart';

void showListBottomSheet(
  BuildContext parentContext, {
  bool adding,
  String listName,
  /*int index, */
}) {
  assert(
      adding == true || listName != null,
      throw ('Unless '
          'adding is true, a new list name must be provided.'));
  TaskData myTaskData = Provider.of<TaskData>(parentContext, listen: false);
  // TaskData myTaskData = (context).watch<TaskData>();
  showModalBottomSheet(
    context: parentContext,
//            builder: (context) => ListBottomSheet(addList: addList),
//            builder: (context) => ListBottomSheet(addList: myTaskListClassObject.addTask, taskListClassObject: myTaskListClassObject),  //Doesn't notify listeners
//            builder: (context) => ListBottomSheet(addTask: (context).read<TaskListClass>().addTask),  //crash
    builder: adding == true
        ? (context) => ListBottomSheet(parentContext: parentContext, addList: myTaskData.addList, listName: listName)
        : (context) => ListBottomSheet(parentContext: parentContext, editListName: myTaskData.editListName, /*index: index,*/ listName: listName),
    //Suggested by error log. Works!:
    // : (context) => ListBottomSheet(editListText: (context).watch<TaskData>().editListName(context, newName), index: index, taskText: taskText),
    isScrollControlled: true,
  );
}

/// Either addTask or editTaskText must be provided.
/// If editTaskText is provided, an index of the task must also be provided.
class ListBottomSheet extends StatelessWidget {
  const ListBottomSheet({
    @required this.parentContext,
    this.addList,
    this.editListName,
    // this.index,
    this.listName,
//    this.taskListClassObject,
  });

  final BuildContext parentContext;
  final Function addList;
  final Function editListName;

  // final int index;
  final String listName;

//  final TaskData taskListClassObject;

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    FocusNode focusNode = FocusNode();
    focusNode.requestFocus();
    controller.text = listName ?? '';
    // String inputText;
    String inputText = listName;
    assert(addList != null || editListName != null, throw ('Either addList or editListName must be provided'));
    // assert (addList != null || (editListText != null && index != null && taskText != null),
    // throw ('If editListText is provided, an index and a text of the task must also be provided.'));
    bool adding = addList != null;

    void executeAdd(String _inputText) async {
      print('executeAdd()');
      Navigator.pop(context);
      // bool successful = await addList(context, _inputText);
      bool successful = await addList(parentContext, _inputText);
      print(successful);
      // Lalle  0738082973
      // Navigator.pop(context);
      if (!successful) {
        showListBottomSheet(parentContext, adding: true, listName: _inputText);
      }
    }

    void executeEdit(String _inputText) async {
      await editListName(context, _inputText);
      Navigator.pop(context);
    }

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
              // Text('Name New List:', style: TextStyle(color: kColorOfEverything, fontSize: 30), textAlign: TextAlign.center),
              Text(adding ? 'Name New List' : 'Edit List Name',
                  style: TextStyle(color: MyThemeClass.kColorOfEverything, fontSize: 30), textAlign: TextAlign.center),
              TextField(
//            style: TextStyle(color: Colors.pinkAccent),
                onChanged: (value) {
                  inputText = value;
                },
                onSubmitted: adding ? executeAdd : executeEdit,
                // onSubmitted: (inputText) async {
                // bool successful = await addList(context, inputText);
                // print(successful);
                // if (successful) {
                //   Navigator.pop(context);
                // } else {
                //   print('Requesting focus');
                //   focusNode.requestFocus();
                // }
                // },
                controller: controller,
                autofocus: true,
                // focusNode: focusNode,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              adding
                  ? RaisedButton(
                      textColor: Colors.white,
                      child: Text('Add', style: TextStyle(inherit: true)),
                      onPressed: () async {
                        executeAdd(inputText);
                      }
                      )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        RaisedButton(
                          textColor: Colors.white,
                          child: Text('Cancel', style: TextStyle(inherit: true)),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        RaisedButton(
                          textColor: Colors.white,
                          child: Text('Ok', style: TextStyle(inherit: true)),
                          onPressed: () async {
                            executeEdit(inputText);
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
