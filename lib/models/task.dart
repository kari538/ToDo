//import 'package:flutter/material.dart';

class Task {
  Task({
    this.taskText,
    this.isDone = false,
    this.beingEdited = false,
  });

  String taskText;
  bool isDone;
  bool beingEdited;

  void toggleDone(){
//    print('Task isDone is $isDone before');
    isDone = !isDone;
//    print('Task isDone is $isDone after');
    print('isDone for task "$taskText" is $isDone');
  }

  @override
  String toString(){
    return taskText;
  }
}