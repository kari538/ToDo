// import 'todosto';
// import 'todoe';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:todoey/todoey_storage.dart';

class MyThemeClass extends ChangeNotifier {
  static Color? kColorOfEverything;

// Color kColorOfEverything = Color(0xff673ab7);
  final String customColor = 'Custom Color';
  File? themeFile;
  Uint8List? themeBytes;
  Map<String, ThemeData>? myThemes;
  ThemeData? currentTheme;

  // ThemeData myThemes;

  static Map<String, Color> themeColors = {
    'Orange': Colors.deepOrange,
    'Blue': Colors.lightBlueAccent,
    'Light Black': Colors.black54,
    'Black': Colors.black87,
    'Light Purple': Colors.deepPurple,
    'Purple': Colors.deepPurple.shade900,
    'Green': Colors.green.shade800,
    'Red': Colors.red.shade800,
    'Light Pink': Colors.pinkAccent,
    'Pink': Colors.pink,
  };

  Future getMyTheme() async {
    // await writeTheme();
    // kColorOfEverything = kColorOfEverything ?? await readTheme() ?? Colors.pink;
    kColorOfEverything = kColorOfEverything ?? await readTheme() ?? Colors.deepOrange;
    // print('kColorOfEverything in getMyTheme() is $kColorOfEverything');
    // return null;
    // print('myThemes.keys.first is ${myThemes.keys.first} of type ${myThemes.keys.first.runtimeType}');
    String colorKey = themeColors.keys.firstWhere((k) {
      return themeColors[k]?.value == kColorOfEverything!.value; // So that we start with the saved theme color if we have one
    }, orElse: () => customColor);  // If, for some reason, your app was set on a color that is no longer there as an option
    // print('themeColors is $themeColors');
    // print('colorKey is $colorKey');
    if (colorKey == customColor) {
      themeColors.addAll({colorKey: kColorOfEverything!});
      // print('themeColors is $themeColors');
      // getThemes();
    }

    // print('themeColors is $themeColors');
    myThemes = myThemes ?? getThemes();
    currentTheme = currentTheme ?? myThemes![colorKey];
    // myTheme = getTheme();
    notifyListeners();
    // print('currentTheme in getMyTheme() is $currentTheme');
    // print('currentTheme.scaffoldBackgroundColor in getMyTheme() is ${currentTheme.scaffoldBackgroundColor}');
    // print('myTheme.scaffoldBackgroundColor in getMyTheme() is ${myThemes.scaffoldBackgroundColor}');
  }

