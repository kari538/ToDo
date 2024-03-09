// import 'package:flutter/material.dart';
// // import 'package:todoey/th';
// import 'dart:math';
// import 'backup_choice_screen.dart';
// // import 'theme.';
// import 'dart:io';
// // import 'models';
// import 'package:path_provider/path_provider.dart';
// // import 'rflutter';
// import 'package:flutter/foundation.dart';
import 'package:todoey/models/backup.dart';
import 'package:todoey/theme.dart';
import 'package:flutter/material.dart';
import 'backup_choice_screen.dart';
// import 'todoey';

class BackupRetrieveScreen extends StatelessWidget {
  const BackupRetrieveScreen();

  // final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // controller.text = backupString;
    String retrieveString = '';

    return Scaffold(
      appBar: AppBar(title: Text('Back up')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  child: Text('  Paste your backup text here:', style: TextStyle(color: Colors.white),),
                  alignment: Alignment.centerLeft,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                    color: MyThemeClass.kColorOfEverything,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                    child: TextField(
                      onChanged: (value){
                        retrieveString = value;
                      },
                      autofocus: true,
                      // controller: controller,
                      maxLines: 30,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(0),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      child: Text('Cancel'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(child: Text('Retrieve'),
                      onPressed: (){
                        Navigator.pop(context, retrieveString);
                      },
                    ),
                  ],
                ),
                SizedBox(height: 10),
              ],
            ),
            elevation: 20,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
