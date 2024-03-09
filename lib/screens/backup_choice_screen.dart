import 'spinner_screen.dart';
import 'backup_retrieve_screen.dart';
import 'package:todoey/models/backup.dart';
import 'package:todoey/models/task_data.dart';
import 'package:flutter/material.dart';

class BackupChoiceScreen extends StatelessWidget {
  const BackupChoiceScreen(this._myTaskData);

  final TaskData _myTaskData;

  @override
  Widget build(BuildContext context) {
    // TaskData _myTaskData = Provider.of<TaskData>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Back up'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Backup.copyableText(context, _myTaskData);
              },
              child: Text('Back up as copyable text'),
            ),
            // ElevatedButton(onPressed: () {}, child: Text('Back up as e-mail')),
            ElevatedButton(
              onPressed: () async {
                bool retrieve = false;
                String retrieveString;
                retrieveString = await Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return BackupRetrieveScreen();
                }));
                retrieve = retrieveString != null;  // True if retrieveString has a value
                // print('retrieveString is $retrieveString');
                print('retrieve is $retrieve');
                if (retrieve) {
                  Navigator.push(context, PageRouteBuilder(pageBuilder: (context, animation1, animation2){
                    print('Pushing spinner screen');
                    return SpinnerScreen();
                  },
                  transitionDuration: Duration(seconds: 0)));
                  Backup.retrieveFromBackup(_myTaskData, retrieveString);
                  Future.delayed(Duration(milliseconds: 500), (){
                    Navigator.pop(context);
                    Navigator.pop(context);
                  });
                }

                // Backup.retrieveFromBackup(retrieveString);
              },
              child: Text('Retrieve from backup'),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