  Map<String, ThemeData> getThemes() {
    // ThemeData getTheme() {
    print('Running getThemes(). kColorOfEverything is $kColorOfEverything');

    Map<String, ThemeData> themes = {};

    try {
      for (String color in themeColors.keys) {
        double luminance = themeColors[color]!.computeLuminance();
        themes.addAll({
          // color: ThemeData.dark().copyWith(
          color: ThemeData.light().copyWith(
            scaffoldBackgroundColor: themeColors[color],
            appBarTheme: AppBarTheme().copyWith(color: themeColors[color]),
            colorScheme: ThemeData.light().colorScheme.copyWith(
                  secondary: themeColors[color]!.withOpacity(0.5),
                  // The new color of Alert buttons (DialogButtons), after accentColor was deprecated
                ),
            // The foreground color of circleAvatars if it's background is light:
            primaryColorDark: themeColors[color],
            // The foreground color of circleAvatars if it's background is dark:
            primaryColorLight: Colors.white,

            iconTheme: IconThemeData(color: themeColors[color]),
            textSelectionTheme: TextSelectionThemeData(cursorColor: themeColors[color]),
            buttonTheme: ButtonThemeData(buttonColor: themeColors[color]),
            // BottomSheet buttons
            elevatedButtonTheme: ElevatedButtonThemeData(
                style: ButtonStyle(
              foregroundColor: luminance < 0.1 ? MaterialStateProperty.all(Colors.white) : MaterialStateProperty.all(Colors.black),
              backgroundColor: MaterialStateProperty.all(themeColors[color]),
              // foregroundColor: MaterialStateProperty.all(Colors.black),
              // backgroundColor: MaterialStateProperty.all(themeColors[color].withOpacity(0.5))
              textStyle: MaterialStateProperty.all(TextStyle(fontSize: 18)),
            )),
            floatingActionButtonTheme: FloatingActionButtonThemeData().copyWith(
              backgroundColor: themeColors[color],
              foregroundColor: Colors.white,
              shape: CircleBorder(),
            ),

            textTheme: TextTheme(
              bodyText2: TextStyle(fontSize: 20, color: Colors.black), // DialogButtons in Alerts
              subtitle1: TextStyle(color: Colors.black), // PopupMenuItems
              // button: TextStyle(color: Colors.pinkAccent, backgroundColor: Colors.pinkAccent, fontSize: 20),
              // headline1: TextStyle(color: Colors.pinkAccent),
              // headline2: TextStyle(color: Colors.pinkAccent),
              // headline3: TextStyle(color: Colors.pinkAccent),
              // headline4: TextStyle(color: Colors.pinkAccent),
              // headline5: TextStyle(color: Colors.pinkAccent),
              // headline6: TextStyle(color: Colors.pinkAccent),
              // subtitle2: TextStyle(color: Colors.pinkAccent),
              // bodyText1: TextStyle(color: Colors.pinkAccent),
              // caption: TextStyle(color: Colors.pinkAccent),
              // overline: TextStyle(color: Colors.pinkAccent),
              // : TextStyle(color: Colors.pinkAccent),
              // : TextStyle(color: Colors.pinkAccent),
              // : TextStyle(color: Colors.pinkAccent),
              // : TextStyle(color: Colors.pinkAccent),
              // : TextStyle(color: Colors.pinkAccent),
              //
            ),

            bottomSheetTheme: BottomSheetThemeData(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
            ),

            inputDecorationTheme: InputDecorationTheme(
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: themeColors[color]!, width: 2),
              ),
            ),
          )
        });
      }
      // print('themes is $themes');
      // print('themes[$customColor] is ${themes['$customColor']}');
      if (themes[customColor] != null) print('themes[$customColor].scaffoldBackgroundColor is ${themes['$customColor']?.scaffoldBackgroundColor}');
    } catch (e) {
      print('Error : \n$e');
    }
    return themes;
  }

