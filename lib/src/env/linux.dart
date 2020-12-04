// Linux
import 'dart:io';
import 'package:path/path.dart' as path;

final Directory externalStorage = new Directory(path.current);

Future<bool> checkPermissionReadExternalStorage() async {
  return true;
}