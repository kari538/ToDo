import 'package:flutter/material.dart';

class MyRaisedButton extends StatelessWidget {
  const MyRaisedButton({
    required this.child,
    required this.onPressed,
    this.color = Colors.blue,
    this.textColor = Colors.white,
    this.shape = const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
    // Key key,
    Key? key,
  }) : super(key: key);
  // final Function onPressed;
  final Function? onPressed;
  final Widget child;
  // final String text;
  final Color color;
  final Color textColor;
  final OutlinedBorder shape;

  @override
  Widget build(BuildContext context) {
    // if (color != null && shape != null) {
    return ElevatedButton(
      // onPressed: onPressed,
      // onPressed: onPressed != null ? (){onPressed();} : null,
      onPressed: onPressed != null ? (){onPressed!();} : null,
      child: child,
      // child: Text('$text'),
      // From ChatGPT:
      style: ButtonStyle(
        elevation: MaterialStateProperty.resolveWith<double>(
              (Set<MaterialState> states) {
            if (states.contains(MaterialState.disabled)) {
              // Return the elevation for inactive state
              return 0; // Change to your desired inactive elevation
            }
            // Return the elevation for enabled state
            return 60; // Change to your desired active elevation
          },
        ),
        foregroundColor: MaterialStatePropertyAll<Color>(Colors.white),
        // foregroundColor: MaterialStatePropertyAll<Color>(textColor),
        shape: MaterialStatePropertyAll<OutlinedBorder>(shape),
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
            if (states.contains(MaterialState.disabled)) {
              // Return the color you want for inactive state
              // return Colors.black; // Change to your desired inactive color
              // return Colors.deepPurple.shade800; // Change to your desired inactive color
              return Colors.blueGrey.shade700.withOpacity(0.8); // Change to your desired inactive color
              // return Colors.grey; // Change to your desired inactive color
            }
            // Return the default color for enabled state
            return Colors.blue; // Change to your desired active color
          },
        ),
      ),
      // style: ButtonStyle(
      //   backgroundColor: MaterialStatePropertyAll<Color>(color),
      //   foregroundColor: MaterialStatePropertyAll<Color>(textColor),
      //   shape: MaterialStatePropertyAll<OutlinedBorder>(shape),
      // ),
    );
    // }
    // return ElevatedButton(onPressed: onPressed(), child: child);
  }
}
