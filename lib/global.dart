import 'package:flutter/material.dart';

// From a StackOverflow qn:
class GlobalVariable {
  static final GlobalKey<NavigatorState> navState = GlobalKey<NavigatorState>();
}
// navigatorKey: GlobalVariable.navState has to be put in the MaterialApp in main().
