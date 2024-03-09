import 'dart:convert';

void myPrettyPrint(var object) {
  try {
    printLargeStrings(myPrettyJson(object));
  } catch (e) {
    printLargeStrings('Not possible to prettyPrint. Printing as String:'
        '\n$object');
    // print('Not possible to prettyPrint. Printing as String:'
    //     '\n$object');
  }
}


///
/// prettyJson
/// Return a formatted, human readable, string.
///
/// Takes a json object and optional indent size,
/// returns a formatted String
///
/// @Map<String,dynamic> json
/// @int indent
///
/// I just copy-pasted this from the discontinued 'package:pretty_json/pretty_json.dart'
String myPrettyJson(dynamic json, {int indent = 2}) {
  var spaces = ' ' * indent;
  var encoder = JsonEncoder.withIndent(spaces);
  return encoder.convert(json);
}

void printPrettyJson(dynamic json, {int indent = 2}) {
  print(myPrettyJson(json, indent: indent));
}

// From StackOverflow:
// You can make your own print. Define this method
void printLargeStrings(String text) {
  final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}
// Use it like
// printLargeStrings("Your very long string ...");

