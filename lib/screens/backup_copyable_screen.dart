import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter/services.dart';
import 'package:todoey/theme.dart';
import 'package:flutter/material.dart';

class BackupCopyableScreen extends StatelessWidget {
  BackupCopyableScreen(this.backupString);

  final String backupString;
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String newBackupString = backupString;
    controller.text = newBackupString;

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
                  child: Text(
                    '  Editable and copyable text:',
                    style: TextStyle(color: Colors.white),
                  ),
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
                      onChanged: (value) {
                        newBackupString = value;
                      },
                      autofocus: false,
                      controller: controller,
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
                    ElevatedButton(
                      child: Text('Copy all'),
                      onPressed: () {
                        try {
                          Clipboard.setData(ClipboardData(text: newBackupString));
                          Alert(
                              context: context,
                              title: "Text copied",
                              desc: "The backup text has been copied to clipboard. Paste it in a secure location"
                                  " to store it."
                                  "\n\nThis text can later be used to retrieve your lists to the app, "
                                  "should you lose them.",
                              buttons: [
                                DialogButton(
                                    child: Text('Ok'),
                                    onPressed: () {
                                      print('Pressed Ok');
                                      Navigator.pop(context);
                                    }),
                              ]).show();
                        } catch (e) {
                          Alert(
                              context: context,
                              title: "Something went wrong with copying to clipboard",
                              desc: "$e",
                              buttons: [
                                DialogButton(
                                    child: Text('Ok'),
                                    onPressed: () {
                                      print('Pressed Ok');
                                      Navigator.pop(context);
                                    }),
                              ]).show();
                        }
                        // Backup.retrieveFromBackup(retrieveString);
                      },
                    ),
                  ],
                ),
                SizedBox(height: 10),
              ],
            ),
            elevation: 20,
            // shadowColor: Colors.red,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          // child: Container(
          //   child: Padding(
          //     padding: const EdgeInsets.all(20),
          //     child: TextField(
          //       autofocus: false,
          //       controller: controller,
          //       maxLines: 10,
          //     ),
          //   ),
          //   decoration: BoxDecoration(
          //     color: Colors.white,
          //     borderRadius: BorderRadius.circular(20),
          //     boxShadow: [BoxShadow(
          //       color: Colors.grey,
          //       // offset: Offset(4, 8),
          //       spreadRadius: 5,
          //       blurRadius: 4,
          //     )],
          //   ),
          // ),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
