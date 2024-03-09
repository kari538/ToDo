import 'package:flutter/material.dart';
import 'screens/tasks_screen.dart';
import 'theme.dart';
import 'package:provider/provider.dart';
import 'models/task_data.dart';
// import 'package:todoey/todoey_storage.dart';
// import 'todoe';

void main(List<String> arguments) async {
  // String colorOfEverything = arguments.first;
// void main([String colorOfEverything]) async {
  print('Running main()');
  WidgetsFlutterBinding.ensureInitialized();  //This needs to be done before finding the path...
  // await appPath;
  // await TodoeyStorage.directory;
  // await TodoeyStorage.path;
  // print('TodoeyStorage.path is ready');
  final myTaskData = TaskData();
  final myThemeClass = MyThemeClass();
  myTaskData.getSavedTasks();
  // Future doneGetTasks = myTaskData.getSavedTasks();
  // myTaskData.fakeOldAppVersion(doneGetTasks);
  // myThemeClass.getMyTheme();
  await myThemeClass.getMyTheme();
  // await, Otherwise there will be a flash of ThemeData.light() before the real theme kicks in
  print('getMyTheme() is ready');
//  print('appPath is $appPath'); //These are all instances of Future...
//  print('TodoeyStorage.directory is ${TodoeyStorage.directory}');
//  print('TodoeyStorage.path is ${TodoeyStorage.path}');
//  print('await appPath is ${await appPath}');
//  print('await TodoeyStorage.directory is ${await TodoeyStorage.directory}');
//  print('await TodoeyStorage.path is ${await TodoeyStorage.path}');

  runApp(MyApp(myTaskData, myThemeClass));
}

class MyApp extends StatelessWidget {
  const MyApp(this.myTaskData, this.myThemeClass);
  final TaskData myTaskData;
  final MyThemeClass myThemeClass;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
//      create: (context) => TaskData(),
        providers: [
          ChangeNotifierProvider<MyThemeClass>(create: (context) => myThemeClass),
          // ChangeNotifierProvider<MyThemeClass>(create: (context) => MyThemeClass()),
          ChangeNotifierProvider<TaskData>(create: (context) => myTaskData),
        ],
        builder: (context, child) {
          return MaterialApp(
            title: 'Flutter Demo',
            // theme: ThemeData.dark(),
            // theme: ThemeData.light(),
            theme: Provider.of<MyThemeClass>(context).currentTheme,
            home: TasksScreen(myTaskData, myThemeClass),
            debugShowCheckedModeBanner: false,
          );
        });
    
    //   create: (context) => myTaskData,
    //   child: MaterialApp(
    //     // theme: getMyTheme,
    //     theme: myThemeClass.myTheme,
    //     // theme: myTheme,
    //     home: TasksScreen(myTaskData),
    //     debugShowCheckedModeBanner: false,
    //   ),
    // );

    //     return ChangeNotifierProvider(
// //      create: (context) => TaskData(),
//       create: (context) => myTaskData,
//       child: MaterialApp(
//         // theme: getMyTheme,
//         theme: myThemeClass.myTheme,
//         // theme: myTheme,
//         home: TasksScreen(myTaskData),
//         debugShowCheckedModeBanner: false,
//       ),
//     );
  }
}
