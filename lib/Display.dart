

import 'dart:io';

import 'package:accessible_ai/dalle.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

Future<String> LoadImage(String ImageName) async {
  Directory dir = await getApplicationDocumentsDirectory();
  String pathName = p.join(dir.path, '$ImageName.png');
  return pathName;
}

