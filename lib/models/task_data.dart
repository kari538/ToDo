import 'package:rflutter_alert/rflutter_alert.dart';
// import 'package:todoey/theme.dart';

//import 'package:flutter/material.dart'; //The material package contains the foundation package!
//import 'dart:typed_data';
import 'dart:convert';
import 'package:todoey/todoey_storage.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';  //The cupertino package contains the foundation package!
import 'package:todoey/models/task.dart';
import 'package:collection/collection.dart';

const String defaultList = 'To do';
// Initial value:
String currentList = 'To do';

class TaskData extends ChangeNotifier {
  // Initial value:
  Map<String, List<Task>> _listsAndTasks = {
    currentList: [],
  };

  File? listFile;
  Map<String, File> taskFiles = {};

  Future<void> getSavedTasks() async {
    print('Running getSavedTasks');
    Stream<List<int>>? listStream;
    Stream<List<int>>? taskStream;
    Future? doneGetTasks;

    // function:
    void retrieveTasks(String _list) {
      print('Running retrieveTasks() for list $_list. taskFiles[_list] is ${taskFiles[_list]}');
      try {
        taskStream = taskFiles[_list]!.openRead();
      } on Exception catch (e) {
        print('Error retrieving tasks: \n' + e.toString());
      }
      if (taskStream != null) {
        taskStream!.transform(utf8.decoder).transform(LineSplitter()).listen((String line) {
          Map<String, dynamic> decodedTaskLine = {};
          try {
            decodedTaskLine = jsonDecode(line);
            // print('decodedTaskLine is $decodedTaskLine');
            // print('line is $line');

            _listsAndTasks[_list]!.add(taskFromJson(decodedTaskLine));
            // _tasks.add(fromJson(decodedLine));
          } catch (e) {
            print('Error in taskStream!.transform: \n$e');
          }
          notifyListeners();
          // print('_listsAndTasks[$_list] is ${_listsAndTasks[_list]}');
        }).onDone(() {
          print('_listsAndTasks after taskStream in retrieveTasks() is $_listsAndTasks');
        });
      }
    }

    listFile = File('${await appPath}/lists.txt');

    if (await listFile?.exists() == true) {
      String syncAppPath = await appPath;
      // print("List file exists: $listFile");
      // If a list file exists, I don't need my default initial list:
      _listsAndTasks = {};

      try {
        listStream = listFile!.openRead();
      } on Exception catch (e) {
        print('sddsfgsdf '+ e.toString());
      }
      int i = 0;

      if (listStream != null) {
        doneGetTasks = listStream.transform(utf8.decoder).transform(LineSplitter()).listen((String line) {
          Map<String, dynamic> decodedListLine;
          try {
            decodedListLine = jsonDecode(line);
          } on Exception catch (e) {
            // print('I think this is where the error is\nvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv');
            print(e);
            // print('^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^');
            print('line is $line');

            String syncAppPathSlash = syncAppPath + '/';
            // List<FileSystemEntity> _folders;
            Directory myDir = Directory(syncAppPathSlash);
            // _folders = myDir.listSync(recursive: true, followLinks: false);
            // print('_folders is $_folders');

            String fileName = formatFileName(line);
            // decodedListLine = {"list": '$line', "path": syncAppPath};  //In case of an old list file without path
            // decodedListLine = {"list": '$line', "path": File('$syncAppPath/tasks.txt').path};  //In case of an old list file without path
            decodedListLine = {"list": '$line', "path": File('$syncAppPath/$fileName.txt').path}; //In case of an old list file without path
            // decodedListLine = {"list": '$line', "path": File('$syncAppPath/Tasks.txt').path};  //In case of an old list file without path
            // decodedListLine = {"list": '$line', "path": ''};  //In case of an old list file without path

          }
          // print('List line is $line');
          // print('decodedListLine is $decodedListLine');
          Map<String, File>? fromFile;
          String? listName;
          try {
            fromFile = listFromJson(decodedListLine);
            listName = fromFile.keys.first;
            _listsAndTasks.addAll({listName: []});
            taskFiles.addAll(fromFile);
          } on Exception catch (e) {
            print(e);
          }
          // _listsAndTasks.addAll({line: []});
          // print('_listsAndTasks is $_listsAndTasks');
          // print('taskFiles is $taskFiles');
          if (i == 0) currentList = listName ?? '';
          // _tasks.add(fromJson(decodedListLine));
          i++;
        }).asFuture() /*.onDone(() async {
          print('listStream is over\n*******************************************************');
          // notifyListeners();

          for (String list in _listsAndTasks.keys) {
            // print('taskFiles[list] is ${taskFiles[list]}');
            if (!(await taskFiles[list].exists())) {
              print('${taskFiles[list]} does not exist');
              String listFileName = formatFileName(list);

              // print('list is $list and listFileName is $listFileName');

              taskFiles[list] = File('${await appPath}/$listFileName.txt');
              // taskFiles.addAll({'$list': File('${await appPath}/$listFileName.txt')});
            } else {
              // print('${taskFiles[list]} DOES exist');
            }
            // taskFiles = File('${await appPath}/tasks.txt');
            // If there is already data in this file, which there probably is:
            if (await taskFiles[list].exists()) {
              print("The task file ${taskFiles[list]} exists");
              retrieveTasks(list);
            } else {
              print('taskFile ${taskFiles[list]} doesn\'t exist');
            }
          }
          return true;
        })*/
            ;
      }
    } else {
      // print('listFile doesn\'t exist. Checking for old task file...');

      String singleList = currentList;
      taskFiles.addAll({'$singleList': File('${await appPath}/tasks.txt')});
      // taskFiles = File('${await appPath}/tasks.txt');

      // If there is already data in this file:
      if (await taskFiles[singleList]?.exists() == true) {
        // print("The old task file exists: ${taskFiles[singleList]}");
        retrieveTasks(singleList);
        // try {
        //   taskStream = taskFiles[singleList].openRead();
        // } on Exception catch (e) {
        //   print(e.toString());
        // }
        // taskStream.transform(utf8.decoder).transform(LineSplitter()).listen((String line) {
        //   Map<String, dynamic> decodedTaskLine = jsonDecode(line);
        //   print('decodedTaskLine is $decodedTaskLine');
        //   _listsAndTasks[singleList].add(taskFromJson(decodedTaskLine));
        //   // _tasks.add(fromJson(decodedListLine));
        //   notifyListeners();
        //   print('_listsAndTasks[$singleList] is ${_listsAndTasks[singleList]}');
        // });

        // Delete the old task file and create a new one with the right format: ...Scratch that! Just rename it.
        // taskFiles[singleList].delete();
        String listFileName = formatFileName(singleList);
        // File correctFile = File('${await appPath}/$listFileName.txt');
        // Overwrite the old file in taskFiles with new file:
        try {
          taskFiles[singleList]!.rename('${await appPath}/$listFileName.txt');
        } catch (e) {
          print('Error renaming singleList: \n$e');
        }
        // taskFiles[singleList] = correctFile;
        // Write data to new file:
        currentList = singleList; // This should already be the case, but just to be sure...
        // writeTasksToFile();
      } else {
        // print('Old task file doesn\'t exist: ${taskFiles[singleList]}');
      }
    }

    // print('listStream is over\n*******************************************************');
    // notifyListeners();

    if (doneGetTasks != null) {
      await doneGetTasks;
      for (String list in _listsAndTasks.keys) {
        // print('taskFiles[list] is ${taskFiles[list]}');
        if (!(await taskFiles[list]?.exists() == true)) {
          // print('${taskFiles[list]} does not exist');
          String listFileName = formatFileName(list);

          // print('list is $list and listFileName is $listFileName');

          taskFiles[list] = File('${await appPath}/$listFileName.txt');
          // taskFiles.addAll({'$list': File('${await appPath}/$listFileName.txt')});
        } else {
          // print('${taskFiles[list]} DOES exist');
        }
        // taskFiles = File('${await appPath}/tasks.txt');
        // If there is already data in this file, which there probably is:
        if (await taskFiles[list]?.exists() == true) {
          // print("The task file ${taskFiles[list]} exists");
          retrieveTasks(list);
        } else {
          // print('taskFile ${taskFiles[list]} doesn\'t exist');
        }
      }
    }
    // return true;

    print('getSavedTasks() is ready');
    return;
  }

