import 'package:todoey/theme.dart';
import 'package:flutter/material.dart';

class SpinnerScreen extends StatelessWidget {
  const SpinnerScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Back up')),
      body: Center(
        child: CircularProgressIndicator(color: MyThemeClass.kColorOfEverything),
      ),
      backgroundColor: Colors.white,
    );
  }
}