//   ThemeData getTheme() {
//     print('Running getTheme(). kColorOfEverything is $kColorOfEverything');
//     ThemeData _currentTheme = ThemeData.light().copyWith(
//       // scaffoldBackgroundColor: TaskData().themeColor,
//       scaffoldBackgroundColor: kColorOfEverything,
//       iconTheme: IconThemeData(color: kColorOfEverything),
//       textTheme: TextTheme(
//         bodyText2: TextStyle(fontSize: 20, color: Colors.black),
//         subtitle1: TextStyle(color: Colors.black),
//         button: TextStyle(color: Colors.pinkAccent, fontSize: 20),
//       ),
//       buttonTheme: ButtonThemeData(
//         buttonColor: kColorOfEverything,
// //    textTheme: ButtonTextTheme.normal,
//       ),
//       floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: kColorOfEverything),
//       bottomSheetTheme: BottomSheetThemeData(
//         backgroundColor: Colors.white,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
//       ),
//       cursorColor: kColorOfEverything,
//       accentColor: kColorOfEverything,
//       inputDecorationTheme: InputDecorationTheme(
//         focusedBorder: UnderlineInputBorder(
//           borderSide: BorderSide(color: kColorOfEverything, width: 2),
//         ),
//       ),
//     );
//
//     return _currentTheme;
//   }

  void changeTheme(String colorString) {
    print('Running changeTheme()');
    try {
      kColorOfEverything = themeColors[colorString]!;
      // print('kColorOfEverything in changeTheme() is $kColorOfEverything');
      // print('currentTheme BEFORE change is $currentTheme. '
      //     'currentTheme.scaffoldBackgroundColor is ${currentTheme.scaffoldBackgroundColor}');
      currentTheme = myThemes![colorString];
      // print('currentTheme AFTER change is $currentTheme. '
      //     'currentTheme.scaffoldBackgroundColor is ${currentTheme.scaffoldBackgroundColor}');
      notifyListeners();
      writeTheme();
    } catch (e) {
      print('Error changing theme: \n$e');
    }
  }

  Future writeTheme() async {
    try {
      themeFile = File('${await appPath}/themeFile.txt');
      MapEntry<String, Color> toWrite = MapEntry('color', kColorOfEverything!);
      // print('toWrite is $toWrite');
      FileMode mode = FileMode.write;
      themeFile!.writeAsStringSync('${themeToJson(toWrite)}\n', mode: mode);
    } catch (e) {
      print('Error writing themes: \n$e');
    }
  }

  Future<Color?> readTheme() async {
    themeFile = File('${await appPath}/themeFile.txt');
    Color? color;

    try {
      if (await themeFile!.exists()) {
        try {
          themeBytes = themeFile!.readAsBytesSync();
          // print('themeBytes is $themeBytes');
        } on Exception catch (e) {
          print(e.toString());
        }

        String line = Utf8Decoder().convert(themeBytes!);
        // print('line is $line');
        Map<String, dynamic> decodedThemeLine = jsonDecode(line);
        // print('decodedThemeLine is $decodedThemeLine');
        color = colorFromJson(decodedThemeLine);
      }
    } catch (e) {
      print('Error reading theme'
          ': \n$e');
    }
    // print('color is $color of type ${color.runtimeType}');
    assert (color != null, throw 'Color was null after all');
    return color;
  }

  Map<String, dynamic> themeToJson(MapEntry<String, Color> entry) {
    // print("entry in themeToJson is $entry");
    // print("entry.value in themeToJson is ${entry.value}");
    // print('entry.value.value in themeToJson is ${entry.value.value}');
    return {'\"${entry.key}\"': entry.value.value};
  }

  dynamic colorFromJson(Map<String, dynamic> json) {
// Color colorFromJson(Map<String, dynamic> json) {
    var colorIntFromFile = json['color'];
    // print('colorIntFromFile is $colorIntFromFile of type ${colorIntFromFile.runtimeType}');
    Color color = Color(colorIntFromFile);
    return color;
    // String text = json['task'];
    // String doneString = json['isDone'];
    // bool isDone = doneString == 'true' ? true : false;
    // Task task = Task(taskText: text, isDone: isDone);
    // return task;
  }
}

// ThemeData myTheme = ThemeData.light().copyWith(
//   scaffoldBackgroundColor: TaskData().themeColor,
//   // scaffoldBackgroundColor: kColorOfEverything,
//   iconTheme: IconThemeData(color: kColorOfEverything),
//   textTheme: TextTheme(
//     bodyText2: TextStyle(fontSize: 20, color: Colors.black),
//     subtitle1: TextStyle(color: Colors.black),
//     button: TextStyle(color: Colors.pinkAccent, fontSize: 20),
//   ),
//   buttonTheme: ButtonThemeData(
//     buttonColor: kColorOfEverything,
// //    textTheme: ButtonTextTheme.normal,
//   ),
//   floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: kColorOfEverything),
//   bottomSheetTheme: BottomSheetThemeData(
//     backgroundColor: Colors.white,
//     shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
//   ),
//   cursorColor: kColorOfEverything,
//   accentColor: kColorOfEverything,
//   inputDecorationTheme: InputDecorationTheme(
//     focusedBorder: UnderlineInputBorder(
//       borderSide: BorderSide(color: kColorOfEverything, width: 2),
//     ),
//   ),
// );
