// Android

import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

final Directory externalStorage = new Directory('/storage/emulated/0/');

Future<bool> checkPermissionReadExternalStorage() async{
  var status = await Permission.storage.status;
  if (!status.isGranted) {
    // We didn't ask for permission yet.
    status = await Permission.storage.request();
  }
  return status == PermissionStatus.granted;
}