  //
  // void fakeOldAppVersion(Future doneGetTasks) async {
  //   //Faking old app version:
  //   await doneGetTasks;
  //   File _oldFile = File('${await appPath}/tasks.txt');
  //   taskFiles = {
  //     currentList: _oldFile
  //   };
  //   // if (await _oldFile.exists()) await _oldFile.delete();
  //   writeTasksToFile();
  //   if (await listFile.exists()) listFile.delete();
  //   print('Faked old app version by deleting list file and writing current'
  //   ' tasks to "tasks.txt"');
  // }

  void changeCurrentList(String newList) {
    currentList = newList;
    print('currentList is now $newList');
    notifyListeners();
  }

  /// Returns 'true' if the add was successful and 'false' if it wasn't.
  Future<bool> addList(BuildContext context, String newList) async {
    print('Running addList with newList $newList');

    bool taken = await checkIfListNameTaken(newList);

    if (taken) {
      await Alert(
          context: context,
          title: "This name is taken",
          desc: "You already have a list with this name. Please choose a unique name for your list!",
          buttons: [
            DialogButton(
                child: Text('Ok'),
                onPressed: () {
                  print('Pressed Ok');
                  Navigator.pop(context);
                }),
          ]).show();
    } else {
      _listsAndTasks.addAll({newList: []});
      // print('_listsAndTasks[$currentList] is ${_listsAndTasks[currentList]}');
      currentList = newList;
      notifyListeners();

      String fileName = formatFileName(newList);
      taskFiles.addAll({
        newList: File('${await appPath}/$fileName.txt'),
      });

      print('Writing lists ${_listsAndTasks.keys} to list file');
      writeListsToFile();
    }
    bool successful = !taken;
    return successful;
  }

