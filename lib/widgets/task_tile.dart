import 'package:flutter/material.dart';
import 'package:todoey/theme.dart';

//class TaskTile extends StatefulWidget {
class TaskTile extends StatelessWidget {
  TaskTile({
    @required this.taskText,
    @required this.isChecked,
    @required this.beingEdited,
    @required this.first,
    @required this.last,
    @required this.onTapCheckbox,
    @required this.onTapEditText,
    @required this.onTapDelete,
    @required this.onTapArrowDown,
    @required this.onLongPressArrowDown,
    @required this.onTapArrowUp,
    @required this.onLongPressArrowUp,
    this.onLongPress,
  });

//  @override
//  _TaskTileState createState() => _TaskTileState();
//}
//
//class _TaskTileState extends State<TaskTile> {
  final String taskText;
  final bool isChecked;
  final bool beingEdited;
  final bool first;
  final bool last;
  final Function onLongPress;
  final Function onTapCheckbox;
  final Function onTapEditText;
  final Function onTapDelete;
  final Function onTapArrowDown;
  final Function onLongPressArrowDown;
  final Function onLongPressArrowUp;
  final Function onTapArrowUp;


  @override
  Widget build(BuildContext context) {
    // print('Building TaskTile of "$taskText"');
    // return Container(
    return /*Container(
      color: Colors.deepPurpleAccent,
      child:*/ ListTile(
        contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
        horizontalTitleGap: 0,
        title: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 30.0),
                child: GestureDetector(
                  child: Text(taskText,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        decoration: isChecked == true ? TextDecoration.lineThrough : null,
                      )),
                  onTap: beingEdited ? (){
                    onTapEditText();
                  } : null,
                ),
              ),
            ),
            beingEdited
                ? Row(
                    children: [
                      GestureDetector(child: Icon(Icons.edit), onTap: onTapEditText),
                      GestureDetector(child: Icon(Icons.delete_forever), onTap: onTapDelete),
                      ! last ? GestureDetector(onTap: onTapArrowDown, onLongPress: onLongPressArrowDown, child: Icon(Icons.arrow_downward)/*, padding: EdgeInsets.all(0), visualDensity: VisualDensity.compact*/) : SizedBox(),
                      ! first ? GestureDetector(onTap: onTapArrowUp, onLongPress: onLongPressArrowUp, child: Icon(Icons.arrow_upward)/*, padding: EdgeInsets.all(0), visualDensity: VisualDensity.compact*/) : SizedBox(),
                    ],
                  )
                : Checkbox(
                    // I manually changed the tapTargetSize of this one to become even smaller
                    // so that I could remove outer padding
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                    splashRadius: 0,
                    value: isChecked,
                    onChanged: (newValue) async {
                      onTapCheckbox();
//                    print('newValue is $newValue, isChecked is $isChecked');
                      Future.delayed(Duration(seconds: 2), () {
                      });
                    },
//                  checkColor: Colors.black,
                    activeColor: MyThemeClass.kColorOfEverything,
                  ),
          ],
        ),
        onLongPress: onLongPress,
      // ),
    );
  }
}
