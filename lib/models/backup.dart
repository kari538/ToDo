import 'dart:convert';

import 'package:todoey/screens/backup_copyable_screen.dart';
import 'package:flutter/material.dart';
import 'task.dart';
import 'task_data.dart';

class Backup {
  static String _backupString = '';
  static Map<String, List<Task>> _listsAndTasks = {};
  static TaskData _myTaskData;

  static void _createBackupString() {
    _listsAndTasks = _myTaskData.listsAndTasks;

    for (String list in _listsAndTasks.keys) {
      _backupString += '# ' + list + ':\n------------------------\n';

      if (_listsAndTasks[list].length == 0) {
        _backupString += '<no tasks>\n';
      } else {
        for (Task task in _listsAndTasks[list]) {
          _backupString += '* ' + task.taskText + ', ' + '${task.isDone ? 'Done' : 'Not done'}' + '\n';
        }
      }
      _backupString += '------------------------\n\n';
    }
  }

  static void copyableText(BuildContext context, TaskData myTaskData) {
    _myTaskData = myTaskData;
    _backupString = '';
    _createBackupString();
    print(_backupString);
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return BackupCopyableScreen(_backupString);
    }));
  }

  static void email(TaskData myTaskData) {
    _myTaskData = myTaskData;
    _backupString = '';
    _createBackupString();
    print(_backupString);
  }

  static void retrieveFromBackup(TaskData myTaskData, String retrieveString) async {
    _myTaskData = myTaskData;
    BuildContext context; // Just a dummy context to make _myTaskData methods happy. It's ok that it's null coz it won't be used.

    // If listsAndTasks contains only the default list, and it has no tasks, let's remove it before retrieving backup:
    if (_myTaskData.listsAndTasks.length == 1 &&
        _myTaskData.listsAndTasks.containsKey(defaultList) &&
        _myTaskData.listsAndTasks[defaultList].isEmpty) {
      // The below will delete "currentList", which, given the condition, should be the defaultList
      _myTaskData.deleteList(context, true);
    }

    for (String line in LineSplitter.split(retrieveString)) {
      // print('line is $line');
      if (line.startsWith('# ')) {
        String newLine = line.replaceFirst('# ', '');
        if (newLine.endsWith(':')) newLine = newLine.replaceFirst(':', '', newLine.length - 1);
        // newLine = newLine.replaceRange(newLine.length -1, newLine.length, '');
        // print('newLine after replace is $newLine');

        int n = 2;
        for (int i = 1; i < n; i++) {
          // print('i is $i and n is $n');
          bool nameTaken = await _myTaskData.checkIfListNameTaken(newLine);
          print('Done checking if list name $newLine is taken, with result $nameTaken');
          if (nameTaken) {
            if (newLine.endsWith(' (${i - 1})')) {
              // This does not remove for new lists that already have a (?) at the end.
              int lengthToRemove = ' (${i - 1})'.length;
              newLine = newLine.replaceRange(newLine.length - lengthToRemove, newLine.length, '');
              // if (newLine.endsWith(' (${i-1})')) newLine = newLine.replaceRange(newLine.length -4, newLine.length, '');
              // print('lengthToRemove is $lengthToRemove and newLine is $newLine');
            }
            newLine = newLine + ' ($i)';
            n++;
          }
        }

        BuildContext context; // This can be null, since I've already made sure the name is unique, I mean...
        print('Adding new list $newLine');
        await _myTaskData.addList(context, newLine);
        currentList = newLine;
        print('Done adding new list $newLine');
      } else if (line.startsWith('* ')) {
        String newLine = line.replaceFirst('* ', '');
        print('newLine task after replace is $newLine');
        bool done = false;
        if (newLine.endsWith(', Done')) {
          done = true;
          newLine = newLine.replaceFirst(', Done', '', newLine.length - 6);
        } else {
          try {
            newLine = newLine.replaceFirst(', Not done', '', newLine.length - 10);
            // If for some reason, the task doesn't end with either Done or Not done,
            // that's ok, it'll just default to isDone = false.
          } catch (e) {
            print(e);
          }
        }
        print('newLine task after replace Done is $newLine. done is $done');
        _myTaskData.addTask(Task(taskText: newLine, isDone: done));
      }
    }

    // If after that whole for-loop, listsAndTasks is still empty, the retrieve text must
    // have been corrupted or empty or something else that's wrong. Then, we put back the
    // default list.
    if (_myTaskData.listsAndTasks.isEmpty) {
      _myTaskData.addList(context, defaultList);
    }
  }
}
