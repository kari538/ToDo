import 'package:path_provider/path_provider.dart';
import 'dart:io';

//You can use appPath or TodoeyStorage.path, it doesn't matter
final Future<String> appPath = TodoeyStorage.getAppPath(TodoeyStorage.directory,
//    'acutePath'
);

class TodoeyStorage{
  static final Future<Directory> directory = getAppDirectory();
  static final Future<String> path = getAppPath(directory,
//      'AcuteStorage.path'
  );
//  static final Future<File> testFile = createFile(path);

  static Future<Directory> getAppDirectory() async {
//    print('Running getAcuteDirectory');
//     PathProviderMacOS.registerWith();
    Directory _directory = await getApplicationDocumentsDirectory();
    return _directory;
  }

  static Future<String> getAppPath(Future<Directory> _futureDirectory,
//      String from
      ) async {
//    print('Running getAcutePath from $from');
    Directory _directory = await _futureDirectory;
    return _directory.path;
  }
}