  void deleteList(BuildContext context, [bool fromBackup = false]) async {
    bool? confirmed;

    if (fromBackup) {
      confirmed = true;
    } else {
      confirmed = await Alert(context: context, title: "Delete", desc: "Do you want to delete this list?", buttons: [
        DialogButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.pop(context, false);
            }),
        DialogButton(
            child: Text('Delete'),
            onPressed: () {
              Navigator.pop(context, true);
            }),
      ]).show();
    }

    if (confirmed == true) {
      print('Deleting list "$currentList"');

      try {
        _listsAndTasks.remove(currentList);

        if (await taskFiles[currentList]?.exists() == true) {
          await taskFiles[currentList]!.delete();
        }
        taskFiles.remove(currentList);

        if (_listsAndTasks.isEmpty && !fromBackup) {
          _listsAndTasks = {
            defaultList: [],
          };
          String listFileName = formatFileName(defaultList);
          taskFiles = {
            defaultList: File('${await appPath}/$listFileName.txt'),
          }; // If I don't do this, writeListsToFile() won't work
        }

        currentList = _listsAndTasks.keys.first;
        notifyListeners();
        // return 'done';
        writeListsToFile();
      } catch (e) {
        print(e);
      }
    }
  }

  String formatFileName(String listName) {
    // String _fileName = 'multilist_' + listName.replaceAll(' ', '_');
    // String _fileName = 'xxx_' + listName.replaceAll(' ', '_');
    String _fileName = 'multiList_' + listName.replaceAll(' ', '_');
    return _fileName;
  }

  Future<bool> checkIfListNameTaken(String newName) async {
    bool _taken = _listsAndTasks.containsKey(newName);

    // If the lists don't have the same name, I should still check if they
    // turn into the same file name...:
    if (!_taken) {
      List<String> filePaths = [];

      for (File taskFile in taskFiles.values) filePaths.add(taskFile.path);

      String newFileName = formatFileName(newName);
      String newFilePath = '${await appPath}/$newFileName.txt';
      _taken = filePaths.contains(newFilePath);
    }
    return _taken;
  }

  void editListName(BuildContext context, String newName) async {
    print('Renaming "$currentList" to "$newName", unless it\'s taken');

    String oldName = currentList;
    bool taken = await checkIfListNameTaken(newName);

    if (taken) {
      await Alert(
          context: context,
          title: "This name is taken",
          desc: "You already have a list with this name. Please choose a unique name for your list!",
          buttons: [
            DialogButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.pop(context);
                }),
          ]).show();
    } else {
      _listsAndTasks = _listsAndTasks.map((key, value) {
        if (key == oldName) {
          // print('key == $oldName');
          return MapEntry(newName, value);
        } else {
          // print('key is not $oldName');
          return MapEntry(key, value);
        }
      });

      print('_listsAndTasks after name change is $_listsAndTasks');

      String fileName = formatFileName(newName);
      String newPath = '${await appPath}/$fileName.txt';
      try {
        File oldFile = taskFiles[oldName]!;
        // print('taskFiles is $taskFiles');
        // print('oldFile is $oldFile. Renaming it.');
        // print('oldFile is $oldFile. Deleting it.');
        if (await oldFile.exists()) {
          oldFile.rename(newPath);
          // oldFile.delete();
        }
      } catch (e) {
        print('Error changing list name: \n$e');
      }

      taskFiles = taskFiles.map((key, value) {
        if (key == oldName) {
          // print('key == currentList');
          return MapEntry(newName, File(newPath));
        } else {
          // print('key is not currentList');
          return MapEntry(key, value);
        }
      });

      print('taskFiles after file-name change is $taskFiles');
      currentList = newName;
      notifyListeners();
      writeListsToFile();
    }
  }

  void addTask(Task newTask) {
  // void addTask(String newTask) {
    print('Running addTask with newTask $newTask');
    print('_listsAndTasks is $_listsAndTasks');
    print('currentList is $currentList');
    if (_listsAndTasks[currentList] != null) {
      for (Task entry in _listsAndTasks[currentList]!) {
        entry.beingEdited = false;
      }
      _listsAndTasks[currentList]!.add(newTask);
    }
    // _listsAndTasks[currentList].add(Task(taskText: newTask));
    // print('_listsAndTasks[$currentList] is ${_listsAndTasks[currentList]}');
    notifyListeners();
    // print('Writing _listsAndTasks[$currentList] to file');
    writeTasksToFile();
  }

  void editTaskText({required int index, required String newTaskText}) {
    try {
      Task currentTask = _listsAndTasks[currentList]![index];
      currentTask.taskText = newTaskText;

      for (Task entry in _listsAndTasks[currentList]!) {
        entry.beingEdited = false;
      }

      notifyListeners();
      writeTasksToFile();
    } catch (e) {
      print('Error editing task: \n$e');
    }
  }

  void checkTask(Task currentTask) {
    currentTask.toggleDone();
    notifyListeners();
    // print('Writing _tasks[currentList] to file');
    writeTasksToFile();
  }

  void editTask(Task currentTask) {
    bool editedBefore = currentTask.beingEdited;
    if (editedBefore) {
      currentTask.beingEdited = false;
    } else {
      for (Task entry in _listsAndTasks[currentList]!) {
        entry.beingEdited = false;
      }
      currentTask.beingEdited = true;
    }
    print('Updated beingEdited for all items.');
    notifyListeners();
  }

  void deleteTask(BuildContext context, Task toDelete) async {
    try {
      bool? confirmed = await Alert(context: context, title: "Delete", desc: "Do you want to delete this task?", buttons: [
        DialogButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.pop(context, false);
            }),
        DialogButton(
            child: Text('Delete'),
            onPressed: () {
              Navigator.pop(context, true);
            }),
      ]).show();

      if (confirmed == true) {
        _listsAndTasks[currentList]!.remove(toDelete);
        notifyListeners();
        // print('Writing _tasks[currentList] to file');
        writeTasksToFile();
      } else
        print('Cancelled delete');
    } catch (e) {
      print('Error deleting task: \n$e');
    }
  }

  void checkAll() {
    try {
      for (Task task in _listsAndTasks[currentList]!) {
        task.isDone = true;
      }
      notifyListeners();
    } catch (e) {
      print('Error checking all: \n$e');
    }
  }

  void unCheckAll() {
    try {
      for (Task task in _listsAndTasks[currentList]!) {
        task.isDone = false;
      }
      notifyListeners();
    } catch (e) {
      print('Error unchecking all: \n$e');
    }
  }

  void checkedToTop() {
    try {
      List<Task> _checkedList = [];
      List<Task> _unCheckedList = [];
      for (Task task in _listsAndTasks[currentList]!) {
        if (task.isDone) _checkedList.add(task);
        else _unCheckedList.add(task);
      }
      _listsAndTasks[currentList] = _checkedList + _unCheckedList;
      notifyListeners();
    } catch (e) {
      print('Error checked to top: \n$e');
    }
  }

  void checkedToBottom() {
    try {
      List<Task> _checkedList = [];
      List<Task> _unCheckedList = [];
      for (Task task in _listsAndTasks[currentList]!) {
        if (task.isDone) _checkedList.add(task);
        else _unCheckedList.add(task);
      }
      _listsAndTasks[currentList] = _unCheckedList + _checkedList;
      notifyListeners();
    } catch (e) {
      print('Error checked to bottom: \n$e');
    }
  }

  void deleteAllTasks(BuildContext context) async {
    bool? confirmed = await Alert(context: context, title: "Delete", desc: "Do you want to delete all tasks in this list?", buttons: [
      DialogButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.pop(context, false);
          }),
      DialogButton(
          child: Text('Delete all'),
          onPressed: () {
            Navigator.pop(context, true);
          }),
    ]).show();

    if (confirmed == true) {
      _listsAndTasks[currentList] = [];
      notifyListeners();
      // print('Writing _listsAndTasks[$currentList] = ${_listsAndTasks[currentList]} to file');
      writeTasksToFile();
    } else
      print('Cancelled delete');
  }

  void deleteCheckedTasks(BuildContext context) async {
    try {
      bool? confirmed = await Alert(context: context, title: "Delete", desc: "Do you want to delete all checked tasks in this list?", buttons: [
        DialogButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.pop(context, false);
            }),
        DialogButton(
            child: Text('Delete'),
            onPressed: () {
              Navigator.pop(context, true);
            }),
      ]).show();

      if (confirmed == true) {
        // List<String> toDelete = [];

        for (int i = 0; i < _listsAndTasks[currentList]!.length; i++) {
          // print('Checking if task ${_listsAndTasks[currentList][i]} is done');
          // for (Task task in _listsAndTasks[currentList]) {
          if (_listsAndTasks[currentList]![i].isDone) {
            _listsAndTasks[currentList]!.removeAt(i);
            i--;
          }
        }

        notifyListeners();
        // print('Writing _listsAndTasks[$currentList] = ${_listsAndTasks[currentList]} to file');
        writeTasksToFile();
      } else
        print('Cancelled delete');
    } catch (e) {
      print('Error deleting task: \n$e');
    }
  }

  void moveTaskDown(Task currentTask, int index) {
    // print('_listsAndTasks[currentList] before move is ${_listsAndTasks[currentList]}');
    // print('index is $index');
    try {
      _listsAndTasks[currentList]![index] = _listsAndTasks[currentList]![index + 1];
      _listsAndTasks[currentList]![index + 1] = currentTask;
      // print('_listsAndTasks[currentList] after move is ${_listsAndTasks[currentList]}');
      notifyListeners();
      writeTasksToFile();
    } catch (e) {
      print('Error moving task down: \n$e');
    }
  }

  void moveTaskToEnd(Task currentTask, int index) {
    try {
      for (int i = index; i < _listsAndTasks[currentList]!.length - 1; i++) {
        _listsAndTasks[currentList]![i] = _listsAndTasks[currentList]![i + 1];
      }
      _listsAndTasks[currentList]![_listsAndTasks[currentList]!.length - 1] = currentTask;
      notifyListeners();
      writeTasksToFile();
    } catch (e) {
      print('Error moving task to end: \n$e');
    }
  }

  void moveTaskUp(Task currentTask, int index) {
    // if (_listsAndTasks.containsKey(currentList) && _listsAndTasks[currentList] != null){
      try {
        _listsAndTasks[currentList]![index] = _listsAndTasks[currentList]![index - 1];
        _listsAndTasks[currentList]![index - 1] = currentTask;
      } catch (e) {
        print('Error moving task up: \n$e');
      }
      notifyListeners();
      writeTasksToFile();
    // }
  }

  void moveTaskToTop(Task currentTask, int index) {
    try {
      for (int i = index; i > 0; i--) {
        _listsAndTasks[currentList]![i] = _listsAndTasks[currentList]![i - 1];
      }
      _listsAndTasks[currentList]![0] = currentTask;
    } catch (e) {
      print('Error moving task to top: \n$e');
    }
    notifyListeners();
    writeTasksToFile();
  }

  // void moveTaskToTop(Task currentTask, int index) {
  //   for (int i = index; i > 0; i--) {
  //     _listsAndTasks[currentList][i] = _listsAndTasks[currentList][i - 1];
  //   }
  //   _listsAndTasks[currentList][0] = currentTask;
  //   notifyListeners();
  //   writeTasksToFile();
  // }


  void writeListsToFile() {
    try {
      print('Writing lists to file');
      int i = 0;
      for (String list in _listsAndTasks.keys) {
        MapEntry<String, File> toWrite = MapEntry(list, taskFiles[list]!);
        // print('toWrite is $toWrite');
        FileMode mode = i == 0 ? FileMode.write : FileMode.append;
        listFile!.writeAsStringSync('${listToJson(toWrite)}\n', mode: mode);
        // listFile.writeAsStringSync('$list\n', mode: mode);
        i++;
      }
    } catch (e) {
      print('Error writing lists to file: \n$e');
    }
  }

  void writeTasksToFile() {
    // print('_listsAndTasks in writeTasksToFile() is $_listsAndTasks');
    try {
      print('currentList in writeTasksToFile() is $currentList');
      print('_listsAndTasks[currentList] in writeTasksToFile() is ${_listsAndTasks[currentList]}');

      if (_listsAndTasks[currentList]!.length == 0){
        taskFiles[currentList]!.delete();
      } else {
        int i = 0;
        for (Task entry in _listsAndTasks[currentList]!) {
          FileMode mode = i == 0 ? FileMode.write : FileMode.append;
          taskFiles[currentList]!.writeAsStringSync('${taskToJson(entry)}\n', mode: mode);
          i++;
        }
      }
    } catch (e) {
      print('Error writing tasks to file: \n$e');
    }
  }

  Map<String, File> listFromJson(Map<String, dynamic> json) {
    String list = json['list'];
    String path = json['path'];
    Map<String, File> map = {list: File(path)};
    return map;
  }

  Map<String, dynamic> listToJson(MapEntry<String, File> entry) {
    // print("entry in listToJson is $entry");
    // print("entry.value in listToJson is ${entry.value}");
    return {'\"list\"': '\"${entry.key}\"', '\"path\"': '\"${entry.value.path}\"'};
  }

  Task taskFromJson(Map<String, dynamic> json) {
    String text = json['task'];
    String doneString = json['isDone'];
    bool isDone = doneString == 'true' ? true : false;
    Task task = Task(taskText: '$text', isDone: isDone);
    return task;
  }

  /// Produces a Map:
  /// {
  ///   '\"task\"': '$jsonEncodedTaskText',
  ///   '\"isDone\"': '\"true\"' or '\"false\"'
  /// }
  Map<String, String> taskToJson(Task entry) {
    String taskText = entry.toString();
    // print('taskText before jsonEncode is $taskText');
    String jsonEncodedTaskText = jsonEncode(taskText);
    // String formattedTaskText = taskText.replaceAll('"', '\\"');  //Also works, but less general
    // print('taskText after jsonEncode is $jsonEncodedTaskText');

    return {'\"task\"': '$jsonEncodedTaskText', '\"isDone\"': '\"${entry.isDone}\"'};
    // return {'\"task\"': '\"$entry\"', '\"isDone\"': '\"${entry.isDone}\"'};
  }

  UnmodifiableListView<String> get lists {
    return UnmodifiableListView<String>(_listsAndTasks.keys);
  }

  ///Never returns null. (May return [].)
  UnmodifiableListView<Task> get tasks {
    List<Task> _tasks = _listsAndTasks[currentList] ?? [];
    return UnmodifiableListView<Task>(_tasks);
  }

  UnmodifiableMapView<String, List<Task>> get listsAndTasks {
    return UnmodifiableMapView<String, List<Task>>(_listsAndTasks);
  }

  ///Never returns null.
  int get taskCount {
    // return _tasks.length;
    int _length = _listsAndTasks.containsKey(currentList) ? _listsAndTasks[currentList]!.length : 0;
    return _length;
  }
}
